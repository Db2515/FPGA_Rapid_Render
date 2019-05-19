create_pblock pblock_1
add_cells_to_pblock [get_pblocks pblock_1] -top
resize_pblock [get_pblocks pblock_1] -add {SLICE_X4Y107:SLICE_X9Y114}
resize_pblock [get_pblocks pblock_1] -add {RAMB18_X0Y44:RAMB18_X0Y45}
resize_pblock [get_pblocks pblock_1] -add {RAMB36_X0Y22:RAMB36_X0Y22}
set_property CONTAIN_ROUTING 1 [get_pblocks pblock_1]
