LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for "control"
ENTITY traffic_control IS
	-- Begin port declaration
	PORT (

		clk, reset_a, weight, night, north_south: IN STD_LOGIC;
		count : in std_logic_vector(3 downto 0); -- 1 if we've reached a second interval
		-- Declare output control signals "in_sel", "shift_sel", "state_out", "done", "clk_ena" and "sclr_n"
		state_out : OUT std_logic_vector(3 DOWNTO 0);
		reset_out : out std_logic
		);
-- End entity
END ENTITY traffic_control;

architecture logic of traffic_control is
	type state_type is (night_check, weight_check_NS, weight_check_EW, green_arrow_a, green_arrow_b, yellow_arrow_a, yellow_arrow_b,
							  green_a, green_b, yellow_a, yellow_b, blinking_on, blinking_off);
							  
		signal current_state: state_type;
		signal next_state: state_type;
begin
	process (clk, reset_a)
	begin
		if reset_a = '1' then
			current_state <= night_check;
			reset_out <= '1';
		elsif clk'event and clk = '1' then
			if current_state = weight_check_NS
			or current_state = weight_check_EW
			or count = "1001"
			then
				reset_out <= '1';
			else
				reset_out <= '0';
			end if;
			current_state <= next_state;
		end if;
	end process;
	
	process (current_state, weight, night, north_south, count)
	begin
		case current_state is
			when night_check =>
				if night = '0' then 
					next_state <= weight_check_NS;
				else
					next_state <= blinking_on;
				end if;
			when weight_check_NS =>
				if weight = '1' then
					next_state <= green_arrow_a;
				else
					next_state <= green_a;
				end if;
			when weight_check_EW =>
				if weight = '1' then
					next_state <= green_arrow_b;
				else
					next_state <= green_b;
				end if;
			when green_arrow_a =>
					if count = "0111" then
						next_state <= yellow_arrow_a;
					else
						next_state <= current_state;
					end if;
			when yellow_arrow_a =>
					if count = "1001" then
						next_state <= green_a;
					else
						nexT_state <= current_state;
					end if; 	
			when green_a =>
					if count = "0111" then
						next_state <= yellow_a;
					else
						next_state <= current_state;
					end if;
			when yellow_a =>
					if count = "1001" then
						next_state <= weight_check_EW;
					else
						next_state <= current_state;
					end if;
			when green_arrow_b =>
					if count = "0111" then
						next_state <= yellow_arrow_b;
					else
						next_state <= current_state;
					end if;
			when yellow_arrow_b =>
					if count = "1001" then
						next_state <= green_b;
					else
						next_state <= current_state;
					end if;
			when green_b =>
					if count = "0111" then
						next_state <= yellow_b;
					else
						next_state <= current_state;
					end if;
			when yellow_b =>
					if count = "1001" then
						next_state <= night_check;
					else
						next_state <= current_state;
					end if;
			when blinking_on =>
					next_state <= blinking_off;
			when blinking_off =>
					if night = '1' then
						next_state <= blinking_on;
					else
						next_state <= night_check;
					end if;
		end case;
	end process;
	
				
	process (current_state, weight, night, north_south)
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
			when green_arrow_b =>
				state_out <= "0110";
			when yellow_arrow_b =>
				state_out <= "0111";
			when green_b =>
				state_out <= "1000";
			when yellow_b =>
				state_out <= "1001";
			when blinking_on =>
				state_out <= "1010";
			when blinking_off =>
				state_out <= "1011";
			when weight_check_EW =>
				state_out <= "1100";
		end case;
	end process;
end logic;