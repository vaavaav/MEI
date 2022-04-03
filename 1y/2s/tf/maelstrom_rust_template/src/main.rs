use log::{info,warn};
use json::{object, JsonValue};
mod ms;
use ms::{reply, receive_all, Handler};

pub struct Context {
    node_id: String,
    node_ids: Vec<String>,
}

impl Handler for Context {
    fn handle(&mut self, msg : JsonValue) {
        match msg["body"]["type"].as_str().unwrap() {
            "init" => {
                self.node_id = msg["body"]["node_id"] .to_string();
                self.node_ids = msg["body"]["node_ids"].members().map(|o| o.to_string()).collect();
                info!("node {} initialized", self.node_id);
                reply(msg, object!{"type" : "init_ok"});
            },
            "echo" => {
                let echo_msg = msg["body"]["echo"].clone();
                reply(msg, object!{"type" : "echo_ok", "echo" : echo_msg});
            },
            _ => warn!("unknown message type {}", msg.dump())
        }
    }
}

fn main() {

    receive_all(&mut Context{node_id: String::new(), node_ids: vec![] });
}
