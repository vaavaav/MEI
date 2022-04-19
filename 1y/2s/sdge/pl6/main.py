#!/usr/bin/env python3

# Gossip protocol

import logging
from typing import Callable, Any
from concurrent.futures import ThreadPoolExecutor
from utils.ms import exitOnError, reply, receiveAll
from state import State

logging.getLogger().setLevel(logging.DEBUG)
executor = ThreadPoolExecutor(max_workers=1)

state : State
handler : Callable[[Any], None]
node_id : str | None 

def handle_init(msg):
    global handler, state, node_id
    if msg.body.type == 'init':
        node_id = msg.body.node_id
        reply(msg, type='init_ok')
    elif msg.body.type == 'topology' and node_id != None:
        state = State(node_id, msg.body.topology.__dict__[node_id])
        handler = state.handle
        reply(msg, type='topology_ok')
    else:
        logging.warning('unknown message type %s', msg.body.type)


handler = handle_init
executor.map(lambda msg: exitOnError(handler, msg), receiveAll())