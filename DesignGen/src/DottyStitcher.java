import java.util.HashMap;
import java.util.Map;

import com.xilinx.rapidwright.design.Design;
import com.xilinx.rapidwright.design.Module;
import com.xilinx.rapidwright.design.ModuleInst;
import com.xilinx.rapidwright.edif.EDIFCell;
import com.xilinx.rapidwright.edif.EDIFCellInst;
import com.xilinx.rapidwright.edif.EDIFDirection;
import com.xilinx.rapidwright.edif.EDIFNet;
import com.xilinx.rapidwright.edif.EDIFPort;
import com.xilinx.rapidwright.edif.EDIFPortInst;
import com.xilinx.rapidwright.placer.blockplacer.BlockPlacer2;
import com.xilinx.rapidwright.placer.handplacer.HandPlacer;
import com.xilinx.rapidwright.router.Router;
import com.xilinx.rapidwright.tests.CodePerfTracker;
import com.xilinx.rapidwright.util.FileTools;

public class DottyStitcher {

	private static String clk = "clk";
	
	private static boolean HAND_PLACER_ENABLED = false;
	private static boolean ROUTER_ENABLED = false;
	
	/**
	 * Creates a top level port in the netlist (like 'Clock') and connects it to
	 * a net of the same name.  If it already exists, it just returns the existing net.
	 * @param top Top design cell
	 * @param name Name of the port and net
	 * @param dir Port direction
	 * @return The net in the top cell 
	 */
	private static EDIFNet createOrGetTopLevelPortNet(EDIFCell top, EDIFDirection dir, String name) {
		EDIFPort topPort = top.getPort(name);
		if(topPort == null) {
			topPort = top.createPort(name, dir, 1);
		}
		EDIFNet topNet = top.getNet(name);
		if(topNet == null) {
			topNet = top.createNet(name);
			topNet.createPortInst(topPort);
		}		
		return topNet;
	}
	
	private static void connect(Design design, String src, String snk) {
		String srcModuleInstName = src.substring(0, src.indexOf(':'));
		String srcPortName = src.substring(src.indexOf(':')+1);
		ModuleInst srcModuleInst = design.getModuleInst(srcModuleInstName);
		EDIFPort srcPort = srcModuleInst.getCellInst().getPort(srcPortName);
		
		String snkModuleInstName = snk.substring(0, snk.indexOf(':'));
		String snkPortName = snk.substring(snk.indexOf(':')+1);
		ModuleInst snkModuleInst = design.getModuleInst(snkModuleInstName);
		EDIFPort snkPort = snkModuleInst.getCellInst().getPort(snkPortName);
		
		// Hopefully bus widths match, but if they don't connect only the fewer bus wires...
		int width = snkPort.getWidth() < srcPort.getWidth() ? snkPort.getWidth() : srcPort.getWidth();

		if(width == 1){
			srcModuleInst.connect(srcPortName, snkModuleInst, snkPortName, -1);
		} else {
			for (int i = 0; i < width; i++) {
				srcModuleInst.connect(srcPortName, snkModuleInst, snkPortName, i);
			}
		}
		
	}
	
	private static void connectTopLevelPortToModule(Design design, String port, EDIFDirection dir, String modulePort) {

		// Connect to the module
		String moduleInst = modulePort.substring(0, modulePort.indexOf(':'));
		String portName = modulePort.substring(modulePort.indexOf(':')+1).replace(";", "");
		EDIFCellInst cellInst = design.getTopEDIFCell().getCellInst(moduleInst);
		int width = cellInst.getPort(portName).getWidth();
		
		// Get/Create port
		
		
		if(width > 1) {
			for(int i=0; i < width; i++) {
				EDIFNet net = createOrGetTopLevelPortNet(design.getTopEDIFCell(), dir, port + "["+i+"]");
				net.createPortInst(portName, i, cellInst);
			}
		}else {
			EDIFNet net = createOrGetTopLevelPortNet(design.getTopEDIFCell(), dir, port);
			net.createPortInst(portName, cellInst);
		}
				
	}
	
	public static Design createDesignFromDotty(String dotFile, String partname, Map<String,Module> modules) {
		Design design = null;
		for(String line : FileTools.getLinesFromTextFile(dotFile)) {
			line = line.trim();
			if(line.length() == 0) continue;
			if(line.startsWith("#")) continue;
			String[] tokens = line.trim().split("\\s+");
			if(line.contains("digraph")) {
				design = new Design(tokens[1], partname);
				for(Module m : modules.values()) {
					design.getNetlist().migrateCellAndSubCells(m.getNetlist().getTopCell());
				}
			}else if(line.contains(" -> ")) {
				tokens[2] = tokens[2].replace(";", "");
				if(!tokens[0].contains(":")) {
					connectTopLevelPortToModule(design, tokens[0], EDIFDirection.INPUT, tokens[2]);						
				} else if(!tokens[2].contains(":")) {
					connectTopLevelPortToModule(design, tokens[2], EDIFDirection.OUTPUT, tokens[0]);
				} else {
					connect(design, tokens[0], tokens[2]);
				}
			}else if(line.contains("label=")) {
				String instanceName = tokens[0];
				// This code is a bit hacky to get the name...
				String moduleName = tokens[1].replace("[label=\"", "").replace("\"];", "");
				Module module = modules.get(moduleName);
				ModuleInst mi = design.createModuleInst(instanceName, module);
				mi.place(module.getAnchor().getSite());
			}
		}
		return design;
	}
	
	
	private static String getMetadata(String dcpFileName) {
		return dcpFileName.replace(".dcp","_0_metadata.txt");
	}
	
	private static Module loadModule(String dcpFileName) {
		Design design = Design.readCheckpoint(dcpFileName,CodePerfTracker.SILENT);
		String metadata = getMetadata(dcpFileName);
		Module module = new Module(design, metadata);
		return module;
	}
	
	public static void main(String[] args) {
		if(args.length != 4) {
			System.out.println("USAGE: <dot file> <rectangle.dcp> <ellipse.dcp> <output.dcp>");
			return;
		}
		
		CodePerfTracker t = new CodePerfTracker("Dotty Graph Design Stitcher");
		
		t.start("Reading Module DCPs");
		// Load and create modules
		Module rectangle = loadModule(args[1]);  
		Module ellipse   = loadModule(args[2]);
		// Map DCP modules to names in dot file
		Map<String,Module> modules = new HashMap<>();
		modules.put("Rectangle", rectangle);
		modules.put("Ellipse", ellipse);
		
		// Stitch blocks together according to Dotty Graph
		t.stop().start("Stitch Design");
		Design design = createDesignFromDotty(args[0], "xc7a100tcsg324-1", modules);
		
		// Place the blocks
		t.stop().start("Block Placer");
		BlockPlacer2 placer = new BlockPlacer2();
		placer.verbose = false;
		placer.DEBUG_LEVEL = 0;
		placer.placeDesign(design, false);
		
		if(HAND_PLACER_ENABLED) {
			t.stop().start("Hand Placer Inspection");
			HandPlacer.openDesign(design);			
		}
		
		// Route the interconnected routed between blocks
		if(ROUTER_ENABLED) {
			t.stop().start("Router");
			Router router = new Router(design);
			router.routeDesign();
		}
		
		// Write out connected design
		t.stop().start("Write output DCP");
		design.setAutoIOBuffers(false);
		design.setDesignOutOfContext(true);
		design.writeCheckpoint(args[3], CodePerfTracker.SILENT);
		t.stop().printSummary();
	}
}
