LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity DE1_top is

Port(

	-- 50Mhz clock, i.e. 50 Million rising edges per second
   clock_50 :in  std_logic; 
   -- 7 Segment Display
	-- driving the the individual bit loicall low will
	-- light up the segment.
	HEX0		:out	std_logic_vector( 6 downto 0); -- right most
	HEX1		:out	std_logic_vector( 6 downto 0);	
	HEX2		:out	std_logic_vector( 6 downto 0);	
	HEX3		:out	std_logic_vector( 6 downto 0);	
	HEX4		:out	std_logic_vector( 6 downto 0);	
	HEX5		:out	std_logic_vector( 6 downto 0); -- left most
   
	-- Red LEDs above Slider switches
	-- driving the LEDR signal logically high will light up the Red LED
	-- driving the LEDR signal logicall low will turn off the Red LED 
   LEDR		:out	std_logic_vector( 9 downto 0);	

	-- Push Button
	-- the KEY input is normally high, pressing the KEY
	-- will drive the input low.
	
	KEY		:in   std_logic_vector( 3 downto 0);  
   -- Slider Switch
	-- when the Slider switch is pushed up, away from the board edge
	-- the input signal is logically high, when pushed towards the
	-- board edge, the signal is loically low.
	SW			:in	std_logic_vector( 9 downto 0 ) 
    
);

end DE1_top;

architecture struct of DE1_top is


component gen_counter is
-- we are using the generic construct to allow this counter to be generic.
generic (
		wide : positive; -- how many bits is the counter
		max  : positive  -- what is the max value of the counter ( modulus )
		);
port (
		clk	 :in  std_logic; -- system clock
		data	 :in  std_logic_vector( wide-1 downto 0 ); -- data in for parallel load, use unsigned(data) to cast to unsigned
		load	 :in  std_logic; -- signal to load data into i_count i_count <= unsigned(data);
		enable :in  std_logic; -- clock enable
		reset	 :in  std_logic; -- reset to zeros use i_count <= (others => '0' ) since size depends on generic
		count	 :out std_logic_vector( wide-1 downto 0 ); -- count out
		term	 :out std_logic -- maximum count is reached
		);
end component gen_counter;

component seven_segment_controller is
port (
	input : in integer;
	light_out : out std_logic_vector(6 downto 0)
);
end component seven_segment_controller;
-- signal and component declartions
-- you will need to create the component declaration for the 7 segment control.
component stopwatch is
port(
	clk : in std_logic;
	count : in std_logic;
	start : in std_logic;
	stop : in std_logic;
	hundreds_out : out integer;
	tenths_out : out integer ;
	seconds_out : out integer;
	ten_seconds_out : out integer;
	reset_out : out std_logic;
	total_in : in integer;
	total_out : out integer;
	LED_out : out std_logic
	);
end component stopwatch;

	constant timer : integer := 500000000;
	constant hundredths : integer := timer / 1000;
	signal reset : std_logic;
	signal hundredths_count : std_logic;
	signal start_n : std_logic;
	signal stop_n : std_logic;
	
	signal hundreds: integer ;
	signal tenths : integer ;
	signal seconds : integer ;
	signal ten_seconds : integer ;
	signal total : integer;
		
begin
start_n <= not KEY(0);
stop_n <= not KEY(1);
HEX4 <= "1111111";
HEX5 <= "1111111";
	u1:gen_counter
	generic map (wide => 29, max => hundredths)
	port map(
		clk => clock_50,
		load => '0',
		data => (others => '0'),
		reset => reset,
		enable => '1',
		term => hundredths_count
	);
	
	u2:stopwatch
	port map(
		clk => clock_50,
		count => hundredths_count,
		start => start_n,
		stop => stop_n,
		hundreds_out => hundreds,
		tenths_out => tenths,
		seconds_out => seconds,
		ten_seconds_out => ten_seconds,
		total_in => total,
		total_out => total,
		reset_out => reset,
		LED_out => LEDR(0)	
	);
	u3:seven_segment_controller 
	port map(
		input => hundreds,
		light_out => HEX0
	);
	u4:seven_segment_controller 
	port map(
		input => tenths,
		light_out => HEX1
	);
	u5:seven_segment_controller 
	port map(
		input => seconds,
		light_out => HEX2
	);
	u6:seven_segment_controller 
	port map(
		input => ten_seconds,
		light_out => HEX3
	);
-- processes, component instantiations, general logic.



end;








