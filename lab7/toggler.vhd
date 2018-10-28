LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
 
 
entity toggler is
port( 
	clk : in std_logic;
	start, stop : in std_logic;
   toggle, LED_out  : out std_logic
   );
end entity toggler;
 
 
architecture logic of toggler is 
	signal start_sig, stop_sig : std_logic;
begin
	process(clk, start_sig, stop_sig)
	begin
		if rising_edge(clk) then
			if start = '1' and stop = '0' then
				toggle <= '1';
				LED_out <= '1';
			else
				toggle <= '0';
				LED_out <= '0';
			end if;
		end if;
end process;
end logic;