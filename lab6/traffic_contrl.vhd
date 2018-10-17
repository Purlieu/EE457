LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY traffic_control IS
	-- Begin port declaration
	PORT (

		clk, reset_a, weight_NS, weight_EW, night, north_south: IN STD_LOGIC;
		count : in std_logic; -- 1 if we've reached a second interval
		-- Declare output control signals "in_sel", "shift_sel", "state_out", "done", "clk_ena" and "sclr_n"
		state_out : OUT std_logic_vector(3 DOWNTO 0)
		);
-- End entity
END ENTITY traffic_control;

architecture logic of traffic_control is
	type state_type is (night_check, weight_check_NS, weight_check_EW, green_arrow_a, 
							  green_arrow_b, yellow_arrow_a, yellow_arrow_b, green_a, green_b, 
							  yellow_a, yellow_b, blinking_on, blinking_off);
							  
		signal current_state: state_type;
		signal next_state: state_type;
begin
	process (clk, reset_a)
	begin
		if reset_a = '1' then
			current_state <= night_check;
		elsif rising_edge(clk) then
			if count = '1' then
				current_state <= next_state;
			end if;
		end if;
	end process;
	
	process (current_state, weight_NS, weight_EW, night, north_south, count)
	begin
		case current_state is
			when night_check =>
				if night = '0' then
					next_state <= weight_check_NS;
				else
					next_state <= blinking_on;
				end if;
			when blinking_on =>
				next_state <= blinking_off;
			when blinking_off =>
				if night = '1' then
					next_state <= blinking_on;
				else
					next_state <= night_check;
				end if;
			when weight_check_NS =>
				if weight_NS = '0' then
					next_state <= green_a;
				else
					next_state <= green_arrow_a;
				end if;
			when green_arrow_a =>
				next_state <= yellow_arrow_a;
			when yellow_arrow_a =>
				next_state <= green_a;
			when green_a =>
				next_state <= yellow_a;
			when yellow_a =>
				next_state <= weight_check_EW;
			when weight_check_EW =>
				if weight_EW = '0' then
					next_state <= green_b;
				else
					next_state <= green_arrow_b;
				end if;
			when green_arrow_b =>
				next_state <= yellow_arrow_b;
			when yellow_arrow_b =>
				next_state <= green_b;
			when green_b =>
				next_state <= yellow_b;
			when yellow_b =>
				next_state <= night_check;
			when others =>
				next_state <= night_check;
		end case;
	end process;
	
				
	process (current_state, night, north_south)
	begin
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
		end case;
	end process;
end logic;