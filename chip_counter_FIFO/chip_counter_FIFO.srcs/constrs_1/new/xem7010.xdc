############################################################################
# XEM7010 - Xilinx constraints file
#
# Pin mappings for the XEM7010.  Use this as a template and comment out 
# the pins that are not used in your design.  (By default, map will fail
# if this file contains constraints for signals not in your design).
#
# Copyright (c) 2004-2023 Opal Kelly Incorporated
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
############################################################################

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 1.2 [current_design]
set_property BITSTREAM.GENERAL.COMPRESS True [current_design]

set_property PACKAGE_PIN P20 [get_ports {hi_muxsel}]
set_property IOSTANDARD LVCMOS12 [get_ports {hi_muxsel}]

############################################################################
## FrontPanel Host Interface
############################################################################
set_property PACKAGE_PIN Y18  [get_ports {hi_in[0]}]
set_property PACKAGE_PIN V17  [get_ports {hi_in[1]}]
set_property PACKAGE_PIN AA19 [get_ports {hi_in[2]}]
set_property PACKAGE_PIN V20  [get_ports {hi_in[3]}]
set_property PACKAGE_PIN W17  [get_ports {hi_in[4]}]
set_property PACKAGE_PIN AB20 [get_ports {hi_in[5]}]
set_property PACKAGE_PIN V19  [get_ports {hi_in[6]}]
set_property PACKAGE_PIN AA18 [get_ports {hi_in[7]}]

set_property SLEW FAST [get_ports {hi_in[*]}]
set_property IOSTANDARD LVCMOS12 [get_ports {hi_in[*]}]

