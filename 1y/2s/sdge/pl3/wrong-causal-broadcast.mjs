#!/usr/bin/env node

import { log as out, error as log } from 'console';
import { createInterface } from 'readline';
import { strict as assert } from 'assert';

let json = JSON.stringify;
createInterface(process.stdin).on('line', line => {
  log("received " + line);
  handle(JSON.parse(line));
});

var node_id = "";
var node_ids = [];
var msg_id = 0;

function send(node, body) {
  msg_id += 1;
  let msg = json({src: node_id, dest: node, body: {...body, msg_id: msg_id}});
  out(msg);
  log("sent " + msg);
}

function broadcast(body) {
  for (const node of node_ids)
    if (node != node_id)
      send(node, body);
}

function reply(request, body) {
  send(request.src, {...body, in_reply_to: request.body.msg_id});
}

function handle(msg) {
  let handlers = {
    init: handle_init,
    cbcast: handle_cbcast,
    fwd_msg: handle_fwd_msg,
  };
  handlers[msg.body.type](msg);
}

var vv = {};
var clocks = {};
var msgs = [];

function handle_init(msg) {
  node_id = msg.body.node_id;
  node_ids = msg.body.node_ids;
  for (const i of node_ids)
    vv[i] = 0;
  reply(msg, {type: 'init_ok'});
  log("init sender: " + msg.src);
}

function handle_cbcast(msg) {
  vv[node_id] += 1;
  reply(msg, {type: 'cbcast_ok', messages: msgs});
  msgs = [];
  broadcast({type: 'fwd_msg', vv: vv, message: msg.body.message});
}

function handle_fwd_msg(msg) {
  msgs.push(msg.body.message);
}

