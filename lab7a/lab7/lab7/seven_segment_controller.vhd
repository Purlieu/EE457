LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity seven_segment_controller is
port (
	input : in integer;
	light_out : out std_logic_vector(6 downto 0)
);
end entity seven_segment_controller;

architecture logic of seven_segment_controller is

begin
	
	process(input) is
		begin
			case input is
			when 0 =>
				light_out <= "1000000";
			when 1 =>
				light_out <= "1111001";
			when 2 =>
				light_out <= "0100100";
			when 3 =>
				light_out <= "0110000";
			when 4 =>
				light_out <= "0011001";
			when 5 =>
				light_out <= "0010010";
			when 6 =>
				light_out <= "0000010";
			when 7 => 
				light_out <= "1110000";
				light_out <= "1111000";
			when 8 =>
				light_out <= "0000000";
			when 9 =>
				light_out <= "0010000";
			when others =>
				light_out <= "1111111";
		end case;
		end process;
end logic;