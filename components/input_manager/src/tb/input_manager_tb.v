`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.05.2019 12:51:39
// Design Name: 
// Module Name: input_manager_tb
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


module input_manager_tb();

    reg clk;
    reg resume;
    wire program_out;
    wire [10:0] x_out;
    wire [11:0] y_out;
    wire [31:0] data_out;
    
    input_manager DUT(.clk(clk),
        .resume(resume),
        .program_out(program_out),
        .x_out(x_out),
        .y_out(y_out),
        .data_out(data_out));
        
    initial begin
        clk = 1'b0;
        resume = 0;
        repeat (35) begin
            #10
            clk <= ~clk;
            #10
            clk <= ~clk;
        end
        #10
        resume = 1;
        clk <= ~clk;
        #10
        clk <= ~clk;
        #10
        resume = 0;
        clk <= ~clk;
        #10
        clk <= ~clk;
        resume = 0;
        repeat (35) begin
            #10
            clk <= ~clk;
            #10
            clk <= ~clk;
        end
        #10
        resume = 1;
        clk <= ~clk;
        #10
        clk <= ~clk;
        #10
        resume = 0;
        clk <= ~clk;
        #10
        clk <= ~clk;
        resume = 0;
        repeat (35) begin
            #10
            clk <= ~clk;
            #10
            clk <= ~clk;
        end
    end

endmodule
