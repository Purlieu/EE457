LIBRARY ieee ;
USE ieee.std_logic_1164.all ; 

entity flipflop is
	port(
		clk : in std_logic;
		reset : in std_logic;
		q : out std_logic
		);
end entity flipflop;

architecture logic of flipflop is
	signal t: std_logic;

begin
	process(clk, t)
	begin
	if reset = '1' then
		t <= '0';
	elsif(clk'event and clk = '1') then 
		t <= not t;
	end if;
	end process;
q <= t;
end architecture;