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

component ram32x4 is
port
(
	clock: in std_logic:= '1';
	data: in std_logic_vector(3 DOWNTO 0);
	rdaddress: in std_logic_vector(4 DOWNTO 0);
	wraddress: in std_logic_vector(4 DOWNTO 0);
	wren: in std_logic := '0';
	q: out std_logic_vector(3 DOWNTO 0)
);
end component ram32x4;

component seven_segment_cntrl IS
	port (
		input : in std_logic_vector(3 downto 0);
		output : out std_logic_vector(6 downto 0)
		);
			
end component seven_segment_cntrl;

component gen_counter
	generic 
	(
		wide : positive; -- how many bits is the counter
		max  : positive  -- what is the max value of the counter ( modulus )
	);

	port(
		clk:in  std_logic; -- system clock
		data:in  std_logic_vector( wide-1 downto 0 ); -- data in for parallel load, use unsigned(data) to cast to unsigned
		load:in  std_logic; -- signal to load data into i_count i_count <= unsigned(data);
		enable:in  std_logic; -- clock enable
		reset:in  std_logic; -- reset to zeros use i_count <= (others => '0' ) since size depends on generic
		count:out std_logic_vector( wide-1 downto 0 ); -- count out
		term:out std_logic -- maximum count is reached
	);
end component gen_counter;

component double_d_ff is
	port(
		input : std_logic_vector(9 downto 0);
		clock : std_logic;
		reset : std_logic;
		output : out std_logic_vector(9 downto 0)
	);
end component double_d_ff;

-- signal and component declartions
-- you will need to create the component declaration for the 7 segment control.

signal one_second : std_logic;
signal address_read : std_logic_vector(4 downto 0);
signal q_data : std_logic_vector(3 downto 0);
signal reset : std_logic;
signal address_one : std_logic_vector(3 downto 0);
signal address_two : std_logic_vector(3 downto 0);
signal address_three : std_logic_vector(3 downto 0);
signal ff_switches : std_logic_vector(9 downto 0);
signal data : std_logic_vector(3 downto 0);
signal write_address : std_logic_vector(4 downto 0);

begin
	address_one <= address_read(3 downto 0);
	address_two <=	"000" & address_read(4);
	address_three <= "000" & ff_switches(4);
	reset <= not KEY(0);
	data <= ff_switches(3 downto 0);
	write_address <= ff_switches(8 downto 4);
-- processes, component instantiations, general logic.

	u1 : gen_counter
	--generic map (wide => 26, max => 5)
	generic map (wide => 26, max => 50000000)
	port map(
		clk => clock_50,
		load => '0',
		data => (others => '0'),
		reset => reset,
		enable => '1',
		term => one_second
	);
	
	u2 : gen_counter
	generic map (wide => 5, max => 31)
	port map(
		clk => one_second,
		load => '0',
		data => (others => '0'),
		reset => reset,
		enable => '1',
		count => address_read
	);

	u3 : ram32x4
	port map(
		clock => clock_50,
		data => data,
		rdaddress => address_read,
		wraddress => write_address,
		wren => ff_switches(9),
		q => q_data
	);
		
	u4 : seven_segment_cntrl
	port map(
		input => q_data,
		output => HEX0
	);
	
	u5 : seven_segment_cntrl
	port map(
		input => data,
		output => HEX1
	);
	
	u6 : seven_segment_cntrl
	port map(
		input => address_one,
		output => HEX2
	);
	
	u7 : seven_segment_cntrl
	port map(
		input => address_two,
		output => HEX3
	);
	
	u8 : seven_segment_cntrl
	port map(
		input => write_address(3 downto 0),
		output => HEX4
	);
	
	u9 : seven_segment_cntrl
	port map(
		input => address_three,
		output => HEX5
	);
	
	u10 : double_d_ff
	port map(
		input => SW,
		clock => clock_50,
		reset => KEY(0),	 
		output => ff_switches
	);
		
end;








