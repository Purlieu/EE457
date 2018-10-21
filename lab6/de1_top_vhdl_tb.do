#******************************************************************************
#                                                                             *
#                  Copyright (C) 2009 Altera Corporation                      *
#                                                                             *
# ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
# are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
#                                                                             *
# All information provided herein is provided on an "as is" basis,            *
# without warranty of any kind.                                               *
#                                                                             *
# File Name: de1_top_vhdl_tb.do                                                    *
#                                                                             *
# Function: Script file for Introduction to VHDL exercise 5b                  *
#                                                                             *
# REVISION HISTORY:                                                           *
#  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
#******************************************************************************

vlib work
vcom traffic_contrl.vhd
vcom counter.vhd
vcom traffic_segment_cntrl.vhd
vcom de1_top.vhd 
vcom de1_top_vhdl_tb.vhd 
vsim -t ns work.de1_top_lab6_tb
add wave -height 20 -divider "DE1_top Signals"
add wave -noupdate /aclr_n
add wave -noupdate /clk
add wave -noupdate /sw
add wave -noupdate /key
add wave -noupdate /hex0
add wave -noupdate /hex1
add wave -noupdate /hex2
add wave -noupdate /hex3

add wave -noupdate -divider {Traffic Controller}
add wave -noupdate /de1_top_lab6_tb/dut/u6/current_state
add wave -noupdate /de1_top_lab6_tb/dut/u6/next_state
add wave -radix binary /de1_top_lab6_tb/dut/u6/count
add wave -noupdate /de1_top_lab6_tb/dut/u6/state_out

view wave
run 200 ns
