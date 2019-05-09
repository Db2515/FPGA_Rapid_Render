`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2019 13:49:25
// Design Name: 
// Module Name: ellipse_renderer
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


module ellipse_renderer
    (input clk,
     input program_in,
     input [10:0] x, 
     input [11:0] y,
     input[31:0] data_in,
     output reg program_out,
     output reg [10:0] x_out,
     output reg [11:0] y_out,
     output reg [31:0] data_out
     );
     
    reg [10:0] x_coord = 0;  //Reg_ID = 0
    reg [11:0] y_coord = 0;  //Reg_ID = 1
    reg [10:0] width_rad = 0;   //Reg_ID = 2
    reg [11:0] height_rad = 0;  //Reg_ID = 3
    reg [31:0] color = ~0;  //Red_ID = 4 Default color = white
    
    
    wire [10:0] TranslatedX = x > x_coord ? x - x_coord : x_coord - x;
    wire [11:0] TranslatedY = y > y_coord ? y - y_coord : y_coord - y;
    
    wire [50:0] calc = ((height_rad * height_rad * TranslatedX * TranslatedX)
                    + (width_rad * width_rad * TranslatedY * TranslatedY));
    wire [48:0] bound = (width_rad * width_rad * height_rad * height_rad);
    
    wire inshape  = calc <= bound;
                    
    
    //Inputs
    always @(posedge clk) 
    begin
        if (program_in && x == 0)
            //Change reg with ID = to y
            begin
                if (y == 0) begin
                    x_coord <= data_in;
                end
                else if (y == 1) begin
                    y_coord <= data_in;
                end
                else if (y == 2) begin
                    width_rad <= data_in;
                end
                else if (y == 3) begin
                    height_rad <= data_in;
                end
                else if (y == 4) begin
                    color <= data_in;
                end
            end
    end
    
    always @(posedge clk) begin
        program_out <= program_in ;
        if(program_in) begin
            x_out <= x - 1;
        end
        else begin
            x_out <= x;
        end
        y_out <= y;
            
        // If program_in  != 0 we are reprogramming a shape so pass inputs through
        
        data_out <= !program_in && inshape ? color : data_in;
    end
endmodule
