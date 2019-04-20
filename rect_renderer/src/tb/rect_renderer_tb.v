`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.04.2019 12:21:41
// Design Name: 
// Module Name: Simple_Rect_tb
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


module rect_renderer_tb();
    
    reg clk;
    reg [5:0] program_in;
    reg [10:0] x; 
    reg [11:0] y;
    reg [31:0] color_in;
    reg [10:0] shape_width;
    reg [11:0] shape_height;
    wire [10:0] x_out;
    wire [11:0] y_out;
    wire [31:0] color_out;
    
    rect_renderer DUT(
        .clk(clk),
        .program_in(program_in),
        .x(x),
        .y(y),
        .color_in(color_in),
        .shape_width(shape_width),
        .shape_height(shape_height),
        .x_out(x_out),
        .y_out(y_out),
        .color_out(color_out));
        
        reg [31:0] expected = 0;
        integer i = 0;
        integer j = 0;
        
        initial begin  
            clk = 1'b0;
            forever #10 clk = ~clk;
        end
        
        initial begin
            // Set shape to cover entire screen as black rect
            program_in = 1;
            x = 0;
            y = 0;
            shape_width = 1080;
            shape_height = 2160;
            color_in = 'hFF000000;
            @(negedge clk);
            // Test sample of pixels output black color
            program_in = 0;
            //Set background color to BLUE this should not been seen as shape is full screen
            color_in = 'hFF0000FF;
            for(i = 0; i < 1080; i = i + 135) begin
                x = i;
                for(j = 0; j < 2160; j = j + 135) begin
                    y = j;
                    expected = 'hFF000000;
                    @(negedge clk);
                    if (color_out != expected) 
                    begin 
                        $display("Initial Setup: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, expected); 
                    end
                end
            end
            @(posedge clk);
            // Test shape_color change
            // Set shape_color to RED
            program_in = 1;
            x = 0;
            y = 0;
            color_in = 'hFFFF0000;
            @(negedge clk)
            program_in = 0;
            //Set background color to BLUE this should not been seen as shape is full screen
            // Instead we should see RED
            color_in = 'hFF0000FF;
            for(i = 0; i < 1080; i = i + 135) begin
                x = i;
                for(j = 0; j < 2160; j = j + 135) begin
                    y = j;
                    expected = 'hFFFF0000;
                    @(negedge clk)
                    if (color_out != expected) begin
                        $display("Red Color: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, expected); 
                    end
                end
            end
            @(posedge clk)
            // Test shape dimension change
            // Half the width, shape_color still RED
            program_in = 1;
            x = 0;
            y = 0;
            color_in = 'hFFFF0000;
            shape_width = 540;
            @(negedge clk);
            program_in = 0;
            //Set background color to BLUE this should not been seen as shape is full screen
            // Instead we should see RED
            color_in = 'hFF0000FF;
            for(i = 0; i < 1080; i = i + 135) begin
                x = i;
                for(j = 0; j < 2160; j = j + 135) begin
                    expected = i < shape_width ? 'hFFFF0000 : 'hFF0000FF;
                    @(negedge clk);
                    if (color_out != expected) begin
                        $display("Half Width: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, 'hFFFF0000); 
                    end
                end
            end
            @(posedge clk);
            // Test shape position change
            // Move the rect to second half of screen
            program_in = 1;
            x = 540;
            y = 0;
            color_in = 'hFFFF0000;
            @(negedge clk);
            program_in = 0;
            //Set background color to BLUE this should not been seen as shape is full screen
            // Instead we should see RED
            color_in = 'hFF0000FF;
            for(i = 0; i < 1080; i = i + 135) begin
                x = i;
                for(j = 0; j < 2160; j = j + 135) begin
                    y = j;
                    expected = i < shape_width ? 'hFF0000FF : 'hFFFF0000;
                    @(negedge clk);
                    if (color_out != expected) begin
                        $display("Half Width Shifted: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, 'hFFFF0000); 
                    end
                end
            end
            @(posedge clk);
            $finish;
        end
//    initial begin 
//        // Set shape to cover entire screen as black rect
//        program_in = 1;
//        x = 0;
//        y = 0;
//        shape_width = 1080;
//        shape_height = 2160;
//        color_in = 'hFF000000;
//        #40;
//        // Test sample of pixels output black color
//        program_in = 0;
//        //Set background color to BLUE this should not been seen as shape is full screen
//        color_in = 'hFF0000FF;
//        for(i = 0; i < 1080; i = i + 135) begin
//            x = i;
//            for(j = 0; j < 2160; j = j + 135) begin
//                y = j;
//                #20;
//                expected = 'hFF000000;
//                if (color_out != expected) 
//                begin 
//                    $display("Initial Setup: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, expected); 
//                end
//                #20;
//            end
//        end
        
//        // Test shape_color change
//        // Set shape_color to RED
//        program_in = 1;
//        x = 0;
//        y = 0;
//        color_in = 'hFFFF0000;
//        #40;
//        program_in = 0;
//        //Set background color to BLUE this should not been seen as shape is full screen
//        // Instead we should see RED
//        color_in = 'hFF0000FF;
//        for(i = 0; i < 1080; i = i + 135) begin
//            x = i;
//            for(j = 0; j < 2160; j = j + 135) begin
//                y = j;
//                #20;
//                expected = 'hFFFF0000;
//                if (color_out != expected) begin
//                    $display("Red Color: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, expected); 
//                end
//                #20;
//            end
//        end
        
//        // Test shape dimension change
//        // Half the width, shape_color still RED
//        program_in = 1;
//        x = 0;
//        y = 0;
//        color_in = 'hFFFF0000;
//        shape_width = 540;
//        #40;
//        program_in = 0;
//        //Set background color to BLUE this should not been seen as shape is full screen
//        // Instead we should see RED
//        color_in = 'hFF0000FF;
//        for(i = 0; i < 1080; i = i + 135) begin
//            x = i;
//            for(j = 0; j < 2160; j = j + 135) begin
//                y = j;
//                #20;
//                expected = i < shape_width ? 'hFFFF0000 : 'hFF0000FF;
//                if (color_out != expected) begin
//                    $display("Half Width: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, 'hFFFF0000); 
//                end
//                #20;
//            end
//        end
        
//        // Test shape position change
//        // Move the rect to second half of screen
//        program_in = 1;
//        x = 540;
//        y = 0;
//        color_in = 'hFFFF0000;
//        #40;
//        program_in = 0;
//        //Set background color to BLUE this should not been seen as shape is full screen
//        // Instead we should see RED
//        color_in = 'hFF0000FF;
//        for(i = 0; i < 1080; i = i + 135) begin
//            x = i;
//            for(j = 0; j < 2160; j = j + 135) begin
//                y = j;
//                #20;
//                expected = i < shape_width ? 'hFF0000FF : 'hFFFF0000;
//                if (color_out != expected) begin
//                    $display("Half Width Shifted: %d %d Actual color_out %h, Expected color_out %h", i, j, color_out, 'hFFFF0000); 
//                end
//                #20;
//            end
//        end
        
//        $finish;
//    end
    
endmodule
