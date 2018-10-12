 LIBRARY ieee;
	USE ieee.numeric_std.all;
	use IEEE.std_logic_1164.all;

-- Begin entity declaration of counter
entity counter is
	-- Begin port declaration
	port(
		-- Declare control inputs "clk" and "aclr_n"
		clk, aclr_n: in std_logic;
		
		-- Declare control output "count_out"
		count_out: out unsigned(1 downto 0)
	);
end entity counter;

architecture behavior of counter is
	begin
		process(clk, aclr_n)
			-- Create variable "q_var" to hold value of "count"
			variable q_var: unsigned(1 downto 0);
		begin
			-- When aclr_n is 0, then reset "count" and variable "q_var"
			if aclr_n = '0' then
				count_out <= "00";
				q_var := "00";
			else
			-- Otherwise, on rising edge of "clk" increment "q_var" and store in "count"
				if clk'event and clk = '1' then
					q_var := q_var + 1;
					count_out <= q_var;
				end if;
			end if;
		end process;
end behavior;