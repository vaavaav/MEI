use std::env;
use std::io::{self, stdout, BufRead, Write};
use std::sync::{
    atomic::{AtomicBool, Ordering},
    Arc, Mutex,
};
use std::thread;
use zmq::{Context, Socket, SocketType};

fn main() {
    if let Some([ipub_proxy_address, isub_proxy_address]) =
        &env::args().collect::<Vec<String>>().get(1..3)
    {
        let ctx = Context::new();
        // creating publisher (and connecting to proxy)
        let publisher = ctx
            .socket(SocketType::PUB)
            .expect("error while creating pub socket");
        publisher
            .connect(isub_proxy_address)
            .expect("error while connecting to isub proxy");
        publisher.set_sndtimeo(1).unwrap();
        // creating subscriber (and connecting to proxy)
        let subscriber = {
            let sub = ctx
                .socket(SocketType::SUB)
                .expect("error while creating pub socket");
            sub.connect(ipub_proxy_address)
                .expect("error while connecting to ipub proxy");
            sub.set_rcvtimeo(1).unwrap();
            Arc::new(Mutex::new(sub))
        };

        let quit = Arc::new(AtomicBool::new(false));

        {
            let subscriber_clone = subscriber.clone();
            let quit_clone = quit.clone();
            thread::spawn(move || subscriber_loop(subscriber_clone, quit_clone));
        }

        publisher_loop(publisher, subscriber, quit);
    } else {
        eprintln!("client <publisher address>");
    }
}

fn publisher_loop(publisher: Socket, subscriber: Arc<Mutex<Socket>>, flag: Arc<AtomicBool>) {
    let mut old_room = String::from("");
    let stdin = io::stdin();
    let mut i = 0;

    loop {
        // get prompt from user
        let mut line = String::new();
        print!(" [{}]> ", i);
        stdout().flush().unwrap();
        stdin.lock().read_line(&mut line).unwrap();
        // cut entry into smaller pieces to produce a request
        let request = line.trim().split_whitespace().collect::<Vec<&str>>();
        // if it's valid then process request
        match request[..] {
            ["\\room", room_name] => {
                let su = subscriber.lock().unwrap();
                su.set_unsubscribe(old_room.as_bytes()).unwrap();
                su.set_subscribe(room_name.as_bytes()).unwrap();
                old_room = room_name.into();
            }
            ["\\quit", ..] => {
                flag.store(true, Ordering::Relaxed);
                return;
            }
            ["\\help", ..] => println!("> \\room <room name>"),
            _ => publisher
                .send(
                    format!("{} {}", old_room, request.join(" ").clone()).as_bytes(),
                    0,
                )
                .unwrap(),
        };
        i += 1;
    }
}

fn subscriber_loop(subscriber: Arc<Mutex<Socket>>, flag: Arc<AtomicBool>) {
    let mut msg = zmq::Message::new();
    while !flag.load(Ordering::Relaxed) {
        // await for notification
        if subscriber.lock().unwrap().recv(&mut msg, 0).is_ok() {
            // print notification
            println!(
                "[!] {}",
                msg.as_str()
                    .expect("error while converting message to string")
            );
        }
    }
}
