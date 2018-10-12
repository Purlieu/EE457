 LIBRARY ieee;
	USE ieee.numeric_std.all;
	use IEEE.std_logic_1164.all;
	
-- Begin entity declaration for seven_segment_cntrl
entity seven_segment_cntrl is
	-- Begin port declaration
	port(
		-- Declare input data "input"
		input: in unsigned(2 downto 0);
		
		-- Declare 8 display outpuits "seg_a" -> "seg_g"
		seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g : out std_logic
	);
end entity seven_segment_cntrl;

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
		