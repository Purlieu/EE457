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
-- Module Name: seven_segment_cntrl_tb    le Name: seven_segment_cntrl_tb.vhd  *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 3									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY seven_segment_cntrl_tb IS
END ENTITY seven_segment_cntrl_tb;

ARCHITECTURE stimulus OF seven_segment_cntrl_tb IS

	-- Component declaration for the DUT
	COMPONENT seven_segment_cntrl
		PORT (
			input : IN UNSIGNED(2 DOWNTO 0);
			seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g : OUT STD_LOGIC
		);
	END COMPONENT seven_segment_cntrl;

	-- Signals to connect to DUT
	SIGNAL input : UNSIGNED (2 DOWNTO 0) := "000";
	SIGNAL seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g : STD_LOGIC;

BEGIN  -- beginning of architecture body

	-- instantiate unit under test (mult4x4)
	seven_segment_cntrl1 : seven_segment_cntrl 
		PORT MAP (
			input => input, seg_a => seg_a, seg_b => seg_b, seg_c => seg_c,
			seg_d => seg_d, seg_e => seg_e, seg_f => seg_f, seg_g => seg_g
		);

	-- Set input equal to values 0 - 7 for  50 ns each
	input <= input + 1 AFTER 50 NS;
		
END ARCHITECTURE stimulus;