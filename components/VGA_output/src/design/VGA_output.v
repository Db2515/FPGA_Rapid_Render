`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2019 16:14:12
// Design Name: 
// Module Name: VGA_output
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
// Credit to the tutorial https://timetoexplore.net/blog/arty-fpga-vga-verilog-01

module VGA_output(input wire CLK,                // Base clock
                  input wire RST_BTN,              // Reset: restarts frame
                  output wire VGA_HS_OUT,    // Horizontal sync output
                  output wire VGA_VS_OUT,    // Vertical sync output
                  output wire [3:0] VGA_R,   // 4-bit VGA red output
                  output wire [3:0] VGA_G,   // 4-bit VGA green output
                  output wire [3:0] VGA_B    // 4-bit VGA blue output  
    );
    
    wire rst = RST_BTN;  // reset is active high on Basys3 (BTNC)
    
    reg [15:0] cnt;
    reg pix_stb;
    
    always @(posedge CLK) begin
        {pix_stb, cnt} <= cnt + 16'hA666;  // (2^16)/(100/65) = 0xA666
    end
    
    wire [10:0] x;  // current pixel x position: 10-bit value: 0-1023
    wire [9:0] y;  // current pixel y position:  9-bit value: 0-511
    
    vga1024x768 display (
        .i_clk(CLK),
        .i_pix_clk(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_OUT), 
        .o_vs(VGA_VS_OUT),
        .o_x(x), 
        .o_y(y)
    );
     
    wire sq_a, sq_b, sq_c, sq_d;
    assign sq_a = ((x > 120) & (y >  40) & (x < 280) & (y < 200)) ? 1 : 0;
    assign sq_b = ((x > 200) & (y > 120) & (x < 360) & (y < 280)) ? 1 : 0;
    assign sq_c = ((x > 280) & (y > 200) & (x < 440) & (y < 360)) ? 1 : 0;
    assign sq_d = ((x > 360) & (y > 280) & (x < 520) & (y < 440)) ? 1 : 0;

    assign VGA_R[3] = sq_b;         // square b is red
    assign VGA_G[3] = sq_a | sq_d;  // squares a and d are green
    assign VGA_B[3] = sq_c;         // square c is blue

        
endmodule
