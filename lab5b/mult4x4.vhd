LIBRARY ieee;
USE IEEE.NUMERIC_STD.ALL;

entity mult4x4 is
	port (
		dataa :in unsigned(3 downto 0);
		datab :in unsigned(3 downto 0);
		product :out unsigned (7 downto 0)
	);
end mult4x4;

architecture behavior of mult4x4 is
begin
	product <= dataa * datab;
end behavior;