import java.io.IOException;
import java.util.*;
import java.util.stream.Stream;


import com.xilinx.rapidwright.design.Design;
import com.xilinx.rapidwright.design.Module;
import com.xilinx.rapidwright.design.ModuleInst;
import com.xilinx.rapidwright.edif.EDIFCell;
import com.xilinx.rapidwright.edif.EDIFCellInst;
import com.xilinx.rapidwright.edif.EDIFDirection;
import com.xilinx.rapidwright.edif.EDIFNet;
import com.xilinx.rapidwright.edif.EDIFPort;
import com.xilinx.rapidwright.placer.blockplacer.BlockPlacer2;
import com.xilinx.rapidwright.placer.handplacer.HandPlacer;
import com.xilinx.rapidwright.router.Router;
import com.xilinx.rapidwright.tests.CodePerfTracker;
import com.xilinx.rapidwright.util.FileTools;
import components.RenderComponent;
import components.Shape;

public class DottyStitcher {

    private static Design design;

	private static String clk = "clk";
	private static List<String> componentPorts = Arrays.asList("program", "x", "y", "data");

	private static boolean HAND_PLACER_ENABLED = false;
	private static boolean ROUTER_ENABLED = false;
	private static boolean WRITE_BITSTREAM = false;
	
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
	
	private static void connect(Design design, String srcModuleInstName, String srcPortName,
								String snkModuleInstName, String snkPortName) {
		ModuleInst srcModuleInst = design.getModuleInst(srcModuleInstName);
		EDIFPort srcPort = srcModuleInst.getCellInst().getPort(srcPortName);

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

	private static void connectTopLevelPortToModule(Design design, String topLevelPort, EDIFDirection dir,
															String moduleInst, String modulePort) {

		// Connect to the module
		EDIFCellInst cellInst = design.getTopEDIFCell().getCellInst(moduleInst);
		int width = cellInst.getPort(modulePort).getWidth();
		
		// Get/Create port
		
		
		if(width > 1) {
			for(int i=0; i < width; i++) {
				EDIFNet net = createOrGetTopLevelPortNet(design.getTopEDIFCell(), dir, topLevelPort + "["+i+"]");
				net.createPortInst(modulePort, i, cellInst);
			}
		}else {
			EDIFNet net = createOrGetTopLevelPortNet(design.getTopEDIFCell(), dir, topLevelPort);
			net.createPortInst(modulePort, cellInst);
		}
				
	}

	/*
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
	*/

	private static ArrayList<RenderComponent> getRenderGraphFromDotty(String dotFile, Map<String,Module> modules) {

		ArrayList<RenderComponent> renderComponents = new ArrayList<>();
		ArrayList<RenderComponent> renderGraph = new ArrayList<>();

		for(String line : FileTools.getLinesFromTextFile(dotFile)) {
			line.trim();
			if(line.length() == 0) continue;
			if(line.startsWith("#")) continue;

			if (line.contains("label=")){
				String[] tokens = line.trim().split("\\s+", 2);
				String name = tokens[0];
				String[] componentConfig = tokens[1].replace("[label=\"", "")
												.replace("\"];", "").trim().split(",");
				Shape shape = null;
				short xcoord = 0;
				short ycoord = 0;
				short width = 0;
				short height = 0;
				short color = 0;

				for (String config: componentConfig) {
				    String[] paramAndValue = config.trim().split("=");
				    switch (paramAndValue[0].trim()){
						case "shape":
							shape = Shape.valueOf(paramAndValue[1]);
							break;
						case "xcoord":
							xcoord = Short.parseShort(paramAndValue[1]);
							break;
						case "ycoord":
							ycoord = Short.parseShort(paramAndValue[1]);
							break;
						case "width":
							width = Short.parseShort(paramAndValue[1]);
							break;
						case "height":
							height = Short.parseShort(paramAndValue[1]);
							break;
						case "color":
							color = Short.parseShort(paramAndValue[1]);
							break;
					}
				}

				if (shape == null){
				    throw new NullPointerException("Shape type needed for node");
				}

				renderComponents.add(new RenderComponent(name, shape,
														xcoord, ycoord, width, height, color));
				Module module = modules.get(shape.name());
				ModuleInst mi = design.createModuleInst(name, module);
				mi.place(module.getAnchor().getSite());

			} else if(line.contains("->")) {
				String[] componentNames = line.replace(";", "").replaceAll("\\s+", "").split("->");
				for (String name: componentNames) {
					Stream<RenderComponent> componentStream = renderComponents.stream();
					RenderComponent component = componentStream.filter(comp -> name.equals(comp.getName())).findAny().orElse(null);
					if (component == null){
						throw new NullPointerException("Component in graph that has not been declared");
					}
					renderGraph.add(component);
				}
			}

		}
		return renderGraph;
	}

	private static Design createDesignFromRenderGraph(ArrayList<RenderComponent> renderGraph) {
		//Connect Input Module to top level ports and first component
		//String moduleInst = "Input";
        //connectTopLevelPortToModule(design, clk, EDIFDirection.INPUT, moduleInst, clk);
		//connectTopLevelPortToModule(design, "serial_input", EDIFDirection.INPUT, moduleInst, "serial_input");
		connect(design, "VGA", "VGA_LINEEND_OUT",
				"Input", "resume");
		String firstComponentName = renderGraph.get(0).getName();
		for (String port:componentPorts) {
			String scrPortName = port + "_out";
			String snkPortName = port + "_in";
			connect(design, "Input", scrPortName, firstComponentName, snkPortName);

		}
		int numComponents = renderGraph.size();
		for(int i = 0; i < numComponents; i++){
		    String currentComponentName = renderGraph.get(i).getName();
		    //connectTopLevelPortToModule(design, clk, EDIFDirection.INPUT, currentComponentName, clk);
		    String nextComponentName;
			if (i == numComponents - 1){
				// Connect output to VGA component
				nextComponentName = "VGA";
			} else {
				// Connect output to next component
				nextComponentName = renderGraph.get(i+1).getName();
			}
			for (String port:componentPorts) {
			    if(nextComponentName == "VGA" && port == "y"){
			    	continue;
				}
				String scrPortName = port + "_out";
				String snkPortName = port + "_in";
				connect(design, currentComponentName, scrPortName, nextComponentName, snkPortName);
			}
		}
		//Connect VGA output to top level ports
		//moduleInst = "VGA";
		//connectTopLevelPortToModule(design, "VGA_HS_OUT", EDIFDirection.OUTPUT, moduleInst, "VGA_HS_OUT");
		//connectTopLevelPortToModule(design, "VGA_VS_OUT", EDIFDirection.OUTPUT, moduleInst, "VGA_VS_OUT");
		//connectTopLevelPortToModule(design, "VGA_R_OUT", EDIFDirection.OUTPUT, moduleInst, "VGA_R_OUT");
		//connectTopLevelPortToModule(design, "VGA_G_OUT", EDIFDirection.OUTPUT, moduleInst, "VGA_G_OUT");
		//connectTopLevelPortToModule(design, "VGA_B_OUT", EDIFDirection.OUTPUT, moduleInst, "VGA_B_OUT");

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
	
	public static void main(String[] args) throws IOException {
		if(args.length != 3) {
			System.out.println("USAGE: <dot file> <components list file> <output.dcp>");
			return;
		}

		RenderConfigurator configurator = new RenderConfigurator();

		CodePerfTracker t = new CodePerfTracker("Dotty Graph Design Stitcher");
		
		t.start("Reading Module DCPs");
		// Load and create modules
		Map<String,Module> modules = new HashMap<>();
		for(String line : FileTools.getLinesFromTextFile(args[1])) {
			line = line.replaceAll("\\s+", "");
			if(line.length() == 0) continue;
			if(line.startsWith("#")) continue;
			String[] component_info = line.split(";");
			String dcp_loc = component_info[2] + component_info[0] + ".dcp";
			Module module = loadModule(dcp_loc);
			modules.put(component_info[0], module);

		}

		// Stitch blocks together according to Dotty Graph
		t.stop().start("Stitch Design");
		//Design design = createDesignFromDotty(args[0], "xc7a35tcpg236-1", modules);
		//Create intermediate graph of render
		design = new Design("Circuit", "xc7a35tcpg236-1");
		for(Module m : modules.values()) {
			design.getNetlist().migrateCellAndSubCells(m.getNetlist().getTopCell());
		}

		// Place input and VGA
		Module module = modules.get("Input");
		ModuleInst mi = design.createModuleInst("Input", module);
		mi.place(module.getAnchor().getSite());

		module = modules.get("VGA");
		mi = design.createModuleInst("VGA", module);
		mi.place(module.getAnchor().getSite());

		ArrayList<RenderComponent> renderGraph = getRenderGraphFromDotty(args[0], modules);
		Design design = createDesignFromRenderGraph(renderGraph);
		
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
		design.writeCheckpoint(args[2], CodePerfTracker.SILENT);
		t.stop().printSummary();

		if(WRITE_BITSTREAM) {
			String[] command = new String[] {"vivado -mode batch -source route_and_writebitstream.tcl -tclargs", args[2], " ",
												ROUTER_ENABLED ? "1" : "0"};
			Process proc = new ProcessBuilder(command).start();
		}

		RenderConfigurator.configure(renderGraph);
	}



}
