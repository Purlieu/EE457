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
# File Name: mult8x8_tb.do                                                    *
#                                                                             *
# Function: Script file for Introduction to VHDL exercise 5b                  *
#                                                                             *
# REVISION HISTORY:                                                           *
#  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
#******************************************************************************

vlib work
vcom ./adder.vhd
vcom ./mult4x4.vhd
vcom ./mux4.vhd
vcom ./shifter.vhd
vcom ./seven_segment_cntrl.vhd
vcom ./reg16.vhd
vcom ./counter.vhd
vcom ./mult_control.vhd
vcom mult8x8.vhd mult8x8_tb.vhd
vsim -t ns work.mult8x8_tb
view wave
add wave -height 20 -divider "Control Signals"
add wave -radix binary /clk
add wave -radix binary /start
add wave -radix binary /reset_a
add wave -height 20 -divider "Multiplicands"
add wave -radix unsigned /dataa
add wave -radix unsigned /datab
add wave -height 20 -divider "Product & Done Flag"
add wave -radix unsigned /product8x8_out
add wave -radix binary /done_flag
add wave -height 20 -divider "7-segment Display"
add wave -radix binary /seg_a
add wave -radix binary /seg_b
add wave -radix binary /seg_c
add wave -radix binary /seg_d
add wave -radix binary /seg_e
add wave -radix binary /seg_f
add wave -radix binary /seg_g
add wave -height 20 -divider "Addt'l Signals"
add wave /mult8x8_tb/mult8x8_1/u6/current_state
run 5 us
