`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2019 16:25:22
// Design Name: 
// Module Name: simple_flow
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


module simple_flow(
        input clk,
        input signed [10:0] x,
        input signed [11:0] y,
        input [7:0] r,
        input [7:0] g,
        input [7:0] b,
        output signed [10:0] x_out,
        output signed [11:0] y_out,
        output [7:0] r_out,
        output [7:0] g_out,
        output [7:0] b_out
    );
    
    wire [10:0] shape_0_x_out;
    wire [11:0] shape_0_y_out;
    wire [7:0] shape_0_r_out;
    wire [7:0] shape_0_g_out;
    wire [7:0] shape_0_b_out;
    
    
    wire [10:0] shape_1_x_out;
    wire [11:0] shape_1_y_out;
    wire [7:0] shape_1_r_out;
    wire [7:0] shape_1_g_out;
    wire [7:0] shape_1_b_out;
    
    wire [10:0] shape_2_x_out;
    wire [11:0] shape_2_y_out;
    wire [7:0] shape_2_r_out;
    wire [7:0] shape_2_g_out;
    wire [7:0] shape_2_b_out;
    
    assign x_out [10:0] = shape_2_x_out;
    assign y_out [11:0] = shape_2_y_out;
    assign r_out [7:0] = shape_2_r_out;
    assign g_out [7:0] = shape_2_g_out;
    assign b_out [7:0] = shape_2_b_out;
    
    rect_renderer shape_0(.clk(clk), .x(x), .y(y), .r(r), .g(g), .b(b),
                            .x_out(shape_0_x_out), .y_out(shape_0_y_out),
                            .r_out(shape_0_r_out), .g_out(shape_0_g_out),
                            .b_out(shape_0_b_out));
                            
    ellipse_renderer shape_1(.clk(clk), .x(shape_0_x_out), 
                            .y(shape_0_y_out), .r(shape_0_r_out), 
                            .g(shape_0_g_out), .b(shape_0_b_out),
                            .x_out(shape_1_x_out), .y_out(shape_1_y_out),
                            .r_out(shape_1_r_out), .g_out(shape_1_g_out),
                            .b_out(shape_1_b_out)); 
    
    rect_renderer #(.x_coord(14), .y_coord(14), .height(4), .width(4), .shape_g(8'hFF))
                shape_2(.clk(clk), .x(shape_1_x_out), 
                            .y(shape_1_y_out), .r(shape_1_r_out), 
                            .g(shape_1_g_out), .b(shape_1_b_out),
                            .x_out(shape_2_x_out), .y_out(shape_2_y_out),
                            .r_out(shape_2_r_out), .g_out(shape_2_g_out),
                            .b_out(shape_2_b_out));                                              
                            
endmodule
