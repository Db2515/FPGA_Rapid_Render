`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.04.2019 18:59:57
// Design Name: 
// Module Name: simple_output
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


module simple_output(input wire [5:0] program_in,
                      input wire [10:0] x, 
                      input wire [11:0] y,
                      input wire[31:0] color_in,
                      input wire [10:0] shape_width,
                      input wire [11:0] shape_height, 
                      output wire [10:0] x_out,
                      output wire [11:0] y_out,
                      output wire [31:0] color_out
    );
    
    assign x_out = x;
    assign y_out = y;
    assign color_out = color_in;
endmodule
