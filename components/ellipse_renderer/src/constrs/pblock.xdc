create_clock -period 10.000 -name clock [get_ports clk]
create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] -top
resize_pblock [get_pblocks pblock_1] -add {SLICE_X10Y0:SLICE_X13Y24}
resize_pblock [get_pblocks pblock_1] -add {DSP48_X0Y0:DSP48_X0Y9}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_1]
