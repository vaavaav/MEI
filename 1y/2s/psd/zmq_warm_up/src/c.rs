use std::io::{self, BufRead};

fn main() {
   
    println!("Connecting to server...\n");

    let context = zmq::Context::new();
    let requester = context.socket(zmq::REQ).unwrap();

    assert!(requester.connect("tcp://localhost:4440").is_ok());

    let mut msg = zmq::Message::new();
    let stdin = io::stdin();

    loop {
        for line in stdin.lock().lines() {
            
            let v = line.expect("could not read value")
                        .parse::<i32>().expect("value is not numeric");
            requester.send(&v.to_string(), 0).expect("could not send ");
            
            requester.recv(&mut msg, 0).expect("could not received msg");
            println!("C >>> {}", msg.as_str().expect("could not parse msg to string"));
        }
    }   
}