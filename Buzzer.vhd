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
	
	signal cont_la	    : std_logic_vector (16 downto 0);
	constant cont_max_la : std_logic_vector := "11011101111100100"; -- frecuencia de LA
	signal cont_do	    : std_logic_vector (17 downto 0);
	constant cont_max_do : std_logic_vector := "101110110001010010"; -- frecuencia de DO
	
begin

	divisor_la : process(clk)
	begin
		if clk'event and clk = '1' then
			cont_la <= cont_la + 1;
			if cont_la = cont_max_la then
				cont_la <= "00000000000000000";
			end if;
		end if;
	end process;
	
	divisor_do : process(clk)
	begin
		if clk'event and clk = '1' then
			cont_do <= cont_do + 1;
			if cont_do = cont_max_do then
				cont_do <= "000000000000000000";
			end if;
		end if;
	end process;

	process(inicio)
	begin
		
		if inicio = 1 then
			a <= cont_la(16);
		elsif inicio = 0 then
			a <= cont_do(17);
		else
			a <= '0';
		end if;
		
	end process;

	buzz <= a;
	
end Behavioral;
