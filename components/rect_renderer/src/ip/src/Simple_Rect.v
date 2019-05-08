module rect_renderer #(parameter SHAPE_ID = 0)
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

    reg [11:0] xcoord = 0;  //Reg_ID = 0
    reg [12:0] ycoord = 0;  //Reg_ID = 1
    reg [11:0] width = 0;   //Reg_ID = 2
    reg [12:0] height = 0;  //Reg_ID = 3
    reg [31:0] color = ~0;  //Red_ID = 4 Default color = white
    
    wire [31:0] color_tmp;
    
    
    assign color_tmp = program_in != 0 ? data_in : 
                                            (x >= xcoord & x < xcoord + width
                                                & y >= ycoord & y < ycoord + height
                                                ? color : data_in);
    
    //Inputs
    always @(posedge clk) 
    begin
        if (program_in && x == SHAPE_ID)
            //Change reg with ID = to y
            begin
                if (y == 0) begin
                xcoord = data_in;
                end
                else if (y == 1) begin
                    ycoord = data_in;
                end
                else if (y == 2) begin
                    width = data_in;
                end
                else if (y == 3) begin
                    height = data_in;
                end
                else if (y == 4) begin
                    color = data_in;
                end
            end
    end
    
    always @(posedge clk) begin
        program_out = program_in;
        x_out = x;
        y_out = y;
            
        // If program_in  != 0 we are reprogramming a shape so pass inputs through
        
        data_out = color_tmp;
    end
endmodule