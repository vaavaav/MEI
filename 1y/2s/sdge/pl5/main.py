#!/usr/bin/env python3

# Gossip protocol

import logging
from typing import Callable, Any
from concurrent.futures import ThreadPoolExecutor
from utils.ms import exitOnError, reply, receiveAll
from state.state import State

logging.getLogger().setLevel(logging.DEBUG)
executor = ThreadPoolExecutor(max_workers=1)

state : State
handler : Callable[[Any], None]

def handle_init(msg):
    global handler, state
    if msg.body.type == 'init':
        node_id = msg.body.node_id
        nodes = msg.body.node_ids
        nodes.remove(node_id) 
        state = State(node_id, nodes)
        handler = state.handle
        reply(msg, type='init_ok')
    else:
        logging.warning('unknown message type %s', msg.body.type)


handler = handle_init
executor.map(lambda msg: exitOnError(handler, msg), receiveAll())