 LIBRARY ieee;
	USE ieee.numeric_std.all;
	use IEEE.std_logic_1164.all; 

-- Begin entity declaration for shifter
entity shifter is	
	-- Begin port declaration
	port (
		-- Declare data input "input" 
		input :in unsigned(7 downto 0);
		
		-- Declare data input "shift_cntrl"
		shift_cntrl: in unsigned(1 downto 0);
		
		-- Declare shift output "shift_out"
		shift_out: out unsigned(15 downto 0)
	);
end entity shifter;

architecture behavior of shifter is
begin
	process(input, shift_cntrl)
	begin
		-- Always set the value of "shift_out" to be all 0's
		shift_out <= "0000000000000000";
		-- Store "input" into "shift_out" when "shift_cntrl" is 0
		if(shift_cntrl = 0) then
			shift_out(7 downto 0) <= input(7 downto 0);
		-- Store "input" into bits "11 downto 4" of "shift_out" when "shift_cntrl" is 1
		elsif(shift_cntrl = 1) then
			shift_out(11 downto 4) <= input(7 downto 0);
		-- Store "input" into bits "15 downto 8" of "shift_out" when "shift_cntrl" is 2
		elsif(shift_cntrl = 2) then
			shift_out(15 downto 8) <= input(7 downto 0);
		-- Store "input" into "shift_out" when "shift_cntrl" is not 0, 1, or 2		
		else
			shift_out(7 downto 0) <= input(7 downto 0);
		end if;
	end process;
end behavior;
