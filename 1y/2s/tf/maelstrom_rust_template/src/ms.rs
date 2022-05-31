use json::{object, JsonValue};
use log::debug;
use std::io::{self, BufRead, Write};
use std::sync::atomic::{AtomicI32, Ordering};

pub trait Handler {
    fn handle(&mut self, msg: JsonValue);
}

static MSG_ID: AtomicI32 = AtomicI32::new(0);

pub fn send(src: &str, dest: &str, body: &JsonValue) {
    let new_msg_id = MSG_ID.fetch_add(1, Ordering::Relaxed);

    let mut data = object! {
        "src": src,
        "dest": dest,
        "body": body.clone()
    };

    data["body"]["msg_id"] = new_msg_id.into();

    debug!("sending {}", data.dump());

    println!("{}", data.dump());
    io::stdout().flush().unwrap();
}

pub fn reply(request: &JsonValue, body: &JsonValue) {
    let src = request["src"].as_str().unwrap();
    let dest = request["dest"].as_str().unwrap();
    let mut body_clone = body.clone();
    body_clone["in_reply_to"] = request["body"]["msg_id"].clone();
    send(dest, src, &body_clone);
}

pub fn receive_all(handler: &mut dyn Handler) {
    for data in io::stdin().lock().lines() {
        if let Ok(msg) = data {
            debug!("received {}", msg.trim());
            handler.handle(json::parse(msg.trim()).unwrap());
        }
    }
}
