	LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity de1_top_lab6_tb is
end entity;

architecture behav of de1_top_lab6_tb is

component de1_top is
generic (
		simulation_wide :positive; -- how many bits is the counter
		simulation_max  :positive  -- what is the max count
		);
port (
   -- 7 Segment Display
   CLOCK_50 :in std_logic;
	HEX0		:out	std_logic_vector( 6 downto 0); -- right most
	HEX1		:out	std_logic_vector( 6 downto 0);	
	HEX2		:out	std_logic_vector( 6 downto 0);	
	HEX3		:out	std_logic_vector( 6 downto 0);		
	HEX4		:out	std_logic_vector( 6 downto 0);		
	HEX5		:out	std_logic_vector( 6 downto 0);		
	LEDR		:out	std_logic_vector( 9 downto 0);	
	-- Push Button
	KEY		    :in     std_logic_vector( 3 downto 0);  
   -- Slider Switch
	SW			:in	    std_logic_vector( 9 downto 0 ) 
		);
end component;

	
constant CLK_PER:time := 1 ns;
constant clk_cycle:time := 4*clk_per;
	
signal aclr_n : std_logic;
signal clk    : std_logic;
signal sw     : std_logic_vector(9 downto 0);
signal key    : std_logic_vector(3 downto 0);
signal hex0	  : std_logic_vector(6 downto 0); -- right most
signal hex1	  :	std_logic_vector(6 downto 0);	
signal hex2	  :	std_logic_vector(6 downto 0);	
signal hex3	  :	std_logic_vector(6 downto 0);	

begin
	
	
	clock:process begin  -- this process just continues to run as the simulation time continues
		 clk <= '0';
		 wait for CLK_PER;
		 clk <= '1';
		 wait for CLK_PER;
		 end process;
		
	
	
	vectors:process begin -- put you test vectors here, remember to advance the simulation in modelsim
		key <= "1110";
		sw     <= "0000000000"; -- drive all the switch inputs to a 0
		wait for 5 ns; -- wait for a fraction of the clock so stimulus is not occuring on clock edges
		key <= "1110";
		sw <= "0000000000"; -- No-Night-Mode / No Weight

		wait for 8*clk_cycle;
		
		key <= "1111";
		sw <= "0000000000"; -- No-Night-Mode / No Weight

		wait for 8*clk_cycle;
		sw <= "0000000001"; -- No-Night / Weighted NS

		wait for 8*clk_cycle;
		sw <= "0000000010"; -- Night / Weighted EW
		wait for 8*clk_cycle;
		sw <= "0000000011"; -- No-Night / Weighted EW / Weighted NS
		wait for 8*clk_cycle;
		sw <= "0000000100"; -- Night / No Weight
		wait for 8*clk_cycle;
		sw <= "0000000101"; -- Night / Weight NS
		wait for 8*clk_cycle;
		sw <= "0000000110"; -- Night / Weight EW
		wait for 8*clk_cycle;
		sw <= "0000000111"; -- Night / Weight EW / Weight NS
		wait for 8*clk_cycle;
		
		end process;
		

-- instantiate the device under test (dut)
dut :de1_top
generic map (
		simulation_wide => 26, 
		simulation_max  => 50000000 
		)
port map (
	CLOCK_50 => clk,
   -- 7 Segment Display
	HEX0 => hex0,--		:out	std_logic_vector( 6 downto 0); -- right most
	HEX1 => hex1,--		:out	std_logic_vector( 6 downto 0);	
	HEX2 => hex2,-- 	:out	std_logic_vector( 6 downto 0);	
	HEX3 => hex3,--     :out	std_logic_vector( 6 downto 0);	
	-- Push Button
	KEY	 => key, --	    :in     std_logic_vector( 3 downto 0);  
   -- Slider Switch
    SW   => sw--		:in	std_logic_vector( 9 downto 0 ) 
		);	
end architecture;
		