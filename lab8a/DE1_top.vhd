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

-- signal and component declartions
-- you will need to create the component declaration for the 7 segment control.


component ram32x4 is
	port
	(
		address: in std_logic_vector(4 downto 0);
		clock: in std_logic  := '1';
		data: in std_logic_vector(3 downto 0);
		wren: in std_logic ;
		q: out STD_LOGIC_VECTOR (3 downto 0)
	);
end component ram32x4;

component seven_segment_cntrl IS
	port (
		input : IN STD_LOGIC_VECTOR (3 downto 0);
		output : OUT STD_LOGIC_VECTOR(6 downto 0)
		);
			
end component seven_segment_cntrl;
	signal q_data: std_logic_vector(3 downto 0);
	signal address : std_logic_vector(4 downto 0);
	signal data : std_logic_vector(3 downto 0);
begin
	HEX1 <= "1111111";
	HEX3 <= "1111111";
	data <= SW(3 downto 0);
	address <= SW(8 downto 4);
	u1 : ram32x4
	port map(
		address => address,
		clock => KEY(0),
		data => data,
		wren => SW(9),
		q => q_data
		);
	u2 : seven_segment_cntrl
	port map
	(
		input => q_data,
		output => HEX0
	);
	u3 : seven_segment_cntrl
	port map
	(
		input => datax,
		output => HEX2	
	);
	u4 : seven_segment_cntrl
	port map
	(
		input => address(3 downto 0),
		output => HEX4
	);
	u5 : seven_segment_cntrl
	port map
	(
		input => "000" & address(4),
		output => HEX5
	);
-- processes, component instantiations, general logic.



end;








