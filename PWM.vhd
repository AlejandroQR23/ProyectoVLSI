library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM is
	port
	(
		Reloj : in std_logic;
		D : in std_logic_vector(7 downto 0);
		S : out std_logic 
	);
end PWM;

architecture Behavioral of PWM is
begin

	process(Reloj)
		variable cuenta : integer range 0 to 255 := 0;
	begin
		if Reloj = '1' and Reloj'event then
			cuenta := (cuenta + 1) mod 256;
			if cuenta < D then
				S <= '1';
			else
				S <= '0';
			end if;
		end if;
	end process;
end Behavioral;