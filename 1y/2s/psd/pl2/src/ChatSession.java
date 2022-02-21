import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.channels.SelectionKey;

public class ChatSession implements Handler {
    
    private ByteBuffer stored; // possibly a queue...
    public ChatSession(SelectionKey key) {
    // initialization
    }
    public void handleRead(ByteBuffer in) throws IOException {
    // store input
    }
    public void handleWrite() throws IOException {
    // write from stored
    }
}