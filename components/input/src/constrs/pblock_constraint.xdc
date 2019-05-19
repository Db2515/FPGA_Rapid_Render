create_clock -name clock -period 10.000 [get_ports clk]
create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] -top
resize_pblock [get_pblocks pblock_1] -add {SLICE_X0Y14:SLICE_X3Y21}
