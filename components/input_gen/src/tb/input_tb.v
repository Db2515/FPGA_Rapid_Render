`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2019 12:27:36
// Design Name: 
// Module Name: input_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module input_tb();
    
    reg clk;
    wire [5:0] program_out;
    wire [10:0] x_out;
    wire [11:0] y_out;
    wire [31:0] color_out;
    wire [10:0] shape_width_out;
    wire [11:0] shape_height_out;
    
    checkerboard_input DUT(.clk(clk),
                        .program_out(program_out),
                        .x_out(x_out),
                        .y_out(y_out),
                        .color_out(color_out),
                        .shape_width_out(shape_width_out),
                        .shape_height_out(shape_height_out));
    
    initial begin  
        clk = 1'b0;
        forever #10 clk = ~clk;
     end

endmodule
