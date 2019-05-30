echo "Module Design Timings" > out/module_timings.txt
for i in {10..200..10}
do
	echo "Circuit size: $i components"	
	python generate_module_design.py /home/dan/FPGA_Rapid_Render/example_designs/module_design/design/module_design.v $i
	vivado -mode batch -source time_module_flow.tcl -tclargs /home/dan/FPGA_Rapid_Render/example_designs/module_design/module_design.xpr
	echo "Circuit size: $i components" >> out/module_timings.txt	
	grep " Time" vivado.log >> out/module_timings.txt; rm vivado*
done

