-- *****************************************************************************
--                                                                             *
--                  Copyright (C) 2014 Altera Corporation                      *
--                                                                             *
-- ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
-- are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
--                                                                             *
-- All information provided herein is provided on an "as is" basis,            *
-- without warranty of any kind.                                               *
--                                                                             *
-- Module Name: counter_tb                  File Name: counter_tb.vhd          *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 3b									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY counter_tb IS
END ENTITY counter_tb;

ARCHITECTURE stimulus OF counter_tb IS

	-- Component declaration for the DUT
	COMPONENT counter
		PORT (
			clk, aclr_n : IN STD_LOGIC;
			count_out : OUT UNSIGNED (1 DOWNTO 0)
		);
	END COMPONENT counter;

	-- Signals to connect to DUT
	SIGNAL clk, aclr_n : STD_LOGIC;
	SIGNAL count_out : UNSIGNED (1 DOWNTO 0);
	
BEGIN  -- beginning of architecture body

	-- instantiate unit under test (counter)
	counter_1 : counter 
		PORT MAP (
			clk => clk, aclr_n => aclr_n, count_out => count_out
		);
		
	-- Process to create clock signal
	clk_proc : PROCESS
	BEGIN
		clk <= '0';
		WAIT FOR 20 NS;
		clk <= '1';
		WAIT FOR 20 NS;
	END PROCESS clk_proc;

	-- Set input values to test register behavior
	aclr_n <= '0', '1' AFTER 40 NS;
		
END ARCHITECTURE stimulus;