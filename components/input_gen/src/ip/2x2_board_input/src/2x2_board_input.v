//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.04.2019 11:43:57
// Design Name: 
// Module Name: 2x2_board_input
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


module checkerboard_input(input wire clk,
                        output wire [5:0] program_out,
                        output wire [10:0] x_out,
                        output wire [11:0] y_out,
                        output wire [31:0] color_out,
                        output wire [10:0] shape_width_out,
                        output wire [11:0] shape_height_out);
    
    reg [5:0] program = 2;
    reg [10:0] x = 0;
    reg [11:0] y = 0;
    reg [31:0] color = 'hFFFFFFFF;
    reg [10:0] shape_width = 540;
    reg [11:0] shape_height = 1080;
    
    always @(negedge clk)
    begin
        // Here we much change program variables for when program = 3;
        if(program == 2)
        begin
            program = 3;
            x = 540;
            y = 1080;
        end
        else if (program == 3)
        begin
            program = 0;
            x = 0;
            y = 0;
            color = 'hFF000000;
            shape_width = 1080;
            shape_height = 2160;
        end
        else if (program == 0)
        begin
            if(y < 2160)
            begin
                y = y + 1;
            end
            else
            begin
                y = 0;
                if (x < 1080)
                begin
                    x = x + 1;
                end
                else
                begin
                    x = 0;
                end
            end
        end
    end
    
    assign program_out = program;
    assign x_out = x;
    assign y_out = y;
    assign color_out = color;
    assign shape_width_out = shape_width;
    assign shape_height_out = shape_height;
endmodule
