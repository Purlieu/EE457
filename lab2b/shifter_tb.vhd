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
-- Module Name: shifter_tb                        File Name: shifter_tb.vhd    *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 2b									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--  Revision 1.0    12/05/2009 - Initial Revision  for QII 9.1                 *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY shifter_tb IS
END ENTITY shifter_tb;

ARCHITECTURE stimulus OF shifter_tb IS

	-- Component declaration for the DUT
	COMPONENT shifter 
		PORT ( 
			input: IN UNSIGNED (7 DOWNTO 0);
			shift_cntrl : IN UNSIGNED (1 DOWNTO 0);
			shift_out : OUT UNSIGNED (15 DOWNTO 0)
		);
	END COMPONENT shifter;

	-- Signals to connect to DUT
	SIGNAL input : UNSIGNED (7 DOWNTO 0);
	SIGNAL shift_cntrl : UNSIGNED (1 DOWNTO 0) := "00";
	SIGNAL shift_out : UNSIGNED (15 DOWNTO 0);

BEGIN  -- beginning of architecture body

	-- instantiate unit under test (mult4x4)
	shifter1 : shifter
		PORT MAP (
			input => input, shift_cntrl => shift_cntrl,
			shift_out => shift_out
		);

	-- Fix data input to hex value "F4"
	input <= x"F4";
	
	-- Create counter on shift control input to cycle through values every 50 ns
	shift_cntrl <= shift_cntrl + 1 AFTER 50 NS;
		
END ARCHITECTURE stimulus;