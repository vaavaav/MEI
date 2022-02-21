import java.io.IOException;
import java.nio.ByteBuffer;

public interface Handler {

    public void handleRead(ByteBuffer in) throws IOException ;
    public void handleWrite() throws IOException;
}