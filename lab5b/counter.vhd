 LIBRARY ieee;
	USE ieee.numeric_std.all;
	use IEEE.std_logic_1164.all;
	
entity counter is
	port(
		clk: in std_logic;
		aclr_n: in std_logic;
		count_out: out unsigned(1 downto 0)
		);
end counter;

architecture behavior of counter is
	begin
		process(clk, aclr_n)
			variable q_var: unsigned(1 downto 0);
		begin
			if aclr_n = '0' then
				count_out <= "00";
				q_var := "00";
			else
				if clk'event and clk = '1' then
					q_var := q_var + 1;
					count_out <= q_var;
				end if;
			end if;
		end process;
end behavior;