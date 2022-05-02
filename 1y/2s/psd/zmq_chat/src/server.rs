use zmq::{SocketType, Socket, Context};
use std::collections::HashMap;

fn main() {

    let ctx = Context::new();
    let rooms : HashMap<String, Socket> = HashMap::new();

    

    println!("Hello, world!");
}