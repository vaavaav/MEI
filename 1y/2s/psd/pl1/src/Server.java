import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public class Server {
    
    private static int port = 12345;
    private static List<SocketChannel> clients = new ArrayList<>(); 
    private static ReentrantReadWriteLock lock = new ReentrantReadWriteLock();  

    public static void main(String[] args) throws IOException{

        // opens socket channel
        ServerSocketChannel ss = ServerSocketChannel.open();
        ss.bind(new InetSocketAddress(port));

        while (true) {
            
            SocketChannel s = ss.accept();
            try{
                lock.writeLock().lock();
                clients.add(s);
                new Thread(() -> {receive(s);}).start();
            } finally {
                lock.writeLock().unlock();
            }
        }
    }

    private static void broadcast(SocketChannel s, ByteBuffer message) throws IOException {
        try {
            lock.readLock().lock();
            
            var cs = new ArrayList<SocketChannel>(clients);
            // remove source
            cs.remove(s);

            for ( var ss : cs ) {
                message.flip();
                ss.write(message);
            }

        } finally {
            lock.readLock().unlock();
        }
    }

    private static void receive(SocketChannel s) {
        ByteBuffer buf = ByteBuffer.allocate(100);
        
        try {
            while (true) {
                s.read(buf);
                broadcast(s, buf.duplicate());
                buf.clear();
            }
        } catch (IOException e) {
            System.err.println(e.getMessage());
        }

    }
}