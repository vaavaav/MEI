use zmq;
use std::io::{self,Write};

#[inline(always)]
fn f(x : i32) -> i32 {
    x*x
}

fn main() {

    let context = zmq::Context::new();
    let s_socket = context.socket(zmq::PULL).unwrap();
    let g_socket = context.socket(zmq::PUSH).unwrap();

    assert!(s_socket.connect("tcp://localhost:4441").is_ok());
    assert!(g_socket.connect("tcp://localhost:4442").is_ok());

    let mut msg = zmq::Message::new();

    loop {
        print!("F >>> ");
        io::stdout().flush().unwrap();
        s_socket.recv(&mut msg, 0).unwrap();
        println!("{}", msg.as_str().unwrap());
        
        let v : i32 = msg.as_str().expect("could not read value")
                         .parse::<i32>().expect("value is not numeric");

        g_socket.send(&(f(v).to_string()), 0).expect("Could not send message to H");
    }
    
}

