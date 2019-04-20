
################################################################
# This is a generated script based on design: board_2x2
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2018.3
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source board_2x2_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7a100tcsg324-1
   set_property BOARD_PART digilentinc.com:nexys-a7-100t:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name board_2x2

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
user.org:XUP:checkerboard_input:1.0\
user.org:XUP:rect_renderer:1.0\
user.org:XUP:simple_output:1.0\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set clk [ create_bd_port -dir I -type clk clk ]
  set color_out [ create_bd_port -dir O -from 31 -to 0 color_out ]
  set x_out [ create_bd_port -dir O -from 10 -to 0 x_out ]
  set y_out [ create_bd_port -dir O -from 11 -to 0 y_out ]

  # Create instance: checkerboard_input_0, and set properties
  set checkerboard_input_0 [ create_bd_cell -type ip -vlnv user.org:XUP:checkerboard_input:1.0 checkerboard_input_0 ]

  # Create instance: rect_renderer_0, and set properties
  set rect_renderer_0 [ create_bd_cell -type ip -vlnv user.org:XUP:rect_renderer:1.0 rect_renderer_0 ]
  set_property -dict [ list \
   CONFIG.SHAPE_ID {2} \
 ] $rect_renderer_0

  # Create instance: rect_renderer_1, and set properties
  set rect_renderer_1 [ create_bd_cell -type ip -vlnv user.org:XUP:rect_renderer:1.0 rect_renderer_1 ]
  set_property -dict [ list \
   CONFIG.SHAPE_ID {3} \
 ] $rect_renderer_1

  # Create instance: simple_output_0, and set properties
  set simple_output_0 [ create_bd_cell -type ip -vlnv user.org:XUP:simple_output:1.0 simple_output_0 ]

  # Create port connections
  connect_bd_net -net checkerboard_input_0_color_out [get_bd_pins checkerboard_input_0/color_out] [get_bd_pins rect_renderer_0/color_in]
  connect_bd_net -net checkerboard_input_0_program_out [get_bd_pins checkerboard_input_0/program_out] [get_bd_pins rect_renderer_0/program_in]
  connect_bd_net -net checkerboard_input_0_shape_height_out [get_bd_pins checkerboard_input_0/shape_height_out] [get_bd_pins rect_renderer_0/shape_height]
  connect_bd_net -net checkerboard_input_0_shape_width_out [get_bd_pins checkerboard_input_0/shape_width_out] [get_bd_pins rect_renderer_0/shape_width]
  connect_bd_net -net checkerboard_input_0_x_out [get_bd_pins checkerboard_input_0/x_out] [get_bd_pins rect_renderer_0/x]
  connect_bd_net -net checkerboard_input_0_y_out [get_bd_pins checkerboard_input_0/y_out] [get_bd_pins rect_renderer_0/y]
  connect_bd_net -net clk_0_1 [get_bd_ports clk] [get_bd_pins checkerboard_input_0/clk] [get_bd_pins rect_renderer_0/clk] [get_bd_pins rect_renderer_1/clk]
  connect_bd_net -net rect_renderer_0_color_out [get_bd_pins rect_renderer_0/color_out] [get_bd_pins rect_renderer_1/color_in]
  connect_bd_net -net rect_renderer_0_program_out [get_bd_pins rect_renderer_0/program_out] [get_bd_pins rect_renderer_1/program_in]
  connect_bd_net -net rect_renderer_0_shape_height_out [get_bd_pins rect_renderer_0/shape_height_out] [get_bd_pins rect_renderer_1/shape_height]
  connect_bd_net -net rect_renderer_0_shape_width_out [get_bd_pins rect_renderer_0/shape_width_out] [get_bd_pins rect_renderer_1/shape_width]
  connect_bd_net -net rect_renderer_0_x_out [get_bd_pins rect_renderer_0/x_out] [get_bd_pins rect_renderer_1/x]
  connect_bd_net -net rect_renderer_0_y_out [get_bd_pins rect_renderer_0/y_out] [get_bd_pins rect_renderer_1/y]
  connect_bd_net -net rect_renderer_1_color_out [get_bd_pins rect_renderer_1/color_out] [get_bd_pins simple_output_0/color_in]
  connect_bd_net -net rect_renderer_1_program_out [get_bd_pins rect_renderer_1/program_out] [get_bd_pins simple_output_0/program_in]
  connect_bd_net -net rect_renderer_1_shape_height_out [get_bd_pins rect_renderer_1/shape_height_out] [get_bd_pins simple_output_0/shape_height]
  connect_bd_net -net rect_renderer_1_shape_width_out [get_bd_pins rect_renderer_1/shape_width_out] [get_bd_pins simple_output_0/shape_width]
  connect_bd_net -net rect_renderer_1_x_out [get_bd_pins rect_renderer_1/x_out] [get_bd_pins simple_output_0/x]
  connect_bd_net -net rect_renderer_1_y_out [get_bd_pins rect_renderer_1/y_out] [get_bd_pins simple_output_0/y]
  connect_bd_net -net simple_output_0_color_out [get_bd_ports color_out] [get_bd_pins simple_output_0/color_out]
  connect_bd_net -net simple_output_0_x_out [get_bd_ports x_out] [get_bd_pins simple_output_0/x_out]
  connect_bd_net -net simple_output_0_y_out [get_bd_ports y_out] [get_bd_pins simple_output_0/y_out]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

