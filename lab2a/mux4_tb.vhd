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
-- Module Name: mux4_tb                        File Name: mux4_tb.vhd          *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 2a									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mux4_tb IS
END ENTITY mux4_tb;

ARCHITECTURE stimulus OF mux4_tb IS

	-- 
	COMPONENT mux4
		PORT ( 
		mux_in_a, mux_in_b: IN UNSIGNED(3 DOWNTO 0);
		mux_sel : IN STD_LOGIC;
		mux_out : OUT UNSIGNED(3 DOWNTO 0)
		);
	END COMPONENT mux4;

	-- Signals to connect to DUT
	SIGNAL mux_in_a, mux_in_b: UNSIGNED (3 DOWNTO 0);
	SIGNAL mux_sel : STD_LOGIC := '0';
	SIGNAL mux_out : UNSIGNED (3 DOWNTO 0);

BEGIN  -- beginning of architecture body

	-- instantiate unit under test (mult4x4)
	mux4_1 : mux4 
		PORT MAP (
			mux_in_a => mux_in_a, mux_in_b => mux_in_b,
			mux_sel => mux_sel, mux_out => mux_out
		);

	-- Fix mux inputs to input values 9 and 7 respectively
	mux_in_a <= "1001"; -- 9
	mux_in_b <= "0111"; -- 7
	
	-- Flip mux_sel between '0' and '1' every 50 ns
	mux_sel <= NOT mux_sel AFTER 50 NS;
		
END ARCHITECTURE stimulus;