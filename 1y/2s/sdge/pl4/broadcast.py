#!/usr/bin/env python3

# Gossip protocol

import logging
import math
from random import sample
from ms import receiveAll, reply, send

logging.getLogger().setLevel(logging.DEBUG)


# Constant
C = 10

fanout : int | None = None
neighbours : list[str] = []
messages : set[any] = set()
node_id : str | None = None 

for msg in receiveAll():
    if msg.body.type == 'init':
        node_id = msg.body.node_id
        # Just because the work assignment says so!!!
        neighbours = msg.body.node_ids
        neighbours.remove(node_id)
        fanout = int(math.log10(len(neighbours))) + C
        neighbours = sample(neighbours, fanout)
        #
        logging.info('node %s initialized', node_id)
        reply(msg, type='init_ok')
    elif msg.body.type == 'topology':
        #logging.info('topology received in %s', node_id)
        #neighbours = msg.body.topology[node_id]
        reply(msg, type='topology_ok')
    elif msg.body.type == 'broadcast':
        logging.info('broadcast request in %s', node_id)
        if msg.body.message not in messages:
            messages.add(msg.body.message)
            for n in neighbours:
                send(node_id, n, type='rumor', message=msg.body.message)
        reply(msg, type='broadcast_ok')
    elif msg.body.type == 'read':
        logging.info('read request in %s', node_id)
        reply(msg, type='read_ok', messages=list(messages))
    elif msg.body.type == 'rumor':
        if msg.body.message not in messages:
            logging.info('%s gossiped to %s', msg.src, node_id)
            for n in neighbours:
                send(node_id, n, type='rumor', message=msg.body.message)
        else: 
            logging.info('%s is cringe', msg.src, node_id)
    else:
        logging.warning('unknown message type %s', msg.body.type)