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
	HEX0		:out	std_logic_vector( 6 downto 0) := "1000000"; -- right most
	HEX1		:out	std_logic_vector( 6 downto 0) := "1000000";	
	HEX2		:out	std_logic_vector( 6 downto 0) := "1000000";	
	HEX3		:out	std_logic_vector( 6 downto 0) := "1000000";	
	HEX4		:out	std_logic_vector( 6 downto 0) := "1111111";	
	HEX5		:out	std_logic_vector( 6 downto 0) := "1111111"; -- left most
   
	-- Red LEDs above Slider switches
	-- driving the LEDR signal logically high will light up the Red LED
	-- driving the LEDR signal logicall low will turn off the Red LED 
   LEDR		:out	std_logic_vector( 9 downto 0) := "0000000000";	

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

COMPONENT gen_counter
		generic (
			wide : positive; -- how many bits is the counter
			max  : positive  -- what is the max value of the counter ( modulus )
			);

		PORT (
			clk	 :in  std_logic; -- system clock
			data	 :in  std_logic_vector( wide-1 downto 0 ); -- data in for parallel load, use unsigned(data) to cast to unsigned
			load	 :in  std_logic; -- signal to load data into i_count i_count <= unsigned(data);
			enable :in  std_logic; -- clock enable
			reset	 :in  std_logic; -- reset to zeros use i_count <= (others => '0' ) since size depends on generic
			count	 :out std_logic_vector( wide-1 downto 0 ); -- count out
			term	 :out std_logic -- maximum count is reached
		);
	END COMPONENT gen_counter;

component seconds_controller 
	port (
		clk : in std_logic;
		start : in std_logic;
		stop : in std_logic;
		reset : out std_logic;
		count : in std_logic;
		count_out : out integer
		);
end component seconds_controller;

component seven_segment_controller is
port (
	input : in integer;
	light_out : out std_logic_vector(6 downto 0)
);

end component seven_segment_controller;


	SIGNAL stop_n : STD_LOGIC;
	SIGNAL start_n : STD_LOGIC;
	
	SIGNAL count_reset : STD_LOGIC;
	SIGNAL count_10s_reset : STD_LOGIC;
	SIGNAL count_tenths_reset : STD_LOGIC;
	SIGNAL count_hundredths_reset : STD_LOGIC;

	signal ten_seconds : std_logic;
	signal seconds : std_logic;
	signal tenths : std_logic;
	signal hundredths : std_logic;
	
	signal count_out : integer;
	signal count_10s_out : integer;
	signal count_tenths_out : integer;
	signal count_hundredths_out : integer;

	
begin
	start_n <= not KEY(0);
	stop_n <= not KEY(1);
	-- Ten Seconds
	u1: gen_counter
	generic map (wide => 29, max => 500000000)
	PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => count_10s_reset,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => ten_seconds
		);
		
	-- Seconds
	u2: gen_counter
	generic map (wide => 26, max => 50000000)
	PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => count_reset,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => seconds
		);
	
	--Tenths of Second
	u3: gen_counter
	generic map (wide => 23, max => 5000000)
	PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => count_tenths_reset,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => tenths
		);
	
	--Hundredths of Second
	u4: gen_counter
	generic map (wide => 19, max => 500000)
	PORT MAP (
			clk => clock_50,
			-- We never load it
			load => '0',
			data => (others => '0'),
			-- reset is key0 notted
			reset => count_hundredths_reset,
			-- Always enabled
			enable => '1',
			-- Once term (max) is hit we have a second
			term => hundredths
		);
		
	u6: seconds_controller
	port map(
		clk => clock_50,
		start => start_n,
		stop => stop_n,
		count => ten_seconds,
		reset => count_10s_reset,
		count_out => count_10s_out
		);
	
	u7: seconds_controller
	port map(
		clk => clock_50,
		start => start_n,
		stop => stop_n,
		count => seconds,
		reset => count_reset,
		count_out => count_out
		);
		
	u8: seconds_controller
	port map(
		clk => clock_50,
		start => start_n,
		stop => stop_n,
		count => tenths,
		reset => count_tenths_reset,
		count_out => count_tenths_out
		);
	u9: seconds_controller
	port map(
		clk => clock_50,
		start => start_n,
		stop => stop_n,
		count => hundredths,
		reset => count_hundredths_reset,
		count_out => count_hundredths_out
		);
	u10:seven_segment_controller
	port map(
		input => count_hundredths_out,
		light_out => HEX0
		);
	u11:seven_segment_controller
	port map(
		input => count_tenths_out,
		light_out => HEX1
		);
	u12:seven_segment_controller
	port map(
		input => count_out,
		light_out => HEX2
		);
	u13:seven_segment_controller
	port map(
		input => count_10s_out,
		light_out => HEX3
		);

end;








