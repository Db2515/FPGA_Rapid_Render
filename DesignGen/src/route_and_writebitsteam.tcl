# Generate bitstream from checkpoint file
# Args: checkpoint location Route write_to_hardware

if {$argc != 3} {
        puts "The script requires a path to the checkpoint file, routing boolean and write to hardware boolean as input"
        exit
}  else {
    set route [lindex $argv 1]
    set write_to_hardware [lindex $argv 2]
}

set outputFile [lindex $argv 0]
open_checkpoint $outputFile

if {$route == 1} {
    route_design
}

if {$write_to_hardware == 1} {
    set outputDir [string range $outputFile 0 [string last / $outputFile]]
    set bitLocation  "$outputDir/out.bit"
    write_bitstream -force $bitLocation

    open_hw
    connect_hw_server
    open_hw_target
    current_hw_device [get_hw_devices xc7a35t_0]
    refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xc7a35t_0] 0]
    set_property PROBES.FILE {} [get_hw_devices xc7a35t_0]
    set_property FULL_PROBES.FILE {} [get_hw_devices xc7a35t_0]
    set_property PROGRAM.FILE {$bitLocation} [get_hw_devices xc7a35t_0]
    program_hw_devices [get_hw_devices xc7a35t_0]
    refresh_hw_device [lindex [get_hw_devices xc7a35t_0] 0]
}