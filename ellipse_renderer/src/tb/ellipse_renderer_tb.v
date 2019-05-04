`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2019 14:08:20
// Design Name: 
// Module Name: ellipse_renderer_tb
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


module ellipse_renderer_tb();

    integer f; //File descriptor

    reg clk;
    reg program_in;
    reg [10:0] x; 
    reg [11:0] y;
    reg [31:0] data_in;
    wire [10:0] x_out;
    wire [11:0] y_out;
    wire [31:0] data_out;
    
    ellipse_renderer DUT(
        .clk(clk),
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
            y = 0;
            data_in = 540; // x = 540
            #50
            clk = ~clk;
            #50
            clk = ~clk;
            x = 0;
            y = 1;
            data_in = 1080; // y = 1080
            #50
            clk = ~clk;
            #50
            clk = ~clk;
            x = 0;
            y = 2;
            data_in = 270; // Width = 270
            #50
            clk = ~clk;
            #50
            clk = ~clk;
            y = 3;
            data_in = 540; // Height = 540;
            #50
            clk = ~clk;
            #50
            clk = ~clk;
            y = 4;
            data_in = 'hFF0000FF; // Color = RED
            #50
            clk = ~clk;
            #50
            clk = ~clk;
            program_in = 0;
            x = 0;
            y = 0;
            data_in = 'hFFFF0000; // BLUE
            forever #10 clk = ~clk;
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
