`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.04.2019 19:03:48
// Design Name: 
// Module Name: Simple_Ellipese_tb
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


module simple_flow_tb();

    integer f; //File descriptor

    reg clk;
    reg signed [10:0] x;
    reg signed [11:0] y;
    reg [7:0] r;
    reg [7:0] g;
    reg [7:0] b;
    
    wire signed [10:0] x_out;
    wire signed [11:0] y_out;
    wire [7:0] r_out;
    wire [7:0] g_out;
    wire [7:0] b_out;

    simple_flow DUT(.clk(clk), .x(x), .y(y), .r(r), .g(g), .b(b),
                        .x_out(x_out), .y_out(y_out),
                        .r_out(r_out), .g_out(g_out), .b_out(b_out));

    initial begin
        f = $fopen("output.txt","w");
        x = 0;
        y = 0;
        r = 0;
        g = 0;
        b = 0;
        #100
        clk = 1'b0;
        forever #50 clk = ~clk;
    end
    
    always @(posedge clk) begin
        if(y < 31)
        begin
            y = y + 1;
        end
        else
        begin
            y = 0;
            if (x < 31)
            begin
                x = x + 1;
            end
            else
            begin
                x = 0;
            end
        end
        $fwrite(f, "%d,", x_out);
        $fwrite(f, "%d,", y_out);
        $fwrite(f, "FF%h", r_out);
        $fwrite(f, "%h", g_out);
        $fwrite(f, "%h\n", b_out);
        //Finish once the screen has been fully covered
        if (x_out == 31 && y_out == 31) begin
            $fclose(f);
            #100
            $finish;
        end
    end
endmodule
