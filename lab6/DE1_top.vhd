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

-- signal and component declartions
-- you will need to create the component declaration for the 7 segment control.
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

component traffic_control 
	port (
		clk, reset_a, weight, night, north_south: IN STD_LOGIC;
		count : in std_logic_vector(3 downto 0); -- 1 if we've reached a second interval
		
		-- Declare output control signals "in_sel", "shift_sel", "state_out", "done", "clk_ena" and "sclr_n"
		state_out : OUT std_logic_vector(3 DOWNTO 0);
		reset_out : out std_logic
	);
end component traffic_control;

component traffic_segment_cntrl
	port (
		north_south : in std_logic;
		input :  in std_logic_vector(3 downto 0);
		output : out std_logic_vector(6 downto 0)
	);
end component traffic_segment_cntrl;

	signal input_state : std_logic_vector(3 downto 0);
	signal north_south : std_logic;
	signal out_state : UNSIGNED(3 DOWNTO 0);
	signal n_key0 : std_logic;
	signal count : std_logic_Vector(3 downto 0);
	signal reset : std_logic;
	
begin
	n_key0 <= KEY(0);
	north_south <= '1';
-- processes, component instantiations, general logic.
	u1: gen_counter
		generic map (wide => 4, max => 50000000)
		PORT MAP (
			clk => clock_50,
			load => '0',
			data => (others => '0'),
			reset => reset,
			enable => '1',
			count => count
		);
	
	u2: traffic_segment_cntrl port map (
		north_south => '1',
		input  => input_state(3 downto 0),
		output => HEX0 (6 downto 0)
	);
	
	u3: traffic_segment_cntrl port map (
		north_south => '1',
		input  => input_state(3 downto 0),
		output => HEX1 (6 downto 0)
	);
	
	u4: traffic_segment_cntrl port map (
		north_south => '0',
		input  => input_state(3 downto 0),
		output => HEX2 (6 downto 0)
	);
	
	u5: traffic_segment_cntrl port map (
		north_south => '0',
		input  => input_state(3 downto 0),
		output => HEX3 (6 downto 0)
	);
	
	u6: traffic_control port map (
		clk => clock_50,
		reset_a => n_key0,
		weight => SW(0),
		night => SW(1),
		north_south => north_south,
		count => count(3 downto 0),
		state_out => input_state,
		reset_out => reset
	);
	
end;








