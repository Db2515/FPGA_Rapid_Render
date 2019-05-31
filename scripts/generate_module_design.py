import sys

if(len(sys.argv) != 3):
	print("File location and number of components args required");
	exit;

f = open(sys.argv[1], "w+");


# Module instantation
f.write("""module module_design(input wire CLK, input wire RST,
		input wire serial_input,\n\
		output wire VGA_HS_OUT,\n\
		output wire VGA_VS_OUT,\n\
		output wire [3:0] VGA_R_OUT,\n\
		output wire [3:0] VGA_G_OUT,
		output wire [3:0] VGA_B_OUT);\n""");


f.write("wire lineend;\n");
f.write("wire program_in;\n");
f.write("wire [10:0] x_in;\n");
f.write("wire [11:0] y_in;\n");
f.write("wire [11:0] data_in;\n");

# Create shape wires
numComponents = int(sys.argv[2]);
for i in range(numComponents):
	f.write("wire shape_%d_program_out;\n" % i);
	f.write("wire [10:0] shape_%d_x_out;\n" % i);
	f.write("wire [11:0] shape_%d_y_out;\n" % i);
	f.write("wire [11:0] shape_%d_data_out;\n" % i);

# Input creation
f.write("""input_top input_comp(.clk(CLK),
                .serial_input(serial_input),
                .resume(lineend),
                .program_out(program_in),
                .x_out(x_in),
                .y_out(y_in),
                .data_out(data_in));\n""");

# Rectangle creation
for i in range(numComponents):
	if i == 0:
		f.write("""rect_renderer shape_%d(.clk(CLK),\n\
				.program_in(program_in),\n\
				.x_in(x_in), .y_in(y_in),\n\
				.data_in(data_in),\n\
				.program_out(shape_%d_program_out),\n\
				.x_out(shape_%d_x_out),\n\
				.y_out(shape_%d_y_out),\n\
				.data_out(shape_%d_data_out));\n""" \
				% (i,i,i,i,i));
	else:
		f.write("""rect_renderer shape_%d(.clk(CLK),\n\
				.program_in(shape_%d_program_out),\n\
				.x_in(shape_%d_x_out), 
				.y_in(shape_%d_y_out),\n\
				.data_in(shape_%d_data_out),\n\
				.program_out(shape_%d_program_out),\n\
				.x_out(shape_%d_x_out),\n\
				.y_out(shape_%d_y_out),\n\
				.data_out(shape_%d_data_out));\n""" \
				% (i,i-1,i-1,i-1,i-1,i,i,i,i));

		

f.write("""VGA_output display(.CLK(CLK),\n\
        .RST(RST),\n\
        .program_in(shape_%d_program_out),\n\
        .x_in(shape_%d_x_out),\n\
        .data_in(shape_%d_data_out),\n\
        .VGA_HS_OUT(VGA_HS_OUT),\n\
        .VGA_VS_OUT(VGA_VS_OUT),\n\
        .VGA_R_OUT(VGA_R_OUT),\n\
        .VGA_G_OUT(VGA_G_OUT),\n\
        .VGA_B_OUT(VGA_B_OUT),\n\
        .VGA_LINEEND_OUT(lineend)\n\
);\n""" % (numComponents - 1, numComponents - 1, numComponents - 1));

f.write("endmodule\n");
f.close()
