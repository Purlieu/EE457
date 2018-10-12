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
-- Module Name: reg16_tb                      File Name: reg16_tb.vhd          *
--                                                                             *
-- Module Function: This file contains the testbench for the Introduction      *
-- 					to VHDL lab 4a									           *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY reg16_tb IS
END ENTITY reg16_tb;

ARCHITECTURE stimulus OF reg16_tb IS

	-- Component declaration for the DUT
	COMPONENT reg16
		PORT (
			clk, clk_ena, sclr_n : IN STD_LOGIC;
			datain: IN UNSIGNED (15 DOWNTO 0);
			reg_out : OUT UNSIGNED (15 DOWNTO 0)
		);
	END COMPONENT reg16;

	-- Signals to connect to DUT
	SIGNAL clk, clk_ena, sclr_n : STD_LOGIC;
	SIGNAL datain : UNSIGNED (15 DOWNTO 0);
	SIGNAL reg_out : UNSIGNED (15 DOWNTO 0);
	
BEGIN  -- beginning of architecture body

	-- instantiate unit under test (reg16)
	reg16_1 : reg16 
		PORT MAP (
			clk => clk, clk_ena => clk_ena, sclr_n => sclr_n,
			datain => datain, reg_out => reg_out
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
	reg_proc : PROCESS
	BEGIN
		clk_ena <= '0';
		sclr_n <= '0';
		datain <= x"1F1F";
		WAIT FOR 40 NS;
		clk_ena <= '1';
		WAIT FOR 40 NS;
		sclr_n <= '1';
		WAIT FOR 40 NS;
		datain <= x"4567";
		clk_ena <= '0';
		WAIT FOR 40 NS;
		clk_ena <= '1';
		WAIT FOR 40 NS;
		sclr_n <= '0';
		WAIT;
	END PROCESS reg_proc;
		
END ARCHITECTURE stimulus;