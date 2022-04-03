use log::warn;
use json::object;
mod ms;
use ms::{reply, receive_all};

fn main() {

    for msg in receive_all() {
        match msg["body"]["type"].as_str().unwrap() {
            "init" => reply(msg, object!{"type" : "init_ok"}),
            _ => warn!("unknown message type {}", msg.dump())
        }

    }
}
