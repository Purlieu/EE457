-- Insert library and use clauses
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY traffic_control IS
	-- Begin port declaration
	PORT (
		-- Declare control inputs "clk", "reset_a", "start", "count"
		clk, reset_a, start, weight, night, north_south : IN STD_LOGIC;
		count : IN UNSIGNED (1 DOWNTO 0);
		
		-- Declare output control signals "in_sel", "shift_sel", "state_out", "done", "clk_ena" and "sclr_n"
		directionN, directionS, directionE, directionW : out unsigned (2 downto 0);
		input_sel, shift_sel : OUT UNSIGNED(1 DOWNTO 0);
		state_out : OUT UNSIGNED(2 DOWNTO 0);
		done, clk_ena, sclr_n : OUT STD_LOGIC
	);
-- End entity
END ENTITY traffic_control;

--  Begin architecture 
ARCHITECTURE logic OF traffic_control IS

	-- Declare enumberated state type consisting of 6 values:  "idle", "lsb", "mid", "msb", "calc_done" and "err"
	type state_type is (night_check, weight_check, greem_arrow_a, green_arrow_b, yellow_arrow_a, yellow_arrow_b,
							  green_a, green_b, yellow_a, yellow_b, blinking_on, blinking_off);
	
	-- Declare two signals named "current_state" and "next_state" to be of enumerated type
	signal current_state: state_type;
	signal next_state: state_type;

 
BEGIN
	-- Create sequential process to control state transitions by making current_state equal to next state on
	--	rising edge transitions; Use asynchronous clear control
	PROCESS (clk, reset_a)
	begin
		if reset_a = '1' then
			current_state <= idle;
		elsif clk'event and clk = '1' then
			current_state <= next_state;
		end if;
	END PROCESS;
	
	-- Create combinational process & case statement to determine next_state based on current state and inputs
	PROCESS (current_state, next_state, start, count, weight, night, north_south)
	BEGIN
		CASE current_state IS
			WHEN night_check =>
				if night = '0' then
					next_state <= weight_check;
				else
					next_State <= blinking_on;
				end if;
			when blinking_on =>
					next_state <= blinking_off;
			when blinking_off =>
					next_state <= night_check;
			when weight_check =>
				if weight = '1' and north_south = '1' then
					next_state <= green_arrow_a;
				elsif weight = '1' and north_soth = '0' then
					next_state <= green_arrow_b;
				elsif weight = '0' and north_south = '1' then
					next_state <= green_a;
				else
					next_state <= green_b;
			when green_arrow_a =>
					next_state <= yellow_arrow_a;
			when yellow_arrow_a =>
					next_state <= green_a;
			when green_a =>
					next_state <= yellow_a;
			when yellow_a => 
					next_state <= night_check;
			when green_arrow_b =>
					next_state <= yellow_arrow_b;
			when yellow_arrow_b =>
					next_state <= green_b;
			when green_b =>
					next_state <= yellow_b;
			when yellow_b => 
					next_state <= night_check;
		END CASE;
	-- End process
	END PROCESS;

	-- Create process for Mealy output logic for input_sel, shift_sel, done, clk_ena and sclr_n(outputs function of inputs and current_state)
	mealy: PROCESS (current_state, start, count, weight, night, north_south) 
	BEGIN
	
		-- Initialize outputs to default values so case only covers when they change
		-- #### the following default values may need to be changed ####
		-- direction N - 00, S - 01, E - 10, W - 11
		-- Green - 000
		-- Yellow - 001
		-- Red - 010
		-- Green Left - 011
		-- Yellow Left - 100
		-- None - 101
		direction <= "XX";
		input_sel <= "XX";
		shift_sel <= "XX";
		done <= '0';
		clk_ena <= '0';
		sclr_n <= '1';
		
		CASE current_state IS
			WHEN night_check =>
					directionN <= "010"
					directionS <= "010"
					directionE <= "010"
					directionW <= "010"	
			when weight_check =>
				if weight = '1' and north_south = '1' then
					directionN <= "011"
					directionS <= "011"
					directionE <= "010"
					directionW <= "010"	
				elsif weight = '1' and north_south = '0' then
					directionN <= "010"
					directionS <= "010"
					directionE <= "011"
					directionW <= "011"
				else if weight = '0' and north_south = '1' then
					directionN <= "000"
					directionS <= "000"
					directionE <= "010"
					directionW <= "010"
				else
					directionN <= "010"
					directionS <= "010"
					directionE <= "000"
					directionW <= "000"
				end if;
			when s
		END CASE;
	-- End process
	END PROCESS mealy;

	-- Create process for Moore output logic for state_out  (outputs function of current_state only)
		moore: PROCESS(current_state)
		BEGIN
			-- Initialize state_out to default values so case only covers when they change
			state_out <= "000";
			
			CASE current_state IS
				WHEN idle =>
					state_out <= "000";
				WHEN lsb =>
					state_out <= "001";
				when mid =>
					state_out <= "010";
				when msb =>
					state_out <= "011";
				when calc_done =>
					state_out <= "100";
				when err =>
					state_out <= "101";
			END CASE;
		-- End process
		END PROCESS moore;
-- End architecture
END ARCHITECTURE logic;