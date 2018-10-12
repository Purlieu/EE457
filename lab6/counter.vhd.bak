LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity gen_counter is
-- we are using the generic construct to allow this counter to be generic.
generic (
		wide : positive; -- how many bits is the counter
		max  : positive  -- what is the max value of the counter ( modulus )
		);
port (
		clk	 :in  std_logic; -- system clock
		data	 :in  std_logic_vector( wide-1 downto 0 ); -- data in for parallel load, use unsigned(data) to cast to unsigned
		load	 :in  std_logic; -- signal to load data into i_count i_count <= unsigned(data);
		enable :in  std_logic; -- clock enable
		reset	 :in  std_logic; -- reset to zeros use i_count <= (others => '0' ) since size depends on generic
		count	 :out std_logic_vector( wide-1 downto 0 ); -- count out
		term	 :out std_logic -- maximum count is reached
		);
end;
	
architecture rtl of gen_counter is
-- use a signal of type unsigned for counting
signal i_count : unsigned (wide-1 downto 0); -- see how we made this generic using the generics above

begin

-- drive the count to the output.
count <= std_logic_vector(i_count); -- we type cast the count back to std_logic_vector

-- counter process, asynchronously clears the counter to 0's
-- allows the count value to be preset/loaded with a value when
-- the load signal is high, and has priority
-- once the counter is enabled the counter will start counting until it rolls over
-- or the max count is met. 
counter: process(clk, reset) begin
  if (reset='1') then -- active high reset
	 i_count <= (others => '0'); -- set counter to 0's
	 term    <= '0';  -- want the terminal count off on reset
  elsif (rising_edge(clk)) then
    term <='0';
    if (load = '1') then  -- load takes priority
	 	   i_count <= unsigned(data);
    elsif (enable = '1') then -- if enabled the counter is running.
	   if (i_count=max) then -- the max value is hit, synchronously set to '0's
		  term <='1'; -- we only want this active for 1 clock cycle
	     i_count<=(others=>'0');
	   else -- increment the counter
		  term <= '0'; -- disable to term count, so only high for 1 clock cycle
	     i_count <= i_count + 1;
      end if; 
    end if;
   end if;
end process;




end;
			