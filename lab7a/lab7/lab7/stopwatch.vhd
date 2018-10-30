LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use ieee.math_real.all;

entity stopwatch is
port(
	clk : in std_logic;
	count : in std_logic;
	start : in std_logic;
	stop : in std_logic;
	hundreds_out : out integer := 0;
	tenths_out : out integer := 0;
	seconds_out : out integer := 0;
	ten_seconds_out : out integer := 0;
	total_in : in integer;
	total_out : out integer;
	reset_out : out std_logic;
	LED_out : out std_logic
	);
end entity stopwatch;
	
architecture logic of stopwatch is

type state_type is (idle, delay, running, stopped, reflex, reset, results, fail);
		
	signal current_state: state_type := idle;
	signal next_state: state_type := running;
		
	signal is_running : std_logic_vector(2 downto 0);
	signal delay_completed : std_logic;
	signal result_completed : std_logic := '0';
	signal hundredths : integer := 0;
	signal tenths : integer := 0;
	signal seconds : integer := 0;
	signal tens : integer := 0;
	
	signal hundredths_reflex : integer := 0;
	signal tenths_reflex : integer := 0;
	signal seconds_reflex : integer := 0;
	signal tens_reflex : integer := 0;
	
	
	signal holdval : integer := 0;
	signal total : integer := 0;
	signal attempt : integer := 0;
		
begin
	process(clk, start, is_running)
	begin
	total <= total;
	if(clk'event and clk = '1') and is_running = "001" then
	if count = '1' then
			delay_completed <= '0';
			if seconds = 1 then 
				hundredths <= 0;
				tenths <= 0;
				seconds <= 0;
				tens <= 0;
				delay_completed <= '1';
			elsif seconds < 1 then
				hundredths <= hundredths + 1;
				if hundredths = 9 then
					hundredths <= 0;
					tenths <= tenths + 1;
					if tenths = 9 then
						tenths <= 0;
						seconds <= seconds + 1;
					end if;
				end if;
			end if;
			current_state <= next_state;
		end if;
	elsif(clk'event and clk = '1') and is_running = "100" then
	if count = '1' then
		total <= ((hundredths + (tenths * 10) + (seconds * 100) + (tens * 1000)));
		hundredths <= 0;
		tenths <= 0;
		seconds <= 0;
		tens <= 0;
		current_state <= next_state;
		if result_completed = '0' then
			attempt <= attempt + 1;
		end if;
	end if;
	elsif(clk'event and clk = '1') and is_running = "010" then
	if count = '1' then
			hundredths <= hundredths + 1;
			if hundredths = 9 then
				hundredths <= 0;
				tenths <= tenths + 1;
				if tenths = 9 then
					tenths <= 0;
					seconds <= seconds + 1;
						if seconds = 9 then
							seconds <= 0;
							tens <= tens + 1;
							if tens = 9 then
								tens <= 0;
							end if;
						end if;
					end if;
				end if;
		current_state <= next_state;
	end if;
	elsif(clk'event and clk = '1') and is_running = "101" then
	if count = '1' then
			holdval <= holdval + 1;
			if holdval >= total then
				result_completed <= '1';
			else
				result_completed <= '0';
			end if;
			hundredths <= hundredths + 1;
			if hundredths = 9 then
				hundredths <= 0;
				tenths <= tenths + 1;
				if tenths = 9 then
					tenths <= 0;
					seconds <= seconds + 1;
						if seconds = 9 then
							seconds <= 0;
							tens <= tens + 1;
							if tens = 9 then
								tens <= 0;
							end if;
						end if;
					end if;
				end if;
		current_state <= next_state;
	end if;
	elsif(clk'event and clk = '1') then
	if count = '1' then
			current_state <= next_state;
	end if;
	end if;
	end process;
	
	process(current_state, start, delay_completed, result_completed, stop, tens, hundredths, tenths, seconds)
	begin
		is_running <= "000";
		LED_out <= '0';
		hundreds_out <= 0;
		tenths_out <= 0;
		seconds_out <= 0;
		ten_seconds_out <= 0;
		case current_state is
			when idle =>
				if start = '1' then 
					next_state <= delay;
				else
					next_state <= idle;
				end if;
			when delay =>
				is_running <= "001";
				if delay_completed = '1' then
					next_state <= running;
				else
					next_state <= delay;
				end if;
			when running =>
			LED_out <= '1';
			is_running <= "010";
				if stop = '1' then
					next_state <= stopped;
				else
					next_state <= running;
				end if;
			when stopped =>
				is_running <= "011";
				hundreds_out <= hundredths;
				tenths_out <= tenths;
				seconds_out <= seconds;
				ten_seconds_out <= tens;
				if start = '1' then
					next_state <= reset;
				else
					next_state <= stopped;
				end if;
			when reset =>
				is_running <= "100";
				next_state <= reflex;
			when reflex =>
				is_running <= "101";
				hundreds_out <= hundredths;
				tenths_out <= tenths;
				seconds_out <= seconds;
				ten_seconds_out <= tens;
				if result_completed = '1' then
					LED_out <= '1';
				end if;
				if stop = '1' then
					next_state <= results;
				else
					next_state <= reflex;
				end if;
			when fail =>
					is_running <= "111";
					next_state <= fail;
			when others =>
				hundreds_out <= hundredths;
				tenths_out <= tenths;
				seconds_out <= seconds;
				ten_seconds_out <= tens;
				is_running <= "110";
				next_state <= results;
			end case;
		end process;
end logic;
