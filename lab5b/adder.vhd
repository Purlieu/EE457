library IEEE;
use IEEE.NUMERIC_STD.ALL;

entity adder is
	port(
		dataa :in unsigned(15 downto 0);
		datab :in unsigned(15 downto 0);
		sum :out unsigned(15 downto 0)
	);
end adder;

architecture behavior of adder is
begin
	sum <= dataa + datab;
end behavior;
