from typing import Any
import logging
import math
import random
from utils.ms import reply, send

C = 10
Hop_Limit = 4

class State():
    _fanout : int
    _nodes  : list[str]
    _node_id: str
    _messages: dict[Any, Any]

    def __init__(self, node_id: str, node_ids : list[str]) -> None:
        self._node_id = node_id
        self._nodes = node_ids
        self._fanout = int(math.log10(len(self._nodes))) + C
        self._messages = {}

        
    def handle(self, msg) -> None:
        try:
            getattr(self, 'handle_' + msg.body.type)(msg)
        except AttributeError:
            logging.warning('unknown message type %s', msg.body.type)
    
    def handle_topology(self, msg) -> None:
        reply(msg, type='topology_ok')
    
    def handle_broadcast(self, msg) -> None:
        if msg.body.message not in self._messages.keys():
            self._messages[msg.body.message] = msg.body.message
            for n in random.sample(self._nodes, self._fanout):
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
            for n in random.sample(self._nodes, self._fanout):
                send(self._node_id, n, type='IHAVE', message=msg.body.id)

    def handle_read(self, msg) -> None:
        reply(msg, type='read_ok', messages=list(self._messages))