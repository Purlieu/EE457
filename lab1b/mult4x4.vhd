LIBRARY ieee;
USE IEEE.NUMERIC_STD.ALL;

-- Begin entity declaration for mult4x4
entity mult4x4 is
	-- Begin port declaration
	port (
		-- Declare data inputs "dataa" and "datab"
		dataa, datab :in unsigned(3 downto 0);
		
		-- Declare multiplier output "product"
		product :out unsigned (7 downto 0)
	);
end entity mult4x4;

architecture behavior of mult4x4 is
begin
	-- Multiply the values of "dataa" and "datab" to store result in output "product"
	product <= dataa * datab;
end behavior;