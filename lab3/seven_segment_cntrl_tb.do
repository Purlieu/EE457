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
# File Name: seven_segment_cntrl_tb.do                                        *
#                                                                             *
# Function: Script file for Introduction to VHDL lab 3  	                  *
#                                                                             *
# REVISION HISTORY:                                                           *
#  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
#******************************************************************************

vlib work
vcom seven_segment_cntrl.vhd seven_segment_cntrl_tb.vhd
vsim -t ns work.seven_segment_cntrl_tb
view wave
add wave -radix binary /input
add wave -radix binary /seg_a
add wave -radix binary /seg_b
add wave -radix binary /seg_c
add wave -radix binary /seg_d
add wave -radix binary /seg_e
add wave -radix binary /seg_f
add wave -radix binary /seg_g
run 500 ns