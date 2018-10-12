 LIBRARY ieee;
	USE ieee.numeric_std.all;
	use IEEE.std_logic_1164.all; 

entity shifter is	
	port (
		input :in unsigned(7 downto 0);
		shift_cntrl: in unsigned(1 downto 0);
		shift_out: out unsigned(15 downto 0)
	);
end shifter;

architecture behavior of shifter is
begin
	process(input, shift_cntrl)
	begin
		shift_out <= "0000000000000000";
		if(shift_cntrl = 0) then
			shift_out(7 downto 0) <= input(7 downto 0);
		elsif(shift_cntrl = 1) then
			shift_out(11 downto 4) <= input(7 downto 0);
		elsif(shift_cntrl = 2) then
			shift_out(15 downto 8) <= input(7 downto 0);
		else
			shift_out(7 downto 0) <= input(7 downto 0);
		end if;
	end process;
end behavior;
