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
					output <= "0001000";
				when "0001" =>
					output <= "0001000";
				when "0010" =>
					if north_south = '1' then
						output <= "0000100";
					else
						output <= "0001000";
					end if;
				when "0011" =>
					if north_south = '1' then
						output <= "0000010";
					else
						output <= "0001000";
					end if;
				when "0100" =>
					if north_south = '1' then
						output <= "1000000";
					else
						output <= "0001000";
					end if;
				when "0101" =>
					if north_south = '1' then
						output <= "0000001";
					else
						output <= "0001000";
					end if;
				when "0110" =>
					if north_south = '0' then
						output <= "0000100";
					else
						output <= "0001000";
					end if;
				when "0111" =>
					if north_south = '0' then
						output <= "0000010";
					else
						output <= "0001000";
					end if;
				when "1000" =>
					if north_south = '0' then
						output <= "1000000";
					else
						output <= "0001000";
					end if;
				when "1001" =>
					if north_south = '0' then
						output <= "0000001";
					else
						output <= "0001000";
					end if;
				when "1010" =>
					if north_South = '1' then
						output <= "0001000";
					else
						output <= "0000001";
					end if;
				when others =>
						output <= "0000000";
			end case;
		end process;
end logic;
