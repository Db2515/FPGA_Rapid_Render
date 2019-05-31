`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2019 12:05:45
// Design Name: 
// Module Name: uart_test
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


module uart_test(
    input wire clk,
    input wire serial_input,
    output wire [11:0] data_out
    );

wire [11:0] shape_addr;
wire [11:0] reg_addr;
wire [11:0] data;

uart_buffer uart_buffer(.clk(clk), .Serial_input(serial_input),
    .shape_addr(shape_addr), .reg_addr(reg_addr), .data(data));
    
assign data_out = shape_addr;
 
endmodule
