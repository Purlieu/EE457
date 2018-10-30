LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

entity tens_controller is
	port (
		clk : in std_logic;
		start, stop : in std_logic;
		count : in std_logic;
		reset : out std_logic;
		count_out : out integer
		);
end entity tens_controller;

architecture logic of tens_controller is
	type state_type is (idle, running, stopped);
		
	signal current_state: state_type := idle;
	signal next_state: state_type := running;
	signal counter : integer := 0;

	SIGNAL is_running : std_logic := '0';
	
begin

	process(current_state, clk, count, is_running)
	begin
		if rising_edge(clk) then
			reset <= '0';
			if count = '1' then
				if is_running = '1' then
					if(counter = 9) then
						counter <= 0;
						reset <= '1';
					else
						counter <= counter + 1;
					end if;
				end if;
			current_state <= next_state;
			end if;
			count_out <= counter;
		end if;
	end process;
	
	process(current_state, start, stop)
	begin
		is_running <= '0';
		case current_state is
			when idle =>
				if start = '1' then
					next_state <= running;
				else
					next_state <= current_state;
				end if;
			when running =>
				is_running <= '1';
				if stop = '1' then
					next_state <= stopped;
				else
					next_state <= current_state;
				end if;
			when others =>
				next_state <= idle;
			end case;
		end process;
end logic;