LIBRARY ieee;
use ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

entity seven_segment_cntrl IS
	port (
		input : IN STD_LOGIC_VECTOR (3 downto 0);
		output : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
			
end entity seven_segment_cntrl;

architecture logic of seven_segment_cntrl is
begin
	process (input) is
	begin
		case input is
			when "0000" =>
				output <= "1000000";
			when "0001" =>
				output <= "1111001";
			when "0010" =>
				output <= "0100100";
			when "0011" =>
				output <= "0110000";
			when "0100" =>
				output <= "0011001";
			when "0101" =>
				output <= "0010010";
			when "0110" =>
				output <= "0000010";
			when "0111" =>
				output <= "1111000";
			when "1000" =>
				output <= "0000000";
			when "1001" =>
				output <= "0010000";
			when "1010" =>
				output <= "0001000";
			when "1011" =>
				output <= "0000011";
			when "1100" =>
				output <= "1000110";
			when "1101" =>
				output <= "0100001";
			when "1110" =>
				output <= "0000110";
			when "1111" =>
				output <= "0001110";
			when others =>
				output <= "1111111";
		end case;
	end process;
end logic;