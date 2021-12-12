library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Buzzer is
	port
	(
		clk    : in std_logic;
		inicio : in integer;
		buzz   : out std_logic
	);
end Buzzer;

architecture Behavioral of Buzzer is
	
	signal a : std_logic;

begin

	process(clk)
		variable i : integer := 0;
	begin
		
		if inicio = 1 then
		
			if clk'event and clk = '1' then
			
			if i <= 50000000 then
				i := i + 1;
				a <= '1';
			elsif i > 50000000 and i < 100000000 then
				i := i + 1;
				a <= '0';
			elsif i = 100000000 then
				i := 0;
			end if;
			
		end if;
		
		end if;
		
	end process;

	buzz <= a;
	
end Behavioral;
