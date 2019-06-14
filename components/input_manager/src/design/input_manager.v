`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2019 22:45:48
// Design Name: 
// Module Name: input_manager
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


module input_manager(input wire clk,
                        input wire resume,
                        input wire program_in,
                        input wire [11:0] shape_addr,
                        input wire [11:0] reg_addr,
                        input wire [11:0] data_in,
                        output reg program_out,
                        output reg [11:0] x_out,
                        output reg [11:0] y_out,
                        output reg [11:0] data_out
    );
    
    localparam SCREEN_WIDTH = 1024;
    localparam SCREEN_HEIGHT = 768;
    
    reg [11:0] x = 0;
    reg [11:0] y = 0;
    reg paused = 0;
   
    
    always @(posedge clk) begin
        //Reset coordinates so screen is redrawn
        if (program_in) begin
            x <= 0;
            y <= 0;
            paused <= 0;
        end else begin
            if(resume) begin
                x <= 0;
                if (y < SCREEN_HEIGHT - 1) begin
                    y <= y + 1;
                end else begin
                    y <= 0;
                end
                paused <= 0;
            end
            if (!paused) begin
                if(x < SCREEN_WIDTH - 1) begin
                    x <= x + 1;
                end else begin 
                    paused <= 1;
                end
            end
        end
    end
    
    always @(posedge clk) begin
        program_out <= program_in;
        if (program_in) begin
            x_out <= shape_addr;
            y_out <= reg_addr;
            data_out <= data_in;
        end else begin
            x_out <= x;
            y_out <= y;
            data_out <= 'hF0F;
        end   
    end
     
endmodule
