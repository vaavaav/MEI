use zmq;
use std::thread;
use std::sync::{Arc,RwLock};
use std::io::{self,Write};

fn main() {
    // accumutator to send to clients
    let accumulator = Arc::new(RwLock::new(0));

    let context = zmq::Context::new();
    let responder = context.socket(zmq::REP).unwrap();
    let f = context.socket(zmq::PUSH).unwrap();

    assert!(responder.bind("inproc://*:4440").is_ok());
    assert!(f.bind("inproc://*:4441").is_ok());

    let mut msg = zmq::Message::new();
    
    let accumulator_copy = accumulator.clone();
    thread::spawn(move || {h(accumulator_copy)});

    loop {
        print!("S >>> ");
        io::stdout().flush().unwrap();
        responder.recv(&mut msg, 0).unwrap();
        println!("{}", msg.as_str().unwrap());
        
        let acc_ref : &str = &(*accumulator.read().expect("Could not lock accumulator")).to_string();
        responder.send(acc_ref, 0).expect("Could not send message to Client");

        f.send(msg.as_str().unwrap(), 0).expect("Could not send message to F");
    }

    //... .join().unwrap();
    
}


fn h(accumulator : Arc<RwLock<i32>>) {

    let context = zmq::Context::new();
    let mut msg = zmq::Message::new();
    let pull_socket = context.socket(zmq::PULL).unwrap();
    assert!(pull_socket.bind("inproc://*:4443").is_ok());

    loop {
        pull_socket.recv(&mut msg, 0).expect("Failed to received message");
        let g_f = msg.as_str().expect("Failed to convert msg to &str")
                     .parse::<i32>().expect("Failed to convert &str to i32");
        *accumulator.write().expect("Could not lock accumulator") += g_f;

    }
}
