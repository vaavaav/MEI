use log::{debug, warn};
use std::io::{self, Write, BufRead};
use std::sync::atomic::{AtomicI32, Ordering};
use json::{object, JsonValue};

pub trait Handler {
    fn handle(&mut self, msg : JsonValue);
}

static MSG_ID : AtomicI32 = AtomicI32::new(0);

pub fn send(src : &str, dest : &str, mut body : JsonValue) {
    let new_msg_id = MSG_ID.fetch_add(1, Ordering::Relaxed);
    
    let mut data = object!{
        "src": src,
        "dest": dest,
        "body": body.take()
    };

    data["body"]["msg_id"] = new_msg_id.into();

    debug!("sending {}", data.dump());

    println!("{}", data.dump());
    io::stdout().flush().unwrap();
}

pub fn reply(request : JsonValue, mut body : JsonValue) {

    if let (Some(src), Some(dest)) = (request["src"].as_str(), request["dest"].as_str()) {
        body["in_reply_to"] = request["body"]["msg_id"].clone();
        send(dest, src, body);
    } else {
        warn!("unknown src and dest values in {}", request);
    }
}

pub fn receive_all(handler : &mut dyn Handler) {
    for data in io::stdin().lock().lines() {
        if let Ok(msg) = data {
            debug!("received {}", msg.trim());
            handler.handle(json::parse(msg.trim()).unwrap());
        } 
    }
}