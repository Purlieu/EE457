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
# File Name: de1_top_vhdl_tb.do                                               *
#                                                                             *
# Function: Script file for Introduction to VHDL exercise 5b                  *
#                                                                             *
# REVISION HISTORY:                                                           *
#  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
#******************************************************************************

vlib work
vcom stopwatch.vhd
vcom counter.vhd
vcom seven_segment_controller.vhd
vcom de1_top.vhd 
vcom de1_top_vhdl_tb.vhd 
vsim -t ns work.de1_top_lab7_tb
add wave -height 20 -divider "DE1_top Signals"
add wave -noupdate /aclr_n
add wave -noupdate /clk
add wave -noupdate /ledr
add wave -noupdate /sw
add wave -noupdate /key
add wave -noupdate /hex0
add wave -noupdate /hex1
add wave -noupdate /hex2
add wave -noupdate /hex3

add wave -noupdate -divider {State Controller}
add wave -noupdate /de1_top_lab7_tb/dut/u2/current_state	
add wave -noupdate /de1_top_lab7_tb/dut/u2/next_State
add wave -noupdate /de1_top_lab7_tb/dut/u2/delay_completed
add wave -noupdate /de1_top_lab7_tb/dut/u2/start
add wave -noupdate -divider {Time}
add wave -noupdate /de1_top_lab7_tb/dut/u2/hundreds_out
add wave -noupdate /de1_top_lab7_tb/dut/u2/tenths_out
add wave -noupdate /de1_top_lab7_tb/dut/u2/seconds_out
add wave -noupdate /de1_top_lab7_tb/dut/u2/ten_seconds_out
add wave -noupdate -divider {Wait Time}
add wave -noupdate /de1_top_lab7_tb/dut/u2/hold_val
add wave -noupdate /de1_top_lab7_tb/dut/u2/total
add wave -noupdate /de1_top_lab7_tb/dut/u2/result_completed

add wave -noupdate -divider {Light One}
add wave -noupdate /de1_top_lab7_tb/dut/u3/light_out
add wave -noupdate -divider {Light Two}
add wave -noupdate /de1_top_lab7_tb/dut/u4/light_out
add wave -noupdate -divider {Light Three}
add wave -noupdate /de1_top_lab7_tb/dut/u5/light_out
add wave -noupdate -divider {Light Four}
add wave -noupdate /de1_top_lab7_tb/dut/u6/light_out
view wave
run 200 ns
