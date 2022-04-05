use zmq;
use std::io::{self,Write};

#[inline(always)]
fn f(x : i32) -> i32 {
    x*x
}

fn main() {

    let context = zmq::Context::new();
    let f_socket = context.socket(zmq::PULL).unwrap();
    // vvvvv : to remove
    let h_socket = context.socket(zmq::PUSH).unwrap();

    assert!(f_socket.connect("inproc://localhost:4441").is_ok());
    // vvvvv : to remove
    assert!(h_socket.connect("inproc://localhost:4443").is_ok());

    let mut msg = zmq::Message::new();

    loop {
        print!("F >>> ");
        io::stdout().flush().unwrap();
        f_socket.recv(&mut msg, 0).unwrap();
        println!("{}", msg.as_str().unwrap());
        
        let v : i32 = msg.as_str().expect("could not read value")
                         .parse::<i32>().expect("value is not numeric");

        h_socket.send(&(f(v).to_string()), 0).expect("Could not send message to H");
    }

    //... .join().unwrap();
    
}

