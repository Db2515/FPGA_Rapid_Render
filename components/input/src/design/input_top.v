`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2019 17:19:02
// Design Name: 
// Module Name: input_top
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


module input_top(input wire clk,
   input wire serial_input,
   input wire resume,
   output wire program_out,
   output wire [11:0] x_out,
   output wire [11:0] y_out,
   output wire [11:0] data_out
);

    wire program;
    wire [11:0] shape_addr;
    wire [11:0] reg_addr;
    wire [11:0] data;
    
    uart_buffer uart(.clk(clk), .Serial_input(serial_input),
                    .program_out(program), .shape_addr(shape_addr),
                    .reg_addr(reg_addr), .data(data));
                    
    input_manager(.clk(clk), .resume(resume),
                    .program_in(program), .shape_addr(shape_addr),
                    .reg_addr(reg_addr), .data_in(data),
                    .program_out(program_out), .x_out(x_out), .y_out(y_out),
                    .data_out(data_out));
endmodule
