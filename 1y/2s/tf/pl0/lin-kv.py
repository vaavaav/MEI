#!/usr/bin/env python3

# Simple linearizable key-value store

import logging
from ms import receiveAll, reply

logging.getLogger().setLevel(logging.DEBUG)

store = {} # key-value store

for msg in receiveAll():
    if msg.body.type == 'init':
        node_id = msg.body.node_id
        node_ids = msg.body.node_ids
        logging.info('node %s initialized', node_id)
        reply(msg, type='init_ok')
    elif msg.body.type == 'read':
        logging.info('reading %s', msg.body.key)
        if msg.body.key in store:
            reply(msg, type='read_ok', value=store[msg.body.key])
        else:
            reply(msg, type='error', code=20, text=f'there is no entry with key \'{msg.body.key}\'')
    elif msg.body.type == 'write':
        logging.info('writing (%s,%s)', msg.body.key, msg.body.value)
        store[msg.body.key] = msg.body.value
        reply(msg, type='write_ok')
    elif msg.body.type == 'cas':
        logging.info('cas (%s,%s -> %s)', msg.body.key, msg.body.__dict__['from'], msg.body.to)
        if msg.body.key not in store : 
            reply(msg, type='error', code=20, text=f'there is no entry with key \'{msg.body.key}\'')
        elif store[msg.body.key] != msg.body.__dict__['from']:
            reply(msg, type='error', code=22, text=f'entry with key \'{msg.body.key}\' does not match with \'from\' value')
        else:
            store[msg.body.key] = msg.body.to
            reply(msg, type='cas_ok')
    else:
        logging.warning('unknown message type %s', msg.body.type)