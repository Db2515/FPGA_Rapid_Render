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
                        output reg program_out,
                        output reg [10:0] x_out,
                        output reg [11:0] y_out,
                        output reg [31:0] data_out
    );
    
    localparam SCREEN_WIDTH = 1024;
    localparam SCREEN_HEIGHT = 768;
    
    reg [10:0] x = 0;
    reg [11:0] y = 0;
    reg delayed_resume;
    reg paused = 0;
    reg [31:0] color = 0;
    
    wire resume_pe = resume & ~delayed_resume;
    
    always @(posedge clk) begin
        delayed_resume <= resume;
        if(resume_pe) begin
            if (y < SCREEN_HEIGHT - 1) begin
                y <= y + 1;
            end else begin
                color <= 0;
                y <= 0;
            end
            paused <= 0;
        end
        if (!paused) begin
            color <= color + 'hF;
            if(x < SCREEN_WIDTH - 1) begin
                x <= x + 1;
            end else begin 
                x <= 0;
                paused <= 1;
            end
        end
    end
    
    always @(posedge clk) begin
        program_out <= 0;
        x_out = x;
        y_out = y;
        data_out <= color;
        
    end
     
endmodule
