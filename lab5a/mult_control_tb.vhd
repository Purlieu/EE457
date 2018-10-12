-- ******************************************************************************
--                                                                             *
--                  Copyright (C) 2014 Altera Corporation                      *
--                                                                             *
-- ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
-- are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
--                                                                             *
-- All information provided herein is provided on an "as is" basis,            *
-- without warranty of any kind.                                               *
--                                                                             *
-- Module Name: mult_control_tb        File Name: mult_control_tb.vhd          *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 5a									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mult_control_tb IS
END ENTITY mult_control_tb;

ARCHITECTURE stimulus OF mult_control_tb IS

	-- Component declaration for the DUT
	COMPONENT mult_control
		PORT (
			clk, reset_a, start : IN STD_LOGIC;
			count : IN UNSIGNED (1 DOWNTO 0);
			input_sel, shift_sel : OUT UNSIGNED(1 DOWNTO 0);
			state_out : OUT UNSIGNED(2 DOWNTO 0);
			done, clk_ena, sclr_n : OUT STD_LOGIC
		);
	END COMPONENT mult_control;	

	-- Signals to connect to DUT
	SIGNAL clk, reset_a, start : STD_LOGIC;
	SIGNAL count : UNSIGNED (1 DOWNTO 0);
	SIGNAL input_sel, shift_sel : UNSIGNED (1 DOWNTO 0);
	SIGNAL state_out : UNSIGNED (2 DOWNTO 0);	
	SIGNAL done, clk_ena, sclr_n : STD_LOGIC;
	
BEGIN  -- beginning of architecture body

	-- instantiate unit under test (control)
	mult_control1 : mult_control 
		PORT MAP (
			clk => clk, reset_a => reset_a, count => count, input_sel => input_sel,
			shift_sel => shift_sel, state_out => state_out, done => done, 
			clk_ena => clk_ena, sclr_n => sclr_n, start => start
		);
		
	-- Process to create clock signal
	clk_proc : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR 25 NS;
		clk <= '1';
		WAIT FOR 25 NS;
	END PROCESS clk_proc;

	-- Set the reset control
	reset_a	 <= '1', '0' AFTER 50 NS;
	
	-- Process to control counter
	counter_proc : PROCESS
	BEGIN
		count <= "00";
		WAIT FOR 125 NS;
		FOR i IN 0 TO 3 LOOP
			count <= count + 1;
			WAIT FOR 50 NS;
		END LOOP;
		WAIT;
	END PROCESS counter_proc;
	
	-- Start signal control
	start <= '0', '1' AFTER 50 NS, '0' AFTER 100 NS;
		
END ARCHITECTURE stimulus;