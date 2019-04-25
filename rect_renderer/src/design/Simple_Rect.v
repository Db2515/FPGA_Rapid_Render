module rect_renderer
    (input clk,
     input [10:0] x, 
     input [11:0] y,
     input [7:0] r,
     input [7:0] g,
     input [7:0] b,
     output reg [10:0] x_out,
     output reg [11:0] y_out,
     output reg [7:0] r_out,
     output reg [7:0] g_out,
     output reg [7:0] b_out);

    parameter x_coord = 0;
    parameter y_coord = 0;
    parameter width = 32;
    parameter height = 32;
    parameter shape_r = 8'hFF; //Default color = Red
    parameter shape_g = 8'h00;
    parameter shape_b = 8'h00;
  
    wire inshape = x >= x_coord && x < x_coord + width 
                    && y >= y_coord && y < y_coord + height;
    
    always @(posedge clk) 
    begin
        
        x_out <= x;
        y_out <= y;
            
        r_out <= inshape ? shape_r : r;
        g_out <= inshape ? shape_g : g;    
        b_out <= inshape ? shape_b : b;        
    end
                    
endmodule