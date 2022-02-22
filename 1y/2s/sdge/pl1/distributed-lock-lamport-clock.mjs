#!/usr/bin/env node

import { log as out, error as log } from 'console';
import { createInterface } from 'readline';

let json = JSON.stringify;
createInterface(process.stdin).on('line', line => {
  log("received " + line);
  handle(JSON.parse(line));
});

var node_id = "";
var node_ids = [];
var msg_id = 0;

var aquired = null;
var requests = [];

function reply(request, body) {
  msg_id += 1;
  let new_body = { ...body, msg_id: msg_id, in_reply_to: request.body.msg_id};
  let rep = json({src: node_id, dest: request.src, body: new_body});
  out("sent " + rep);
}
function handleInit(request) {
  node_id = body.node_id;
  node_ids = body.node_ids;
  // remove itself
  const index = node_ids.indexOf(node_id);
  if(index != -1) {
    node_ids.splice(index, 1);
  }

  reply(request, {type: 'init_ok'});
}

function handleLock(request) {
  
}

function handleUnlock(request) {
}


function handle(request) {
  let body = request.body;
  switch (body.type) {
    case 'init':
      handleInit(request);
      break;
    case 'lock':
      handleLock(request);
      break;
    case 'unlock':
      handleUnlock(request);
      break;
  }
}

