use zmq;
use std::io::{self,Write};
use threadpool::ThreadPool;
use thread_id;

#[inline(always)]
fn g(x : i32) -> i32 {
    x*2
}

fn main() {
    let context = zmq::Context::new();
    let pool = ThreadPool::new(4);
    let f_socket = context.socket(zmq::PULL).unwrap();
    let h_socket = context.socket(zmq::PUSH).unwrap();
    assert!(f_socket.bind("tcp://*:4442").is_ok());
    assert!(h_socket.connect("tcp://localhost:4443").is_ok());
    
    pool.execute(move || {
        
        let mut msg = zmq::Message::new();    

        loop {
            print!("G{} >>> ", thread_id::get());
            io::stdout().flush().unwrap();
            f_socket.recv(&mut msg, 0).unwrap();
            println!("{}", msg.as_str().unwrap());
            
            let v : i32 = msg.as_str().expect("could not read value")
                             .parse::<i32>().expect("value is not numeric");
    
            h_socket.send(&(g(v).to_string()), 0).expect("Could not send message to H");
        }
    });

    pool.join();
}