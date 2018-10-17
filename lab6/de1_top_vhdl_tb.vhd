LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity de1_top_lab6_tb is
end entity;

architecture behav of de1_top_lab6_tb is

component de1_top is
port (
   -- 7 Segment Display
   CLOCK_50 :in std_logic;
	HEX0		:out	std_logic_vector( 6 downto 0); -- right most
	HEX1		:out	std_logic_vector( 6 downto 0);	
	HEX2		:out	std_logic_vector( 6 downto 0);	
	HEX3		:out	std_logic_vector( 6 downto 0);	
   -- Red LEDs above Slider switches
	-- Push Button
	KEY		    :in     std_logic_vector( 3 downto 0);  
   -- Slider Switch
	SW			:in	    std_logic_vector( 9 downto 0 ) 
		);
end component;

	
constant CLK_PER:time := 1 ns;
constant clk_cycle:time := clk_per;
	
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

		sw     <= "0000000000"; -- drive all the switch inputs to a 0
		 key  <=   "1110";                     -- default state on the board, and reset
		wait for 5 ns; -- wait for a fraction of the clock so stimulus is not occuring on clock edges
		
      key  <=   "1111";   -- no reset
		sw <= "0000000000"; -- No-Night-Mode / No Weight
		
		wait for clk_cycle;
		
		key <= "1111"; -- reset
		sw <= "0000000000"; -- No-Night-Mode / No Weight
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges

		wait for clk_cycle;
		
		key  <=   "1111";   -- no reset		
		sw <= "0000000001"; -- No-Night / Weighted NS
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges

		wait for clk_cycle;
		-- add more vectors to test everything
		
		key <= "1111"; -- no reset
		sw <= "0000000010"; -- Night / Weighted EW
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges
		wait for clk_cycle;

		key <= "1111"; -- no reset
		sw <= "0000000011"; -- No-Night / Weighted EW / Weighted NS
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges
		wait for clk_cycle;
		
		key <= "1111"; -- no reset
		sw <= "0000000100"; -- Night / No Weight
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges
		wait for clk_cycle;
		
		key <= "1111"; -- no reset
		sw <= "0000000101"; -- Night / Weight NS
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges
		wait for clk_cycle;
		
		key <= "1111"; -- no reset
		sw <= "0000000110"; -- Night / Weight EW
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges
		wait for clk_cycle;
		
		key <= "1111"; -- no reset
		sw <= "0000000111"; -- Night / Weight EW / Weight NS
		-- wait for a fraction of the clock so stimulus is not occuring on clock edges
		wait for clk_cycle;
		
		end process;
		

-- instantiate the device under test (dut)
dut :de1_top
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
		
		
		
	
	