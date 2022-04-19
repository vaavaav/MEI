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
    _nodes  : dict[str, int]
    _node_id: str
    _messages: dict[Any, Any]

    def __init__(self, node_id: str) -> None:
        self._node_id = node_id
        self._nodes = {}
        self._messages = {}
        Thread(target=self.update).start()
        
    def handle(self, msg) -> None:
        try:
            getattr(self, 'handle_' + msg.body.type)(msg)
        except AttributeError:
            logging.warning('unknown message type %s', msg.body.type)
    
    def handle_topology(self, msg) -> None:
        self._nodes = dict.fromkeys(msg.body.topology[self._node_id], 0)
        reply(msg, type='topology_ok')
    
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

    def handle_shuffle(self, msg) -> None:

        random_nodes = dict(random.sample(list(self._nodes.items()), k=min(len(self._nodes), SHUFFLE_LENGTH - 1)))
        
        if len(msg.body.nodes) + len(self._nodes) > SHUFFLE_LENGTH :
            for n in random_nodes.keys():
                self._nodes.pop(n)

        # todo: remove duplicates

        for e in msg.body.nodes.items():
            self._nodes[e[0]] = e[1]

        reply(msg, type='shuffle_ok', nodes=random_nodes)



    def handle_shuffle_ok(self, msg) -> None:
        

    def update(self) -> None:
        while True:
            sleep(PULSE)
            send(self._node_id, self._node_id, type='update')