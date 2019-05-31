import com.fazecast.jSerialComm.*;
import components.RenderComponent;

import java.nio.ByteBuffer;
import java.util.ArrayList;

public class RenderConfigurator {

    private static SerialPort serialPort = null;

    RenderConfigurator(){
        serialPort = serialPort.getCommPort("/dev/ttyUSB1");
        serialPort.setBaudRate(1000000);
    }


    public static void configure(ArrayList<RenderComponent> renderGraph) {
        for (short i = 0; i < renderGraph.size(); i++) {
            short shapeAddr = i;

            for (short regAddr = 0; regAddr < 5; regAddr++){
                short data = 0;
                switch (regAddr) {
                    case 0:
                        data = renderGraph.get(i).getXcoord();
                        break;
                    case 1:
                        data = renderGraph.get(i).getYcoord();
                        break;
                    case 2:
                        data = renderGraph.get(i).getWidth();
                        break;
                    case 3:
                        data = renderGraph.get(i).getHeight();
                        break;
                    case 4:
                        data = renderGraph.get(i).getColor();
                        break;
                }
                long shapeConfig = data << 24 | regAddr << 12 | shapeAddr;
                serialPort.writeBytes(ByteBuffer.allocate(5).putLong(shapeConfig).array(), 5);
            }
        }
    }
}
