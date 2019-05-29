import sys

if(len(sys.argv) != 3):
	print("File location and number of components args required");
	exit;

f = open(sys.argv[1], "w+");


# Module instantation
f.write("""module module_design(input clk, input program_in, 		\n\
		input [10:0] x_in, input [11:0] y_in, 			\n\
		input [11:0] data_in, 					\n\
		output program_out,					 
		output[10:0] x_out, output [11:0] y_out,		\n\
		output [11:0] data_out);\n""");


# Create shape wires
numComponents = int(sys.argv[2]);
for i in range(numComponents):
	f.write("wire shape_%d_program_out;\n" % i);
	f.write("wire shape_%d_x_out;\n" % i);
	f.write("wire shape_%d_y_out;\n" % i);
	f.write("wire shape_%d_data_out;\n" % i);

f.write("assign program_out = shape_%d_program_out;\n" % (numComponents - 1));
f.write("assign x_out = shape_%d_x_out;\n" %  (numComponents - 1));
f.write("assign y_out = shape_%d_y_out;\n" % (numComponents - 1));
f.write("assign data_out = shape_%d_data_out;\n" % (numComponents - 1));

# Rectangle creation
for i in range(numComponents):
	if i == 0:
		f.write("""rect_renderer shape_%d(.clk(clk)\n\
				.program_in(program_in),\n\
				.x_in(x_in), .y_in(y_in),\n\
				.data_in(data_in),\n\
				.program_out(shape_%d_program_out),\n\
				.x_out(shape_%d_x_out),\n\
				.y_out(shape_%d_y_out),\n\
				.data_out(shape_%d_data_out));\n""" \
				% (i,i,i,i,i));
	else:
		f.write("""rect_renderer shape_%d(.clk(clk)\n\
				.program_in(shape_%d_program_in),\n\
				.x_in(shape_%d_x_out), 
				.y_in(shape_%d_y_out),\n\
				.data_in(shape_%d_data_out),\n\
				.program_out(shape_%d_program_out),\n\
				.x_out(shape_%d_x_out),\n\
				.y_out(shape_%d_y_out),\n\
				.data_out(shape_%d_data_out));\n""" \
				% (i,i-1,i-1,i-1,i-1,i,i,i,i));

		

f.write("endmodule\n");
f.close()
