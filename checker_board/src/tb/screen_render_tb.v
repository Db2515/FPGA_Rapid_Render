`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2019 19:44:09
// Design Name: 
// Module Name: screen_render_tb
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


module screen_render_tb();

    integer f; //File descriptor

    reg clk;
    wire [10:0] x_out;
    wire [11:0] y_out;
    wire [31:0] color_out;
    
    board_2x2_wrapper DUT(.clk(clk), 
                            .x_out(x_out), 
                            .y_out(y_out), 
                            .color_out(color_out));

    initial begin
        f = $fopen("output.txt","w");
        clk = 1'b0;
        forever #50 clk = ~clk;
    end
    
    always @(posedge clk) begin
        //Print coord and color to file
        $fwrite(f, "%d,", x_out);
        $fwrite(f, "%d,", y_out);
        $fwrite(f, "%h\n", color_out);
        //Finish once the screen has been fully covered
        if (x_out == 1079 && y_out == 2159) begin
            $fclose(f);
            #100
            $finish;
        end
    end
    
endmodule