set_property PACKAGE_PIN Y21 [get_ports {hi_out[0]}]
set_property PACKAGE_PIN U20 [get_ports {hi_out[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {hi_out[*]}]

set_property PACKAGE_PIN AB22 [get_ports {hi_inout[0]}]
set_property PACKAGE_PIN AB21 [get_ports {hi_inout[1]}]
set_property PACKAGE_PIN Y22  [get_ports {hi_inout[2]}]
set_property PACKAGE_PIN AA21 [get_ports {hi_inout[3]}]
set_property PACKAGE_PIN AA20 [get_ports {hi_inout[4]}]
set_property PACKAGE_PIN W22  [get_ports {hi_inout[5]}]
set_property PACKAGE_PIN W21  [get_ports {hi_inout[6]}]
set_property PACKAGE_PIN T20  [get_ports {hi_inout[7]}]
set_property PACKAGE_PIN R19  [get_ports {hi_inout[8]}]
set_property PACKAGE_PIN P19  [get_ports {hi_inout[9]}]
set_property PACKAGE_PIN U21  [get_ports {hi_inout[10]}]
set_property PACKAGE_PIN T21  [get_ports {hi_inout[11]}]
set_property PACKAGE_PIN R21  [get_ports {hi_inout[12]}]
set_property PACKAGE_PIN P21  [get_ports {hi_inout[13]}]
set_property PACKAGE_PIN R22  [get_ports {hi_inout[14]}]
set_property PACKAGE_PIN P22  [get_ports {hi_inout[15]}]
set_property IOSTANDARD LVCMOS12 [get_ports {hi_inout[*]}]

set_property PACKAGE_PIN V22 [get_ports {hi_aa}]
set_property IOSTANDARD LVCMOS12 [get_ports {hi_aa}]


create_clock -name okHostClk -period 20.83 [get_ports {hi_in[0]}]

set_input_delay -add_delay -max -clock [get_clocks {okHostClk}]  11.000 [get_ports {hi_inout[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okHostClk}]  0.000  [get_ports {hi_inout[*]}]
set_multicycle_path -setup -from [get_ports {hi_inout[*]}] 2

set_input_delay -add_delay -max -clock [get_clocks {okHostClk}]  6.700 [get_ports {hi_in[*]}]
set_input_delay -add_delay -min -clock [get_clocks {okHostClk}]  0.000 [get_ports {hi_in[*]}]
set_multicycle_path -setup -from [get_ports {hi_in[*]}] 2

set_output_delay -add_delay -clock [get_clocks {okHostClk}]  8.900 [get_ports {hi_out[*]}]

set_output_delay -add_delay -clock [get_clocks {okHostClk}]  9.200 [get_ports {hi_inout[*]}]

# counter #####################################################################
set_property PACKAGE_PIN P4 [get_ports {counter_in[0]}]
set_property PACKAGE_PIN P1 [get_ports {counter_in[1]}]
set_property PACKAGE_PIN P6 [get_ports {counter_in[2]}]
set_property PACKAGE_PIN P2 [get_ports {counter_in[3]}]
set_property PACKAGE_PIN N5 [get_ports {counter_in[4]}]
set_property PACKAGE_PIN N2 [get_ports {counter_in[5]}]
set_property IOSTANDARD LVCMOS12 [get_ports {counter_in[*]}]


#set_property PACKAGE_PIN K1 [get_ports {counter_P[0]}]
#set_property PACKAGE_PIN K2 [get_ports {counter_P[1]}]
#set_property PACKAGE_PIN J1 [get_ports {counter_P[2]}]
#set_property PACKAGE_PIN J2 [get_ports {counter_P[3]}]
#set_property PACKAGE_PIN H2 [get_ports {counter_P[4]}]
#set_property PACKAGE_PIN K6 [get_ports {counter_P[5]}]
#set_property IOSTANDARD LVCMOS12 [get_ports {counter_P[*]}]

#set_property PACKAGE_PIN E2 [get_ports {counter_N[0]}]
#set_property PACKAGE_PIN G1 [get_ports {counter_N[1]}]
#set_property PACKAGE_PIN D2 [get_ports {counter_N[2]}]
#set_property PACKAGE_PIN F1 [get_ports {counter_N[3]}]
#set_property PACKAGE_PIN E1 [get_ports {counter_N[4]}]
#set_property PACKAGE_PIN F3 [get_ports {counter_N[5]}]
#set_property IOSTANDARD LVCMOS12 [get_ports {counter_N[*]}]

set_property PACKAGE_PIN L3 [get_ports {clk_in}]
set_property IOSTANDARD LVCMOS12 [get_ports {clk_in}]

#set_property PACKAGE_PIN L5 [get_ports {clk_32MHz_check}]
#set_property IOSTANDARD LVCMOS12 [get_ports {clk_32MHz_check}]

#set_property PACKAGE_PIN K3 [get_ports {test}]
#set_property IOSTANDARD LVCMOS12 [get_ports {test}]

set_property PACKAGE_PIN G2 [get_ports {clk_fs}]
set_property IOSTANDARD LVCMOS12 [get_ports {clk_fs}]

set_property PACKAGE_PIN J6 [get_ports {clk_2fs}]
set_property IOSTANDARD LVCMOS12 [get_ports {clk_2fs}]

# LEDs #####################################################################
set_property PACKAGE_PIN N13 [get_ports {led[0]}]
set_property PACKAGE_PIN N14 [get_ports {led[1]}]
set_property PACKAGE_PIN P15 [get_ports {led[2]}]
set_property PACKAGE_PIN P16 [get_ports {led[3]}]
set_property PACKAGE_PIN N17 [get_ports {led[4]}]
set_property PACKAGE_PIN P17 [get_ports {led[5]}]
set_property PACKAGE_PIN R16 [get_ports {led[6]}]
set_property PACKAGE_PIN R17 [get_ports {led[7]}]
set_property IOSTANDARD LVCMOS12 [get_ports {led[*]}]


# 200MHz clock
#set_property IOSTANDARD LVDS_25 [get_ports {sys_clk_p}]
#set_property IOSTANDARD LVDS_25 [get_ports {sys_clk_n}]
#set_property PACKAGE_PIN K4 [get_ports {sys_clk_p}]
#set_property PACKAGE_PIN J4 [get_ports {sys_clk_n}]

#create_clock -name sys_clk -period 5 [get_ports sys_clk_p]
#set_clock_groups -asynchronous -group [get_clocks {sys_clk}] -group [get_clocks {okHostClk mmcm0_clk0}]