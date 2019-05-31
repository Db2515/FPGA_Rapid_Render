# Generate bitstream from checkpoint file
# Args: checkpoint location {Route}

set route 1

if {$argc < 1} {
        puts "The script requires a path to the project xpr file as input"
        exit
}  elseif {$argc == 2} {
    set route [lindex $argv 1]
}

set outputFile [lindex $argv 0]
open_checkpoint $outputFile
if route {
    route_design
}
set outputDir set new [string range $outputFile 0 [string last / $outputFile]]
set bitLocation  "$outputDir/out.bit"
write_checkpoint -force $bitLocation

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