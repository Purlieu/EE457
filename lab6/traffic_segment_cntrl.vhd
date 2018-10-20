LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

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

-- Begin entity declaration for traffic_segment_cntrl
entity traffic_segment_cntrl is
	-- Begin port declaration
	port (
		-- Declare data inputs "north_south" and "input"
		
		-- **north_south**
		--		+ Used to determine if a set of lights will face cardinal directions
		--		  North and South or East and West
		-- 	+ North HEX(0), South HEX(1), East HEX(2), West HEX(3)
		north_south : in std_logic;
		
		-- **input**
		--		+ Will determine what the current state is based on output 
		--      from traffic_cntrl
		input :  in std_logic_vector(3 downto 0);
		
		-- Declare output "output" for seven segment display
		
		-- **output**
		--		+ Used to determine which light segments to turn on or off
		--	     in the seven segment lights
		output : out std_logic_vector(6 downto 0)
	);
-- End entity
end entity traffic_segment_cntrl;

--  Begin architecture 
architecture logic of traffic_segment_cntrl is
begin
	-- Create combinational process & case statement to determine output 
	-- of seven segments displays based on input
	process(input, north_south) is
	-- Begin process
			begin
			case input is
			-- input is "night_check"
				when "0000" => 
					-- All lights Red
					output <= "1110111";
				-- input is "weight_check_NS"
				when "0001" =>
					-- All lights Red
					output <= "1110111";
				-- input is "green_arrow_a"
				when "0010" =>
					-- North and South lights get Green Arrow
					if north_south = '1' then
						output <= "1111011";
					else
					-- East and West lights get Red
						output <= "1110111";
					end if;
				-- input is "yellow_arrow_a"
				when "0011" =>
					-- North and South lights get Yellow Arrow
					if north_south = '1' then
						output <= "1111101";
					else
					-- East and West lights get Red
						output <= "1110111";
					end if;
				-- input is "green_a"
				when "0100" =>
					-- North and South lights get Green
					if north_south = '1' then
						output <= "0111111";
					else
					-- East and West lights get Red
						output <= "1110111";
					end if;
				-- input is "yellow_a"
				when "0101" =>
					-- North and South lights get Yellow
					if north_south = '1' then
						output <= "1111110";
					else
					-- East and West lights get Red
						output <= "1110111";
					end if;
				-- input is "weight_check_EW"
				when "0110" =>
					-- All lights Red
					output <= "1110111";
				-- input is "green_arrow_b"
				when "0111" =>
					-- North and SOuth lights get Red
					if north_south = '1' then
						output <= "1110111";
					else
					-- East and West lights get Green Arrow
						output <= "1111011";
					end if;
				-- input is "yellow_arrow_b"
				when "1000" =>
					-- North and South lights get Red
					if north_south = '1' then
						output <= "1110111";
					else
					-- East and West lights get Yellow Arrow
						output <= "1111101";
					end if;
				-- input is "green_b"
				when "1001" =>
					-- North and South lights get Red
					if north_south = '1' then
						output <= "1110111";
					else
					-- East and West lights get Green
						output <= "0111111";
					end if;
				-- input is "yellow_b"
				when "1010" =>
					-- North and South lights get Red
					if north_south = '1' then
						output <= "1110111";
					else
					-- East and West lights get Yellow
						output <= "1111110";
					end if;
				-- input is "blinking_on"
				when "1011" =>
					-- North and South will blink Red
					if north_south = '1' then
						output <= "1110111";	
					else
					-- East and West will blink Yellow
						output <= "1111110";
					end if;
				-- input is "blinking_off"
				when "1100" =>
					-- All lights are turned off
					output <= "1111111";
				-- Incase of others, assume red light for safety reasons
				when others =>
						output <= "1110111";
			end case;
		-- End process
		end process;
	-- End architecture
end logic;
