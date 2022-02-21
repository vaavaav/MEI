import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.channels.spi.SelectorProvider;
import java.util.Iterator;

public class Server {

    public static void main(String[] args) throws Exception {

        Selector sel = SelectorProvider.provider().openSelector();
    
        ServerSocketChannel ss = ServerSocketChannel.open();
        ss.bind(new InetSocketAddress(12345));
        ss.configureBlocking(false);
        ss.register(sel, SelectionKey.OP_ACCEPT);
    
        while(true) {
            sel.select();
            for(Iterator<SelectionKey> i = sel.selectedKeys().iterator(); i.hasNext(); ) {
                SelectionKey key = i.next();
    
                if (key.isAcceptable()) {
                    SocketChannel s = ss.accept();
                    
                    if (s!=null) {
                        s.configureBlocking(false);
                        SelectionKey nkey = s.register(sel, SelectionKey.OP_READ);
                        nkey.attach(new ChatSession(key));
                    }
            
                } else if (key.isReadable()) {
                    Handler h = (Handler) key.attachment();
                    ByteBuffer buf = ByteBuffer.allocate(100);
                    ((SocketChannel) key.channel()).read(buf);
                    h.handleRead(buf);
                } else if (key.isWritable()) {
                    Handler handler = (Handler)key.attachment();
                    handler.handleWrite();
                } 
                
                i.remove();
            }
        }
        
    }
}

