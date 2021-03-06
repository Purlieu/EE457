LIBRARY ieee;
USE ieee.NUMERIC_STD.all;
use ieee.STD_LOGIC_1164.all;

entity state_controller is
	port(
		clk: in std_logic;
		start : in std_logic;
		stop : in std_logic;
		count : in std_logic;
		running_out : out std_logic
		);
end entity state_controller;

architecture logic of state_controller is
	type state_type is (idle, running, stopped);
		
	signal current_state: state_type := idle;
	signal next_state: state_type := running;
	signal is_running : std_logic;
begin
	process(clk, current_state, is_running)
	begin
		if rising_edge(clk) then
			if count = '1' then 
				current_state <= next_state;
				if is_running = '1' then
					running_out <= '1';
				else
					running_out <= '0';
				end if;
			end if;
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