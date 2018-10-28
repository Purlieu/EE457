LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity LED_controller is
port(
	input : in std_logic;
	output : out std_logic
	);
end entity LED_controller;

architecture logic of LED_controller is
	begin
		process(input)
		begin
			if input = '1' then
				output <= '0';
			else
				output <= '1';
			end if;
		end process;
	end logic;