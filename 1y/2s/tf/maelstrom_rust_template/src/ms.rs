use log::{debug, warn};
use std::io::{self, Write, BufRead};
use std::sync::atomic::{AtomicI32, Ordering};
use json::{object, JsonValue};

static MSG_ID : AtomicI32 = AtomicI32::new(0);

pub fn send(src : &str, dest : &str, mut body : JsonValue) {
    let new_msg_id = MSG_ID.fetch_add(1, Ordering::Relaxed);
    
    let mut data = object!{
        "src": src,
        "dest": dest,
    };
    data["body"] = body.take();

    data["body"]["msg_id"] = (new_msg_id + 1).into();

    debug!("sending {}", data.dump());

    println!("{}", data.dump());
    io::stdout().flush().unwrap();
}

pub fn reply(request : JsonValue, mut body : JsonValue) {

    if let (Some(src), Some(dest)) = (request["src"].as_str(), request["src"].as_str()) {
        body["in_reply_to"] = request["body"]["msg_id"].clone();
        send(src, dest, body);
    } else {
        warn!("unknown src and dest values in {}", request);
    }
}

pub fn receive_all() -> Vec<JsonValue>{

    let mut result : Vec<JsonValue> = Vec::new();

    for data in io::stdin().lock().lines() {
        if let Ok(msg) = data {
            debug!("received {}", msg.trim());
            result.push(json::parse(msg.trim()).unwrap())
        } 
    }

    result
}