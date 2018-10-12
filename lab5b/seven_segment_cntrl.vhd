 LIBRARY ieee;
	USE ieee.numeric_std.all;
	use IEEE.std_logic_1164.all;
	
entity seven_segment_cntrl is
	port(
		input: in unsigned(2 downto 0);
		seg_a: out std_logic;
		seg_b: out std_logic;
		seg_c: out std_logic;
		seg_d: out std_logic;
		seg_e: out std_logic;
		seg_f: out std_logic;
		seg_g: out std_logic
	);
end seven_segment_cntrl;

architecture behavior of seven_segment_cntrl is
begin
	process(input)
	begin
	case(input) is
		when "000" => 
			seg_a <= '1';
			seg_b <= '1';
			seg_c <= '1';
			seg_d <= '1';
			seg_e <= '1';
			seg_f <= '1';
			seg_g <= '0';
		when "001" => 
			seg_a <= '0';
			seg_b <= '1';
			seg_c <= '1';
			seg_d <= '0';
			seg_e <= '0';
			seg_f <= '0';
			seg_g <= '0';
		when "010" => 
			seg_a <= '1';
			seg_b <= '1';
			seg_c <= '0';
			seg_d <= '1';
			seg_e <= '1';
			seg_f <= '0';
			seg_g <= '1';
		when "011" => 
			seg_a <= '1';
			seg_b <= '1';
			seg_c <= '1';
			seg_d <= '1';
			seg_e <= '0';
			seg_f <= '0';
			seg_g <= '1';
		when others => 
			seg_a <= '1';
			seg_b <= '0';
			seg_c <= '0';
			seg_d <= '1';
			seg_e <= '1';
			seg_f <= '1';
			seg_g <= '1';
		end case;
	end process;
end behavior;
		