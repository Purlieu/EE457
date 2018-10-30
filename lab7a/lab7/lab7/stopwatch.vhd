LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

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
	reset_out : out std_logic;
	LED_out : out std_logic
	);
end entity stopwatch;
	
architecture logic of stopwatch is

type state_type is (idle, delay, running, stopped);
		
	signal current_state: state_type := idle;
	signal next_state: state_type := running;
	
	signal is_running : std_logic_vector(1 downto 0);
	signal delay_completed : std_logic;
	
	signal hundredths : integer := 0;
	signal tenths : integer := 0;
	signal seconds : integer := 0;
	signal tens : integer := 0;
	
begin
	process(clk, start, is_running)
	begin
		if(clk'event and clk = '1') and is_running = "01" then
		if count = '1' then
			delay_completed <= '0';
				if seconds = 1 then 
					hundredths <= 0;
					tenths <= 0;
					seconds <= 0;
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
			end if;
		elsif(clk'event and clk = '1') and is_running = "10" then
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
		hundreds_out <= hundredths;
		tenths_out <= tenths;
		seconds_out <= seconds;
		ten_seconds_out <= tens;
		current_state <= next_state;
		end if;
		elsif(clk'event and clk = '1') then
		if count = '1' then
			current_state <= next_state;
		end if;
	end if;
	end process;
	
	process(current_state, start, delay_completed, stop)
	begin
		is_running <= "00";
		case current_state is
			when idle =>
				if start = '1' then 
					next_state <= delay;
				else
					next_state <= idle;
				end if;
			when delay =>
				is_running <= "01";
				if delay_completed = '1' then
					next_state <= running;
				else
					next_state <= delay;
				end if;
			when running =>
			is_running <= "10";
				if stop = '1' then
					next_state <= stopped;
				else
					next_state <= running;
				end if;
			when others =>
				is_running <= "11";
				next_state <= stopped;
			end case;
		end process;
end logic;
