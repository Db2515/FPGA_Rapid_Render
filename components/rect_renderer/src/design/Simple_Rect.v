module rect_renderer
    (input clk,
     input program_in,
     input [11:0] x_in, 
     input [11:0] y_in,
     input[11:0] data_in,
     output reg program_out,
     output reg [11:0] x_out,
     output reg [11:0] y_out,
     output reg [11:0] data_out
     );

    reg [11:0] xcoord = 0;  //Reg_ID = 0
    reg [11:0] ycoord = 0;  //Reg_ID = 1
    reg [11:0] width = 0;   //Reg_ID = 2
    reg [11:0] height = 0;  //Reg_ID = 3
    reg [11:0] color = ~0;  //Red_ID = 4 Default color = white
    
    wire [11:0] color_tmp;
    
    wire inshape = x_in >= xcoord & x_in < xcoord + width
                                                & y_in >= ycoord & y_in < ycoord + height;
    
    //Inputs
    always @(posedge clk) 
    begin
        if (program_in && x_in == 0)
            //Change reg with ID = to y
            begin
                if (y_in == 0) begin
                xcoord <= data_in;
                end
                else if (y_in == 1) begin
                    ycoord <= data_in;
                end
                else if (y_in == 2) begin
                    width <= data_in;
                end
                else if (y_in == 3) begin
                    height <= data_in;
                end
                else if (y_in == 4) begin
                    color <= data_in;
                end
            end
    end
    
    always @(posedge clk) begin
        program_out <= program_in;
        if (program_in) begin
            x_out <= x_in - 1;
        end else begin
            x_out <= x_in;
        end
        y_out <= y_in;
            
        // If program_in  != 0 we are reprogramming a shape so pass inputs through
        
        data_out <= !program_in && inshape ? color : data_in;
    end
endmodule