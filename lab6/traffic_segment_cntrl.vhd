LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

entity traffic_segment_cntrl is
	port (
		north_south : in std_logic;
		input :  in std_logic_vector(3 downto 0);
		output : out std_logic_vector(6 downto 0)
	);
	
end entity traffic_segment_cntrl;

architecture logic of traffic_segment_cntrl is
begin
	process(input, north_south) is
			begin
			case input is
				when "0000" => 
					output <= "1110111";
				when "0001" =>
					output <= "1110111";
				when "0010" =>
					if north_south = '1' then
						output <= "1111011";
					else
						output <= "1110111";
					end if;
				when "0011" =>
					if north_south = '1' then
						output <= "1111101";
					else
						output <= "1110111";
					end if;
				when "0100" =>
					if north_south = '1' then
						output <= "0111111";
					else
						output <= "1110111";
					end if;
				when "0101" =>
					if north_south = '1' then
						output <= "1111110";
					else
						output <= "1110111";
					end if;
				when "0110" =>
					output <= "1110111";
				when "0111" =>
					if north_south = '1' then
						output <= "1110111";
					else
						output <= "1111011";
					end if;
				when "1000" =>
					if north_south = '1' then
						output <= "1110111";
					else
						output <= "1111101";
					end if;
				when "1001" =>
					if north_south = '1' then
						output <= "1110111";
					else
						output <= "0111111";
					end if;
				when "1010" =>
					if north_south = '1' then
						output <= "1110111";
					else
						output <= "1111110";
					end if;
				when "1011" =>
					if north_south = '1' then
						output <= "1110111";	
					else
						output <= "1111110";
					end if;
				when "1100" =>
					output <= "1111111";
				when others =>
						output <= "1110111";
			end case;
		end process;
end logic;
