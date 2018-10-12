-- *****************************************************************************
--                                                                             *
--                  Copyright (C) 2009 Altera Corporation                      *
--                                                                             *
-- ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
-- are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
--                                                                             *
-- All information provided herein is provided on an "as is" basis,            *
-- without warranty of any kind.                                               *
--                                                                             *
-- Module Name: mult8x8_tb                  File Name: mult8x8_tb.vhd          *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 4b									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mult8x8_tb IS
END ENTITY mult8x8_tb;

ARCHITECTURE stimulus OF mult8x8_tb IS

	-- Component declaration for the DUT
	COMPONENT mult8x8
		PORT (
			clk, start, reset_a : IN STD_LOGIC;
			dataa, datab : IN UNSIGNED(7 DOWNTO 0);
			product8x8_out : OUT UNSIGNED(15 DOWNTO 0);
			seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, done_flag : OUT STD_LOGIC
		);
	END COMPONENT mult8x8;

	-- Signals to connect to DUT
	SIGNAL clk, start, reset_a : STD_LOGIC;
	SIGNAL dataa, datab : UNSIGNED (7 DOWNTO 0) := x"FF"; -- Initialized to 1
	SIGNAL product8x8_out : UNSIGNED (15 DOWNTO 0);
	SIGNAL seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, done_flag : STD_LOGIC;
	
BEGIN  -- beginning of architecture body

	-- instantiate unit under test (counter)
	mult8x8_1 : mult8x8 
		PORT MAP (
			clk => clk, start => start, reset_a => reset_a,
			dataa => dataa, datab => datab, product8x8_out => product8x8_out,
			done_flag => done_flag, seg_a => seg_a, seg_b => seg_b, seg_c => seg_c,
			seg_d => seg_d, seg_e => seg_e, seg_f => seg_f, seg_g => seg_g
		);
		
	-- Process to create clock signal
	clk_proc : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR 25 NS;
		clk <= '1';
		WAIT FOR 25 NS;
	END PROCESS clk_proc;
	
	-- Reset control
	reset_a <= '1', '0' AFTER 50 NS;

	-- Set input values to control start signal behavior
	start_proc : PROCESS
	BEGIN
		start <= '1';
		WAIT FOR 50 NS;
		LOOP
			start <= '1';
			WAIT FOR 50 NS;
			start <= '0';
			WAIT UNTIL falling_edge (done_flag);
			WAIT FOR 25 NS;
		END LOOP;
	END PROCESS start_proc;
	
	-- Process to control data inputs
	data_proc : PROCESS
	BEGIN
		WAIT UNTIL falling_edge (done_flag);
		WAIT FOR 25 NS;
		dataa <= dataa + 24;
		datab <= datab + 51;
	END PROCESS data_proc;

END ARCHITECTURE stimulus;