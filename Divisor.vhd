library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Divisor is
	Generic ( N : integer := 24 );
	Port (clk : in std_logic;
			div_clk : out std_logic);
end Divisor;

architecture Behavioral of Divisor is 
begin
	process (clk)
		variable cuenta : std_logic_vector (27 downto 0) := X"0000000";
		begin
			if rising_edge (clk) then 
				cuenta := cuenta+1;
			end if;
			div_clk <= cuenta(N);
	end process;
end Behavioral;