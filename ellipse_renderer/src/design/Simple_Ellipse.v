module ellipse_renderer
    (input clk,
        input signed [10:0] x,
        input signed [11:0] y,
        input [7:0] r,
        input [7:0] g,
        input [7:0] b,
        output reg signed [10:0] x_out,
        output reg signed [11:0] y_out,
        output reg [7:0] r_out,
        output reg [7:0] g_out,
        output reg [7:0] b_out
    );
    
    parameter x_coord = 16;
    parameter y_coord = 16;
    parameter radius_x = 4;
    parameter radius_y = 16;
    parameter shape_r = 8'h00; //Default color = Blue
    parameter shape_g = 8'h00;
    parameter shape_b = 8'hFF;

    wire signed [10:0] TranslatedX = x - x_coord;
    wire signed [11:0] TranslatedY = y - y_coord;
    wire inshape  = (radius_x * radius_x * TranslatedX * TranslatedX)
                    + (radius_y * radius_y * TranslatedY * TranslatedY)
                    < (radius_x * radius_x * radius_y * radius_y);
    
    always @(posedge clk)
    begin

        x_out <= x;
        y_out <= y;

        r_out <= inshape ? shape_r : r;
        g_out <= inshape ? shape_g : g;
        b_out <= inshape ? shape_b : b;
    end

    
endmodule