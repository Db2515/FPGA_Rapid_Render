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

module VGA_output(input wire CLK,               // Base clock
                  input wire RST,               // Reset: restarts frame
                  input wire program_in,
                  input wire [11:0] x_in,
                  input wire [11:0] data_in,
                  output wire VGA_HS_OUT,       // Horizontal sync output
                  output wire VGA_VS_OUT,       // Vertical sync output
                  output reg [3:0] VGA_R_OUT,       // 4-bit VGA red output
                  output reg [3:0] VGA_G_OUT,       // 4-bit VGA green output
                  output reg [3:0] VGA_B_OUT,       // 4-bit VGA blue output
                  output wire VGA_LINEEND_OUT  // Signal during blanking at the end of the line  
    );
    
    wire rst = RST | program_in;  // Reset on button press or after reconfiguration
    
    reg [15:0] cnt;
    reg pix_stb;
    
    always @(posedge CLK) begin
        {pix_stb, cnt} <= cnt + 16'hA666;  // (2^16)/(100/65) = 0xA666
    end
    
    wire [10:0] vga_x;  // current pixel x position: 10-bit value: 0-1023
    wire [9:0] vga_y;  // current pixel y position:  9-bit value: 0-511
    
    vga1024x768 display (
        .i_clk(CLK),
        .i_pix_clk(pix_stb),
        .i_rst(rst),
        .o_hs(VGA_HS_OUT), 
        .o_vs(VGA_VS_OUT),
        .o_x(vga_x), 
        .o_y(vga_y),
        .o_lineend(VGA_LINEEND_OUT)
    );
    
    //VRAM frame buffers (read-write)
    localparam SCREEN_WIDTH = 1024;
    localparam SCREEN_HEIGHT = 768;
    localparam VRAM_DEPTH   = SCREEN_WIDTH;
    localparam VRAM_A_WIDTH = 10;
    localparam VRAM_D_WIDTH = 12;
    
    reg [VRAM_A_WIDTH-1:0] read_address;
    wire [VRAM_D_WIDTH-1:0] vram_data_out;
    reg [VRAM_A_WIDTH-1:0] write_address;
    reg [VRAM_D_WIDTH-1:0] vram_data_in;
   
    sram #(
        .ADDR_WIDTH(VRAM_A_WIDTH), 
        .DATA_WIDTH(VRAM_D_WIDTH), 
        .DEPTH(VRAM_DEPTH))
        vram (
        .i_clk(CLK),
        .i_read(1),                     // Read every clock cycle   
        .i_read_addr(read_address),
        .i_write(1),                    // Write every clock cycle
        .i_write_addr(write_address),
        .i_data(vram_data_in),
        .o_data(vram_data_out)    
    );
    
    reg [11:0] color;
    
    
    always @(posedge CLK) begin
        if (!program_in) begin
            write_address <= x_in;
            vram_data_in <= data_in;
        end
        if (pix_stb) begin
            read_address <= vga_x;
            color <= vram_data_out; 
        
            VGA_R_OUT <= ((vga_x > 0) & (vga_y >  0) 
                        & (vga_x < SCREEN_WIDTH) & (vga_y < SCREEN_HEIGHT)) ? color[11:8] : 0;
            VGA_G_OUT <= ((vga_x > 0) & (vga_y >  0) 
                        & (vga_x < SCREEN_WIDTH) & (vga_y < SCREEN_HEIGHT)) ? color[7:4] : 0;
            VGA_B_OUT <= ((vga_x > 0) & (vga_y >  0) 
                        & (vga_x < SCREEN_WIDTH) & (vga_y < SCREEN_HEIGHT)) ? color[3:0] : 0;
        end
    end
    

        
endmodule
