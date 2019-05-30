// FPGA VGA Graphics Part 2: SRAM Module (single port)
// (C)2018 Will Green - Licensed under the MIT License
// Learn more at https://timetoexplore.net/blog/arty-fpga-vga-verilog-02

`default_nettype none

// DUAL port sram reads when i_read is set writes when i_write is set
module sram #(parameter ADDR_WIDTH=8, DATA_WIDTH=8, DEPTH=256) (
    input wire i_clk,
    input wire i_read,
    input wire [ADDR_WIDTH-1:0] i_read_addr, 
    input wire i_write,
    input wire [ADDR_WIDTH-1:0] i_write_addr,
    input wire [DATA_WIDTH-1:0] i_data,
    output reg [DATA_WIDTH-1:0] o_data 
    );

    reg [DATA_WIDTH-1:0] memory_array [0:DEPTH-1]; 

    always @ (posedge i_clk)
    begin
        if(i_write) begin
            memory_array[i_write_addr] <= i_data;
        end
        if(i_read) begin
            o_data <= memory_array[i_read_addr];    
        end
    end
endmodule
