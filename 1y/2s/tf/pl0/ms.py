# Minimal support for Maelstrom node programs

import logging
from sys import stdin
from json import loads, dumps
from types import SimpleNamespace as sn
from os import _exit

msg_id = 0

def send(src, dest, **body):
    global msg_id
    data = dumps(sn(dest=dest, src=src, body=sn(msg_id=(msg_id:=msg_id+1), **body)), default=vars)
    logging.debug("sending %s", data)
    print(data, flush=True)

def reply(request, **body):
    send(request.dest, request.src, in_reply_to=request.body.msg_id, **body)

def receiveAll():
    while data := stdin.readline():
        logging.debug("received %s", data.strip())
        yield loads(data, object_hook=lambda x: sn(**x))
    
def exitOnError(fn, *args):
    try:
        fn(*args)
    except:
        logging.exception("fatal exception in handler")
        _exit(1)
