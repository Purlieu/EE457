LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

entity delay_controller is
	port (
		clk : in std_logic;
		start : in std_logic;
		stop : in std_logic;
		count : in std_logic;
		LED_out : out std_logic;
		start_out : out std_logic
		);
end entity delay_controller;

architecture logic of delay_controller is
	signal start_wait : std_logic;
begin
	process(clk)
	begin
	start_wait <= start;
	if rising_edge(clk) then
		if count = '1' then
			if start_wait = '1' then
				start_out <= '1';
			else
				start_out <= '0';
			end if;
		end if;
	end if;
	end process;

end logic;