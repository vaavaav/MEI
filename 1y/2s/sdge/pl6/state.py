from os import remove
from typing import Any
import logging
import random
from utils.ms import reply, send
from threading import Thread
from time import sleep
from operator import itemgetter

PULSE = 1 # (seconds)
SHUFFLE_LENGTH  = 5 # max number of neighbours per node 

class State():
    _nodes: dict[str, int]
    _node_id: str
    _messages: dict[Any, Any]
    _cache_cyclon: dict[str, list[str]]

    def __init__(self, node_id: str, nodes: list[str]) -> None:
        self._node_id = node_id
        self._nodes = dict.fromkeys(nodes, 0)
        self._messages = {}
        self._cache_cyclon = {}
        Thread(target=self.update).start()
        
    def handle(self, msg) -> None:
        try:
            getattr(self, 'handle_' + msg.body.type)(msg)
        except AttributeError:
            logging.warning('unknown message type %s', msg.body.type)
    
    def handle_broadcast(self, msg) -> None:
        if msg.body.message not in self._messages.keys():
            self._messages[msg.body.message] = msg.body.message
            for n in self._nodes.keys():
                send(self._node_id, n, type='IHAVE', id=msg.body.message)
        reply(msg, type='broadcast_ok')
    
    def handle_IHAVE(self, msg) -> None:
        if msg.body.id not in self._messages.keys():
            self._messages[msg.body.id] = 'whatever'
            reply(msg, type='IWANT', id=msg.body.id)

    def handle_IWANT(self, msg) -> None:
        if msg.body.id in self._messages.keys():
            reply(msg, type='gossip', id=msg.body.id, message=self._messages[msg.body.id])
        
    def handle_gossip(self, msg) -> None:
        if msg.body.id not in self._messages.keys():
            self._messages[msg.body.id] = msg.body.message
            for n in self._nodes.keys():
                send(self._node_id, n, type='IHAVE', message=msg.body.id)

    def handle_read(self, msg) -> None:
        reply(msg, type='read_ok', messages=list(self._messages))
    
    def handle_update(self, msg) -> None:

        # 1. increase by one the age of all neighbors
        self._nodes = dict((x[0], x[1] + 1) for x in self._nodes.items())

        # 2. Select neighbor Q with the highest age among all neighbors, 
        oldest_node = max(self._nodes.items(), key=itemgetter(1))[0]
        # and shuffle length − 1 other random neighbors.
        random_nodes = dict(random.sample(list(self._nodes.items()), k=min(len(self._nodes), SHUFFLE_LENGTH - 1)))

        # 3. Replace Q’s entry with a new entry of age 0 and with P’s address.
        random_nodes.pop(oldest_node)
        random_nodes[self._node_id] = 0

        # 4. Send the updated subset to peer Q.
        send(self._node_id, oldest_node, type='shuffle', nodes=random_nodes)

        # (4.2) save in cache so that later you can remove the ones sent if there is no space available
        self._cache_cyclon[oldest_node] = list(random_nodes.keys())

    def handle_shuffle(self, msg) -> None:

        random_nodes = dict(random.sample(list(self._nodes.items()), k=min(len(self._nodes), SHUFFLE_LENGTH - 1)))
        
        # insert only NEW entries
        for x in msg.body.nodes.items():
            if x[0] not in self._nodes: 
                self._nodes[x[0]] = x[1]

        # remove needed elems to have space for NEW entries
        for x,_ in zip(random_nodes, range(SHUFFLE_LENGTH, len(self._nodes))):
            self._nodes.pop(x)

        reply(msg, type='shuffle_ok', nodes=random_nodes)



    def handle_shuffle_ok(self, msg) -> None:
        # 5. Receive from Q a subset of no more that i of its own entries.
        entries = msg.body.nodes
        # 6. Discard entries pointing at P and entries already contained in P’s cache.
        entries.pop(self._node_id)
        for e in entries:
            if e in self._node_id:
                entries.pop(e)
        '''
         7. Update P's cache to include all remaining entries, by firstly using empty
            cache slots (if any), and secondly replacing entries among the ones sent
            to Q.
        '''
        for x in entries.items():
          self._nodes[x[0]] = x[1]
        # remove needed elems to have space for NEW entries
        for x,_ in zip(self._cache_cyclon[msg.src], range(SHUFFLE_LENGTH, len(self._nodes))):
            self._nodes.pop(x)
        self._cache_cyclon.pop(msg.src)

            

    def update(self) -> None:
        while True:
            sleep(PULSE)
            send(self._node_id, self._node_id, type='update')