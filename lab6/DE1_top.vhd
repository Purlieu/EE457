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
	
	-- Disable HEX4 and HEX5 as we only need 4 lights for represent traffic lights
	--HEX4		:out	std_logic_vector( 6 downto 0);
	--HEX5		:out	std_logic_vector( 6 downto 0); -- left most
	
	
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
		-- **clk**
		--		+ Based on a 50Mhz clock 
		--		+ One second will equal one "term" based on gen_counter
		clk: in std_logic;
		
		-- **reset_a**
		--		+ Used to determine if our state will reset to "night_check" in which
		--		  all lights are set to red
		--		+ KEY(0) is the input to determine if we reset or not
		--		  when KEY(0) is low we run, when KEY(0) is high we reset the state
		reset_a: in std_logic;
		
		-- **weight_NS**
		--		+ Input comes from SW(0) and determines North South turn signals
		--		+ When SW(0) runs high, we mimic that a car is waiting to turn
		--		  at the light, and simulate a left turn arrow
		--		+ When SW(0) runs low, we have no car waiting to turn, so states
		--		  run without a turn arrow
		weight_NS: in std_logic;
		
		-- **weight_EW**
		--		+ Input comes from SW(1) and determines East West turn signals
		--		+ When SW(0) runs high, we mimic that a car is waiting to turn
		--		  at the light, and simulate a left turn arrow
		--		+ When SW(0) runs low, we have no car waiting to turn, so states
		--		  run without a turn arrow
		weight_EW: in std_logic;

		-- **night**
		--		+ Input comes from SW(2) and determines if night mode is activated
		--		+ When SW(0) runs high, night mode is active
		--		+ When SW(0) runs low, night mode is deactivated
		--		+ Will trump SW(0) and SW(1) as once night_mode state is reached
		--		  weight checking won't occur until night mode is deactivated
		night: in std_logic;

		-- **north_south**
		--		+ std_logic of North and South segments receiving inputs of 1
		--		  and East and West segments receiving inputs of 0
		--		+ Used to determine cardinal directions of lights
		north_south: in std_logic;

		count : in std_logic; 
		-- **count**
		--		+ std_logic where '1' is equivalent to 1 second when the clk reaches
		--		  50Mhz
		--		+ Used to determine if a second has passed
		
		-- Declare output control signals "state_out"
		
		-- *state_out**
		--		+ Given the current inputs, state_out will change to determine what the
		--		  current state is to pass the information to the segment controller	
		state_out : OUT std_logic_vector(3 DOWNTO 0)
		);
end component traffic_control;

component traffic_segment_cntrl
	port (
		-- **north_south**
		--		+ Used to determine if a set of lights will face cardinal directions
		--		  North and South or East and West
		-- 	+ North HEX(0), South HEX(1), East HEX(2), West HEX(3)
		north_south : in std_logic;
		
		-- **input**
		--		+ Will determine what the current state is based on output 
		--      from traffic_cntrl
		input :  in std_logic_vector(3 downto 0);
		
		-- Declare output "output" for seven segment display
		
		-- **output**
		--		+ Used to determine which light segments to turn on or off
		--	     in the seven segment lights
		output : out std_logic_vector(6 downto 0)
	);
end component traffic_segment_cntrl;

	-- State from traffic control to segment control
	signal input_state : std_logic_vector(3 downto 0);
	-- Determines which segments of light to use
	signal north_south : std_logic;
	-- Set to not KEY(0) so button doesn't have to be held down to run
	signal n_key0 : std_logic;
	-- Signal to determine when a single second has passed
	signal one_second : std_logic;
	
begin
-- processes, component instantiations, general logic.
-- Set "n_KEY0 to not KEY(0) to indicate when the button is pressed, we want to reset the state
	n_KEY0 <= not KEY(0);
	u1: gen_counter
		--Clock is 26 bits wide, and is based on 50Mhz cycle
		generic map (wide => 26, max => 50000000)
		PORT MAP (
			-- Set "clk" of counter to 50Mhz clock
			clk => clock_50,
			-- Load is 0, so we have no data that we are loading
			load => '0',
			data => (others => '0'),
			-- Set reset to not KEY(0) or n_KEY0
			reset => n_KEY0,
			-- Clock is always enabled
			enable => '1',
			-- Term set to one second, or one clock cycle of 50Mhz
			term => one_second
		);
	
	u2: traffic_segment_cntrl port map (
	-- HEX0 is North and South, default start state is night_check or "0000", need 4 bits to represent state
		north_south => '1',
		input  => input_state(3 downto 0),
		output => HEX0 (6 downto 0)
	);
	
	u3: traffic_segment_cntrl port map (
	-- HEX1 is North and South, default start state is night_check or "0000", need 4 bits to represent state
		north_south => '1',
		input  => input_state(3 downto 0),
		output => HEX1 (6 downto 0)
	);
	
	u4: traffic_segment_cntrl port map (
	-- HEX2 is East and West, default start state is night_check or "0000", need 4 bits to represent state
		north_south => '0',
		input  => input_state(3 downto 0),
		output => HEX2 (6 downto 0)
	);
	
	u5: traffic_segment_cntrl port map (
	-- HEX3 is East and West, default start state is night_check or "0000", need 4 bits to represent state
		north_south => '0',
		input  => input_state(3 downto 0),
		output => HEX3 (6 downto 0)
	);
	
	u6: traffic_control port map (
		-- Set "clk" of counter to 50Mhz clock
		clk => clock_50,
		-- Set reset to not KEY(0) or n_KEY0
		reset_a => n_KEY0,
		-- Set switch to determine car weight of North-South
		weight_NS => SW(0),
		-- Set switch to determine car weight of East-West
		weight_EW => SW(1),
		-- Set switch to determine night-mode
		night => SW(2),
		north_south => north_south,
		-- Pass counter for one second
		count => one_second,
		-- State goign from controller to segments
		state_out => input_state
		);
end;








