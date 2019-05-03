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
    reg program_in;
    reg [10:0] x;
    reg [11:0] y;
    reg [31:0] data_in;
    wire [10:0] x_out;
    wire [11:0] y_out;
    wire [31:0] data_out;
    
    board_2x2_wrapper DUT(.clk(clk),
                            .program_in(program_in),
                            .x(x),
                            .y(y),
                            .data_in(data_in),
                            .x_out(x_out), 
                            .y_out(y_out), 
                            .data_out(data_out));

    initial begin
        f = $fopen("output.txt","w");
        clk = 1'b0;
        program_in = 1;
        x = 0;
        y = 2;
        data_in = 540; // Top Left Width = 540
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        y = 3;
        data_in = 1080; // Top Left Height = 1080;
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        y = 4;
        data_in = 'hFFFFFFFF; // Top Left Color = WHITE
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        x = 1;
        y = 0;
        data_in = 540; // Bottom Right x = 540;
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        x = 1;
        y = 1;
        data_in = 1080; // Bottom Right y = 1080
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        x = 1;
        y = 2;
        data_in = 540; // Bottom Right Width = 540
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        x = 1;
        y = 3;
        data_in = 1080; // Bottom Right Height = 1080;
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        x = 1;
        y = 4;
        data_in = 'hFFFFFFFF;
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        #50
        clk = ~clk;
        program_in = 0;
        x = 0;
        y = 0;
        data_in = 'hFF000000;
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
            $fwrite(f, "%h\n", data_out);
            //Finish once the screen has been fully covered
            if (x_out == 1079 && y_out == 2159) begin
                $fclose(f);
                #100
                $finish;
            end
        end
    end
    
endmodule
