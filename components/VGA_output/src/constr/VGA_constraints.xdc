## FPGA VGA Graphics Part 1: Basys 3 Board Constraints
## Learn more at https://timetoexplore.net/blog/arty-fpga-vga-verilog-01


## Use BTNC as Reset Button (active high)
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports RST]

## VGA Connector
set_property -dict {PACKAGE_PIN G19 IOSTANDARD LVCMOS33} [get_ports {VGA_R_OUT[0]}]
set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {VGA_R_OUT[1]}]
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {VGA_R_OUT[2]}]
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {VGA_R_OUT[3]}]
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {VGA_B_OUT[0]}]
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {VGA_B_OUT[1]}]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {VGA_B_OUT[2]}]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {VGA_B_OUT[3]}]
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {VGA_G_OUT[0]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {VGA_G_OUT[1]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {VGA_G_OUT[2]}]
set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {VGA_G_OUT[3]}]
set_property -dict {PACKAGE_PIN P19 IOSTANDARD LVCMOS33} [get_ports VGA_HS_OUT]
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports VGA_VS_OUT]

set_property IO_BUFFER_TYPE IBUF [get_ports RST]

set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_R_OUT[0]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_R_OUT[1]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_R_OUT[2]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_R_OUT[3]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_G_OUT[0]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_G_OUT[1]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_G_OUT[2]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_G_OUT[3]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_B_OUT[0]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_B_OUT[1]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_B_OUT[2]}]
set_property IO_BUFFER_TYPE OBUF [get_ports {VGA_B_OUT[3]}]

set_property IO_BUFFER_TYPE OBUF [get_ports VGA_HS_OUT]
set_property IO_BUFFER_TYPE OBUF [get_ports VGA_VS_OUT]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]

