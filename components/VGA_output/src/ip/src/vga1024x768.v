// FPGA VGA Graphics Part 1: 800x600 60Hz VGA Driver
// (C)2018 Will Green - Licensed under the MIT License
// Learn more at https://timetoexplore.net/blog/arty-fpga-vga-verilog-01

// For 60 Hz VGA i_pix_stb must be 40 MHz
// Details in tutorial: https://timetoexplore.net/blog/arty-fpga-vga-verilog-01

`default_nettype none

module vga1024x768(
    input wire i_clk,           // base clock
    input wire i_pix_clk,       // pixel clock strobe
    input wire i_rst,           // reset: restarts frame
    output wire o_hs,           // horizontal sync
    output wire o_vs,           // vertical sync
    output wire o_blanking,     // high during blanking interval
    output wire o_active,       // high during active pixel drawing
    output wire o_screenend,    // high for one tick at the end of screen
    output wire o_animate,      // high for one tick at end of active drawing
    output wire [10:0] o_x,     // current pixel x position
    output wire  [9:0] o_y      // current pixel y position
    );

    // VGA timings https://timetoexplore.net/blog/video-timings-vga-720p-1080p
    localparam H_ACTIVE_PIXELS  = 1024;
    localparam H_FRONT_PORCH    = 24;
    localparam H_SYNC_WIDTH     = 136;
    localparam H_BACK_PORCH     = 160;
    
    localparam LINE             = H_ACTIVE_PIXELS + H_FRONT_PORCH
                                    + H_SYNC_WIDTH + H_BACK_PORCH; 
    
    localparam HS_STA = H_FRONT_PORCH;              // horizontal sync start
    localparam HS_END = HS_STA + H_SYNC_WIDTH;      // horizontal sync end
    localparam HA_STA = HS_END + H_BACK_PORCH;      // horizontal active pixel start
    
    localparam V_ACTIVE_PIXELS  = 768;
    localparam V_FRONT_PORCH    = 3;
    localparam V_SYNC_WIDTH     = 6;
    localparam V_BACK_PORCH     = 29;
    
    localparam SCREEN           = V_ACTIVE_PIXELS + V_FRONT_PORCH
                                    + V_SYNC_WIDTH + V_BACK_PORCH;
    
    localparam VS_STA = V_ACTIVE_PIXELS + V_FRONT_PORCH;    // vertical sync start
    localparam VS_END = VS_STA + V_SYNC_WIDTH;              // vertical sync end
    localparam VA_END = V_ACTIVE_PIXELS;                    // vertical active pixel end
    
    
    reg [10:0] h_count; // line position
    reg  [9:0] v_count; // screen position

    // generate sync signals (active high for 800x600)
    assign o_hs = ((h_count >= HS_STA) & (h_count < HS_END));
    assign o_vs = ((v_count >= VS_STA) & (v_count < VS_END));

    // keep x and y bound within the active pixels
    assign o_x = (h_count < HA_STA) ? 0 : (h_count - HA_STA);
    assign o_y = (v_count >= VA_END) ? (VA_END - 1) : (v_count);

    // blanking: high within the blanking period
    assign o_blanking = ((h_count < HA_STA) | (v_count > VA_END - 1));

    // active: high during active pixel drawing
    assign o_active = ~((h_count < HA_STA) | (v_count > VA_END - 1)); 

    // screenend: high for one tick at the end of the screen
    assign o_screenend = ((v_count == SCREEN - 1) & (h_count == LINE));

    // animate: high for one tick at the end of the final active pixel line
    assign o_animate = ((v_count == VA_END - 1) & (h_count == LINE));

    always @ (posedge i_clk)
    begin
        if (i_rst)  // reset to start of frame
        begin
            h_count <= 0;
            v_count <= 0;
        end
        if (i_pix_clk)  // once per pixel
        begin
            if (h_count == LINE)  // end of line
            begin
                h_count <= 0;
                v_count <= v_count + 1;
            end
            else 
                h_count <= h_count + 1;

            if (v_count == SCREEN)  // end of screen
                v_count <= 0;
        end
    end
endmodule
