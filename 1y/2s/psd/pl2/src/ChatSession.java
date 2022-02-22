import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.Channel;
import java.nio.channels.SelectionKey;
import java.nio.channels.SocketChannel;

public class ChatSession implements Handler {
    
    private ByteBuffer stored; // possibly a queue...

    public ChatSession() {
        stored = ByteBuffer.allocate(100);
    }
    public void handleRead(ByteBuffer in) throws IOException {
        stored.put(in);
    }
    public ByteBuffer handleWrite() throws IOException {
        
        var r = stored.duplicate().flip(); 
        stored.flip().compact();
        return r;
    }
}