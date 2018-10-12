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
-- Module Name: mult8x8                        File Name: mult8x8.vhd          *
--                                                                             *
-- Module Function: This file contains the top level module for the            *
--                  8x8 multiplier                                             *
--                                                                             *
-- REVISION HISTORY:                                                           *
--******************************************************************************

-- Insert library and use clauses
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for top-level "mult8x8"
ENTITY mult8x8 IS
	-- Begin port declartion
	PORT (
		-- Declare control inputs "clk", "start" and "reset_a"
		clk, start, reset_a : IN STD_LOGIC;
		
		-- Declare data inputs "dataa" and "datab"
		dataa, datab : IN UNSIGNED(7 DOWNTO 0);

		-- Declare multiplier output "product8x8_out"
		product8x8_out : OUT UNSIGNED(15 DOWNTO 0);
		
		-- Declare seven segment display outputs
		seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g, done_flag : OUT STD_LOGIC
	);
-- End entity
END ENTITY mult8x8;

--  Begin architecture 
ARCHITECTURE logic OF mult8x8 IS

	-- Declare all lower level components
	COMPONENT adder
		PORT (  
			dataa, datab : IN UNSIGNED (15 DOWNTO 0);
			sum : OUT UNSIGNED (15 DOWNTO 0)
		);
	END COMPONENT adder;

	component mult4x4
		port (
		dataa :in unsigned(3 downto 0);
		datab :in unsigned(3 downto 0);
		product :out unsigned (7 downto 0)
	);
	end component mult4x4;
	
	component mux4
	port (
		mux_in_a :in unsigned(3 downto 0);
		mux_in_b :in unsigned(3 downto 0);
		mux_sel :in std_logic;
		mux_out :out unsigned(3 downto 0)
	);
	end component mux4;

	component shifter 
	port (
		input :in unsigned(7 downto 0);
		shift_cntrl: in unsigned(1 downto 0);
		shift_out: out unsigned(15 downto 0)
	);
	end component shifter;
	
	component seven_segment_cntrl
	port(
		input: in unsigned(2 downto 0);
		seg_a: out std_logic;
		seg_b: out std_logic;
		seg_c: out std_logic;
		seg_d: out std_logic;
		seg_e: out std_logic;
		seg_f: out std_logic;
		seg_g: out std_logic
	);
	end component seven_segment_cntrl;
	
	component reg16
	port(
		clk: in std_logic;
		sclr_n: in std_logic;
		clk_ena: in std_logic;
		datain: in unsigned(15 downto 0);
		reg_out: out unsigned(15 downto 0)
	);
	end component reg16;
	
	component counter
	port(
		clk: in std_logic;
		aclr_n: in std_logic;
		count_out: out unsigned(1 downto 0)
		);
	end component counter;
	
	component mult_control
	-- Begin port declaration
	PORT (
		-- Declare control inputs "clk", "reset_a", "start", "count"
		clk, reset_a, start : IN STD_LOGIC;
		count : IN UNSIGNED (1 DOWNTO 0);
		
		-- Declare output control signals "in_sel", "shift_sel", "state_out", "done", "clk_ena" and "sclr_n"
		input_sel, shift_sel : OUT UNSIGNED(1 DOWNTO 0);
		state_out : OUT UNSIGNED(2 DOWNTO 0);
		done, clk_ena, sclr_n : OUT STD_LOGIC
	);
-- End entity
	END component mult_control;

	
	-- Declare internal signals to use as wires to connect blocks
	-- used these signals to connect up all the components
	-- you should not need anymore signals
	
	SIGNAL aout, bout : UNSIGNED(3 DOWNTO 0);
   SIGNAL product : UNSIGNED(7 DOWNTO 0);
	SIGNAL shift_out, sum, product8x8 : UNSIGNED(15 DOWNTO 0);
	SIGNAL count, shift : UNSIGNED(1 DOWNTO 0);
	SIGNAL state_out : UNSIGNED(2 DOWNTO 0);
	SIGNAL clk_ena, sclr_n, start_n : std_logic;
	SIGNAL sel : UNSIGNED(1 DOWNTO 0);



BEGIN
	-- Start SIGNAL requires inversion before connecting to counter
	start_n <= not(start);

	-- Connect blocks per schematic in the lab manual
	-- this port map is completed
	u1: mux4 PORT MAP (
		mux_in_a => dataa(3 DOWNTO 0), 
	   mux_in_b => dataa(7 DOWNTO 4), 
		mux_sel => sel(1),
		mux_out => aout
		);

					   
	u2: mux4 PORT MAP (
		mux_in_a => datab(3 DOWNTO 0), 
	   mux_in_b => datab(7 DOWNTO 4), 
		mux_sel => sel(0),
		mux_out => bout
		);
		
	u3: mult4x4 PORT MAP (
		dataa => aout(3 downto 0),
		datab => bout(3 downto 0),
		product => product(7 downto 0)
		);

	u4: shifter PORT MAP (
		input => product(7 downto 0),
		shift_cntrl => shift(1 downto 0),
		shift_out => shift_out(15 downto 0)
	);

	u5: counter PORT MAP (
		clk => clk,
		aclr_n => start_n,
		count_out => count(1 downto 0)
	);

	u6: mult_control PORT MAP (
		clk => clk,
		reset_a => reset_a,
		start => start,
		count => count(1 downto 0),
		input_sel => sel(1 downto 0),
		shift_sel => shift(1 downto 0),
		state_out => state_out(2 downto 0),
		clk_ena => clk_ena,
		sclr_n => sclr_n,
		done => done_flag	
	);

	u7: reg16 PORT MAP (
		clk => clk,
		sclr_n => sclr_n,
		clk_ena => clk_ena,
		datain => sum(15 downto 0),
		reg_out => product8x8(15 downto 0)
	);

	u8: adder PORT MAP (
		dataa => shift_out(15 downto 0),
		datab => product8x8(15 downto 0),
		sum => sum(15 downto 0)
	);

	u9: seven_segment_cntrl PORT MAP (
		input => state_out(2 downto 0),
		seg_a => seg_a,
		seg_b => seg_b,
		seg_c => seg_c,
		seg_d => seg_d,
		seg_e => seg_e,
		seg_f => seg_f,
		seg_g => seg_g
	);
							
	product8x8_out <= product8x8;

-- End architecture
END ARCHITECTURE logic;