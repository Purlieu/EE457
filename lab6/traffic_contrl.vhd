LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

--***************State Outline for Traffic Controller ******************
-- night_check 	 - 0000															  *
-- weight_check_NS - 0001															  *
-- green_arrow_a	 - 0010															  *
-- yellow_arrow_a	 - 0011															  *
-- green_a			 - 0100															  *
-- yellow_a			 - 0101															  *
-- weight_check_EW - 0110															  *
-- green_arrow_b   - 0111															  *
-- yellow_arrow_b  - 1000															  *
-- green_b			 - 1001															  *
-- yellow_b			 - 1010															  *
-- blinking_on		 - 1011															  *
-- blinking_off	 - 1100															  *
--**********************************************************************

-- Begin entity declaration for "control"
ENTITY traffic_control IS
	-- Begin port declaration
	PORT (
	
		-- Declare data inputs "clk", "reset_a", "weight_NS", "weight_EW", "night", "north_south"
		
		-- **clk**
		--		+ Based on a 50Mhz clock 
		--		+ One second will equal one "term" based on gen_counter
		clk: in std_logic;
		
		-- **reset_a**
		--		+ Used to determine if our state will reset to "night_check" in which
		--		  all lights are set to red
		--		+ KEY(0) is the input to determine if we reset or not
		--		  when KEY(0) is low we run, when KEY(0) is high we reset the state
		reset_a: in std_logic;
		
		-- **weight_NS**
		--		+ Input comes from SW(0) and determines North South turn signals
		--		+ When SW(0) runs high, we mimic that a car is waiting to turn
		--		  at the light, and simulate a left turn arrow
		--		+ When SW(0) runs low, we have no car waiting to turn, so states
		--		  run without a turn arrow
		weight_NS: in std_logic;
		
		-- **weight_EW**
		--		+ Input comes from SW(1) and determines East West turn signals
		--		+ When SW(0) runs high, we mimic that a car is waiting to turn
		--		  at the light, and simulate a left turn arrow
		--		+ When SW(0) runs low, we have no car waiting to turn, so states
		--		  run without a turn arrow
		weight_EW: in std_logic;

		-- **night**
		--		+ Input comes from SW(2) and determines if night mode is activated
		--		+ When SW(0) runs high, night mode is active
		--		+ When SW(0) runs low, night mode is deactivated
		--		+ Will trump SW(0) and SW(1) as once night_mode state is reached
		--		  weight checking won't occur until night mode is deactivated
		night: in std_logic;

		-- **north_south**
		--		+ std_logic of North and South segments receiving inputs of 1
		--		  and East and West segments receiving inputs of 0
		--		+ Used to determine cardinal directions of lights
		north_south: in std_logic;

		-- **count**
		--		+ std_logic where '1' is equivalent to 1 second when the clk reaches
		--		  50Mhz
		--		+ Used to determine if a second has passed
		count : in std_logic; 

		-- Declare output control signals "state_out"
		
		-- *state_out**
		--		+ Given the current inputs, state_out will change to determine what the
		--		  current state is to pass the information to the segment controller	
		state_out : OUT std_logic_vector(3 DOWNTO 0)
		);
-- End entity
END ENTITY traffic_control;

-- Begin architecture
architecture logic of traffic_control is
	-- Declare enumerated states consisting of 13 values:
		-- "night_check", 
		--	"weight_check_NS", 
		--	"weight_check_EW", 
		--	"green_arrow_a", 
		-- "green_arrow_b", 
		--	"yellow_arrow_a", 
		--	"yellow_arrow_b", 
		--	"green_a", 
		--	"green_b", 
		--	"yellow_a", 
		--	"yellow_b", 
		--	"blinking_on", 
		--	"blinking_off"
	type state_type is (night_check, weight_check_NS, weight_check_EW, green_arrow_a, 
							  green_arrow_b, yellow_arrow_a, yellow_arrow_b, green_a, green_b, 
							  yellow_a, yellow_b, blinking_on, blinking_off);
							  
	-- Declare two signals named "current_state" and "next_state" to be of enumerated type		  
		signal current_state: state_type;
		signal next_state: state_type;
begin
	-- Create sequential process to control state transitions by making current_state equal to next state on
	--	rising edge transitions; Use asynchronous clear control; Count = 1 will indicate 1 second passing
	process (clk, reset_a, count)
	begin
		if reset_a = '1' then
			current_state <= night_check;
		elsif clk'EVENT and clk='1' then
			--if count = '1' then
				current_state <= next_state;
			--end if;
		end if;
	end process;
	
	-- Create combinational process & case statement to determine next_state based on current state and inputs
	process (current_state, weight_NS, weight_EW, night, north_south)
	begin
		case current_state is
		-- Check to see state of input night based on SW(0)
			when night_check =>
			--	Check to see if night is active, if not, continue with normal light pattern
				if night = '0' then
					next_state <= weight_check_NS;
				else
					next_state <= blinking_on;
				end if;
			when blinking_on =>
			-- Blink on then off
				next_state <= blinking_off;
			when blinking_off =>
			-- Still in night mode, blink lights back on, otherwise move to normal light pattern
				if night = '1' then
					next_state <= blinking_on;
				else
					next_state <= night_check;
				end if;
			when weight_check_NS =>
			-- If a car is waiting, create an arrow for North-South lights, otherwise normal green light
				if weight_NS = '0' then
					next_state <= green_a;
				else
					next_state <= green_arrow_a;
				end if;
			when green_arrow_a =>
				next_state <= yellow_arrow_a;
			when yellow_arrow_a =>
			-- After yellow arrow completes, return to Green-Yellow-Red pattern
				next_state <= green_a;
			when green_a =>
				next_state <= yellow_a;
			when yellow_a =>
				next_state <= weight_check_EW;
			when weight_check_EW =>
			-- If a car is waiting, create an arrow for East-West lights, otherwise normal green light
				if weight_EW = '0' then
					next_state <= green_b;
				else
					next_state <= green_arrow_b;
				end if;
			when green_arrow_b =>
				next_state <= yellow_arrow_b;
			when yellow_arrow_b =>
			-- After yellow arrow completes, return to Green-Yellow-Red pattern
				next_state <= green_b;
			when green_b =>
				next_state <= yellow_b;
			when yellow_b =>
				next_state <= night_check;
			when others =>
				next_state <= night_check;
		--End case
		end case;
	-- End process
	end process;
	
				
	process (current_state)
	-- Create state out based on current state to pass to segment controller
	begin
		--Begin case for current_state
		case current_state is
			when night_check =>
				state_out <= "0000";
			when weight_check_NS =>
				state_out <= "0001";
			when green_arrow_a =>
				state_out <= "0010";
			when yellow_arrow_a =>
				state_out <= "0011";
			when green_a =>
				state_out <= "0100";
			when yellow_a =>
				state_out <= "0101";
			when weight_check_EW =>
				state_out <= "0110";
			when green_arrow_b =>
				state_out <= "0111";
			when yellow_arrow_b =>
				state_out <= "1000";
			when green_b =>
				state_out <= "1001";
			when yellow_b =>
				state_out <= "1010";
			when blinking_on =>
				state_out <= "1011";
			when blinking_off =>
				state_out <= "1100";
			when others =>
				state_out <= "0000";
		-- End case
		end case;
	-- End process
	end process;
-- End architecture
end logic;