import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.nio.channels.ServerSocketChannel;
import java.nio.channels.SocketChannel;
import java.nio.channels.spi.SelectorProvider;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class Server {

    public static void main(String[] args) throws Exception {

        Selector sel = SelectorProvider.provider().openSelector();
        List<SelectionKey> clients = new ArrayList<>();
    
        ServerSocketChannel ss = ServerSocketChannel.open();
        ss.bind(new InetSocketAddress(12345));
        ss.configureBlocking(false);
        ss.register(sel, SelectionKey.OP_ACCEPT);
    
        while(true) {
            sel.select();
            var keys = sel.selectedKeys().stream().toList();
            for(SelectionKey key : keys) {

                if (key.isAcceptable()) {
                    SocketChannel s = ss.accept();
                    
                    if (s!=null) {
                        System.out.println("accepted");
                        s.configureBlocking(false);
                        SelectionKey nkey = s.register(sel, SelectionKey.OP_READ);
                        nkey.attach(new ChatSession());
                        clients.add(nkey);
                    }
            
                } else if (key.isReadable()) {
                    ByteBuffer buf = ByteBuffer.allocate(100);
                    var socketChannel = (SocketChannel) key.channel();

                    if (socketChannel.read(buf) < 0) {
                        key.cancel();
                        socketChannel.close();
                    } else {
                        buf.flip();
                        var clientsExceptSource = new ArrayList<SelectionKey>(clients); 
                        clientsExceptSource.remove(key);
                        for(var k : clientsExceptSource ) {
                            System.out.println("entrei");
                            ((Handler) k.attachment()).handleRead(buf.duplicate());
                            k.interestOps( k.interestOps() | SelectionKey.OP_WRITE);
                        }
                    }
                } else if (key.isWritable()) {
                    var out = ((Handler) key.attachment()).handleWrite();
                    ((SocketChannel) key.channel()).write(out);
                    key.interestOps(key.interestOps() & ~SelectionKey.OP_WRITE);
                } 
            }
            sel.selectedKeys().clear();
        }
        
    }
}

