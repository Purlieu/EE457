 LIBRARY ieee;
	USE ieee.std_logic_1164.all;
	USE ieee.numeric_std.all;

-- Begin entity declaration for mux4
entity mux4 is
	-- Begin port declaration
	port (
		-- Declare data inputs "mux_in_a" and "mux_in_b"
		mux_in_a, mux_in_b :in unsigned(3 downto 0);
		
		-- Declare output control signal "mux_sel"
		mux_sel :in std_logic;
		
		-- Declare mux output "mux_out"
		mux_out :out unsigned(3 downto 0)
	);
end entity mux4;

architecture behavior of mux4 is
begin
	process (mux_in_a, mux_in_b, mux_sel) is
	begin
		-- Store value in output "mux_out" when "mux_sel" is 0
		if(mux_sel = '0') then
			mux_out <= mux_in_a;
		-- Store value in output "mux_out" when "mux_sel" is anything but 0
		else
			mux_out <= mux_in_b;
		end if;
	end process;
end behavior;