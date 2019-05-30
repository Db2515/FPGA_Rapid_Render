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
     input [10:0] x_in, 
     input [11:0] y_in,
     input[11:0] data_in,
     output reg program_out,
     output reg [10:0] x_out,
     output reg [11:0] y_out,
     output reg [11:0] data_out
     );
     
    reg [10:0] x_coord = 0;  //Reg_ID = 0
    reg [11:0] y_coord = 0;  //Reg_ID = 1
    reg [10:0] width_rad = 0;   //Reg_ID = 2
    reg [11:0] height_rad = 0;  //Reg_ID = 3
    reg [11:0] color = ~0;  //Red_ID = 4 Default color = white
    
    reg [23:0] height_rad_sqrd;
    reg [23:0] translatedX_sqrd;
    reg [23:0] width_rad_sqrd;
    reg [23:0] translatedY_sqrd;
    
    reg [47:0] height_calc;
    reg [47:0] width_calc;
    
    reg [49:0] calc;
    reg [47:0] bound[1:0];
    
    reg program_tmp[3:0];
    reg [10:0] x_tmp[3:0];
    reg [11:0] y_tmp[3:0];
    reg [11:0] data_tmp[3:0];
    
    reg [10:0] TranslatedX;
    reg [11:0] TranslatedY;
    
//    wire [50:0] calc = ((height_rad * height_rad * TranslatedX * TranslatedX)
//                    + (width_rad * width_rad * TranslatedY * TranslatedY));
//    wire [48:0] bound = (width_rad * width_rad * height_rad * height_rad);
    
    wire inshape  = calc <= bound[1];
    
    always @(posedge clk) begin
        TranslatedX <= x_in > x_coord ? x_in - x_coord : x_coord - x_in;
        TranslatedY <= y_in > y_coord ? y_in - y_coord : y_coord - y_in;
        
        program_tmp[0] <= program_in;
        if (program_in) begin
            x_tmp[0] <= x_in - 1;
       end else begin
            x_tmp[0] <= x_in;
        end
        y_tmp[0] <= y_in;
        data_tmp[0] <= data_in;
    end
                    
    //Outputs
    always @(posedge clk) begin
        height_rad_sqrd <= height_rad * height_rad;
        translatedX_sqrd <= TranslatedX * TranslatedX;
        width_rad_sqrd <= width_rad * width_rad;
        translatedY_sqrd <= TranslatedY * TranslatedY;
        
        program_tmp[1] <= program_tmp[0];
        x_tmp[1] <= x_tmp[0];
        y_tmp[1] <= y_tmp[0];
        data_tmp[1] <= data_tmp[0];
    end
    
    always @(posedge clk) begin
        height_calc <= height_rad_sqrd * translatedX_sqrd;
        width_calc <= width_rad_sqrd * translatedY_sqrd;
        bound[0] <= height_rad_sqrd * width_rad_sqrd;
        
        program_tmp[2] <= program_tmp[1];
        x_tmp[2] <= x_tmp[1];
        y_tmp[2] <= y_tmp[1];
        data_tmp[2] <= data_tmp[1];
    end
    
    always @(posedge clk) begin
        calc <= height_calc + width_calc;
        bound[1] <= bound[0];
        
        program_tmp[3] <= program_tmp[2];
        x_tmp[3] <= x_tmp[2];
        y_tmp[3] <= y_tmp[2];
        data_tmp[3] <= data_tmp[2];
    end
    
    always @(posedge clk) begin
        program_out <= program_tmp[3];
        x_out <= x_tmp[3];
        y_out <= y_tmp[3];
        data_out <= !program_tmp[3] && inshape ? color : data_tmp[3];
    end
  
    //Inputs
    always @(posedge clk) begin
        if (program_in && x_in == 0)
            //Change reg with ID = to y
            begin
                if (y_in == 0) begin
                    x_coord <= data_in;
                end
                else if (y_in == 1) begin
                    y_coord <= data_in;
                end
                else if (y_in == 2) begin
                    width_rad <= data_in;
                end
                else if (y_in == 3) begin
                    height_rad <= data_in;
                end
                else if (y_in == 4) begin
                    color <= data_in;
                end
            end
    end
    
endmodule
