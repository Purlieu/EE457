 LIBRARY ieee;
	USE ieee.numeric_std.all;
	use IEEE.std_logic_1164.all;

-- Begin entity declaration for reg16
entity reg16 is
	-- Begin port declaration
	port(
		-- Declare control inputs "clk", "sclr_n" and "clk_ena"
		clk, sclr_n, clk_ena: in std_logic;
		
		-- Declare data input "datain
		datain: in unsigned(15 downto 0);
		
		-- Declare data output "reg_out"
		reg_out: in unsigned(15 downto 0);
	);
end entity reg16;

architecture behavior of reg16 is
	begin
		process(clk, sclr_n, clk_ena, datain)
		-- Create variable "tempdatain" to temporary hold "data"
		variable tempdatain: unsigned(15 downto 0);
		begin
			-- On Rising Edge of "clk" 
			if clk'event and clk = '1' then
				-- When "clk_ena" is 1 and "sclr_n" is 0, reset "reg_out"
				if clk_ena = '1' then
					if sclr_n = '0' then
						reg_out <= "0000000000000000";
					-- Otherwise "reg_out" gets the value of "datain"
					else
						reg_out <= datain;
					end if;
				-- When "clk_ena" is 0, store the temp value of "datain" inside of "tempdatain"
				elsif clk_ena = '0' then
					tempdatain := datain;
					tempdatain := tempdatain;
				end if;
			end if;
		end process;
end behavior;