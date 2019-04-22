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
    reg [5:0] program_in;
    reg [10:0] x;
    reg [11:0] y;
    reg [31:0] color_in;
    reg [10:0] shape_width;
    reg [11:0] shape_height;
    wire [10:0] x_out;
    wire [11:0] y_out;
    wire [31:0] color_out;
    
    board_2x2_wrapper DUT(.clk(clk),
                            .program_in(program_in),
                            .x(x),
                            .y(y),
                            .color_in(color_in),
                            .shape_width(shape_width),
                            .shape_height(shape_height),
                            .x_out(x_out), 
                            .y_out(y_out), 
                            .color_out(color_out));

    initial begin
        f = $fopen("output.txt","w");
        clk = 1'b0;
        program_in = 2;
        x = 0;
        y = 0;
        color_in = 'hFFFFFFFF;
        shape_width = 540;
        shape_height = 1080;
        #50
        clk = ~clk;
        #50
        program_in = 3;
        x = 540;
        y = 1080;
        color_in = 'hFFFFFFFF;
        shape_width = 540;
        shape_height = 1080;
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        #50
        program_in = 0;
        x = 0;
        y = 0;
        color_in = 'hFF000000;
        shape_width = 1080;
        shape_height = 2160;
        forever #50 clk = ~clk;
    end
    
    always @(posedge clk) begin
        //Print coord and color to file
        if(program_in == 0)
            begin
            if(y < 2159)
            begin
                y = y + 1;
            end
            else
            begin
                y = 0;
                if (x < 1079)
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
            $fwrite(f, "%h\n", color_out);
            //Finish once the screen has been fully covered
            if (x_out == 1079 && y_out == 2159) begin
                $fclose(f);
                #100
                $finish;
            end
        end
    end
    
endmodule
