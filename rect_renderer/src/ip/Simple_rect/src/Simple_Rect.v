module rect_renderer #(parameter SHAPE_ID = 1)
    (input wire clk,
     input wire [5:0] program_in,
     input wire [10:0] x, 
     input wire [11:0] y,
     input wire[31:0] color_in,
     input wire [10:0] shape_width,
     input wire [11:0] shape_height, 
     output wire [5:0] program_out,
     output wire [10:0] x_out,
     output wire [11:0] y_out,
     output wire [31:0] color_out,
     output wire [10:0] shape_width_out,
     output wire [11:0] shape_height_out);

    reg [11:0] xcoord = 0;
    reg [12:0] ycoord = 0;
    reg [11:0] width = 0;
    reg [12:0] height = 0;
    reg [31:0] color = ~0; //Default color = white
    
    reg [31:0] color_tmp;
    
    always @(posedge clk) 
    begin
        if (program_in == SHAPE_ID)
            begin
                xcoord = x;
                ycoord = y;
                width = shape_width;
                height = shape_height;
                color = color_in;
            end
                
        color_tmp = x >= xcoord & x < xcoord + width 
                    & y >= ycoord & y < ycoord + height
                    ? color : color_in;
    end
    
    assign program_out = program_in;
    assign x_out = x;
    assign y_out = y;
        
    // If program_in  != 0 we are reprogramming a shape so pass inputs through
    
    assign color_out = program_in != 0 ? color_in : color_tmp;
                    
    assign shape_width_out = shape_width;
    assign shape_height_out = shape_height;
                    
endmodule