--******************************************************************************
--                                                                             *
--                  Copyright (C) 2014 Altera Corporation                      *
--                                                                             *
-- ALTERA, ARRIA, CYCLONE, HARDCOPY, MAX, MEGACORE, NIOS, QUARTUS & STRATIX    *
-- are Reg. U.S. Pat. & Tm. Off. and Altera marks in and outside the U.S.      *
--                                                                             *
-- All information provided herein is provided on an "as is" basis,            *
-- without warranty of any kind.                                               *
--                                                                             *
-- Module Name: mult4x4_tb                     File Name: mult4x4.vhd          *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 1b									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY mult4x4_tb IS
END ENTITY mult4x4_tb;

ARCHITECTURE stimulus OF mult4x4_tb IS

	-- Componenet declaration for multiplier block
	COMPONENT mult4x4
		PORT  (
			dataa, datab: IN UNSIGNED(3 DOWNTO 0);
			product: OUT UNSIGNED(7 DOWNTO 0)
		);
	END COMPONENT;

	-- Signals to connect to DUT
	SIGNAL dataa, datab: UNSIGNED (3 DOWNTO 0) := "0000";
	SIGNAL product : UNSIGNED (7 DOWNTO 0);

BEGIN  -- beginning of architecture body

	-- instantiate unit under test (mult4x4)
	mult4x4_1 : mult4x4 PORT MAP 
		(dataa => dataa, datab => datab, product => product);

	-- Add 2 to previous value of "dataa" after ever 10 ns
	dataa <= dataa + 3 AFTER 10 NS;
	
	-- Fix "datab" at the value of 2
	datab <= "0010";
		
END ARCHITECTURE stimulus;