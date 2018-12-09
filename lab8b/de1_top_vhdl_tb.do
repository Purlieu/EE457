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
# File Name: adder_tb.do          											  *
#                                                                             *
# Function: Script file for Introduction to VHDL lab 1a                  	  *
#                                                                             *
# REVISION HISTORY:                                                           *
#  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
#******************************************************************************

vlib work
vcom de1_top.vhd 
vcom counter.vhd
vcom ram32x4.vhd
vcom seven_segment_cntrl.vhd
vcom double_d_ff.vhd
# Add any additional files here 
vcom de1_top_vhdl_tb.vhd 
vsim -t ns work.de1_top_tb
view wave
onerror {resume}
quietly WaveActivateNextPane {} 0
# add waves here you want to observe
# Fore more information http://www.tkt.cs.tut.fi/tools/public/tutorials/mentor/modelsim/getting_started/gsms.html

add wave -noupdate -divider {LED Ouputs}
add wave -noupdate /de1_top_tb/dut/hex0
add wave -noupdate /de1_top_tb/dut/hex1
add wave -noupdate /de1_top_tb/dut/hex2
add wave -noupdate /de1_top_tb/dut/hex3
add wave -noupdate /de1_top_tb/dut/hex4
add wave -noupdate /de1_top_tb/dut/hex5

add wave -noupdate -divider {Reset Key}
add wave -noupdate /de1_top_tb/dut/key(0)

add wave -noupdate -divider {Switches}
add wave -noupdate /de1_top_tb/dut/sw
add wave -noupdate /de1_top_tb/dut/switches

add wave -noupdate -divider {Ram}
add wave -noupdate /de1_top_tb/dut/ram_data
add wave -noupdate /de1_top_tb/dut/read_address

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20940 ns} 0}
quietly wave cursor active 1

configure wave -namecolwidth 260
configure wave -valuecolwidth 100
configure wave -justifyvalue right
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {18271 ns} {35307 ns}
run 100000 ns