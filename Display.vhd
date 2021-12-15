library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display is
	port(
		unidades : integer;
	   decenas  : integer;
		segmento_unid : out std_logic_vector(7 downto 0);
		segmento_dec : out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavioral of Display is
begin

	decodificadorUnid : process(unidades)
	begin
		if unidades = 0 then segmento_unid <= X"81";
		elsif unidades = 1 then segmento_unid <= X"F3";
		elsif unidades = 2 then segmento_unid <= X"49";
		elsif unidades = 3 then segmento_unid <= X"61";
		elsif unidades = 4 then segmento_unid <= X"33";
		elsif unidades = 5 then segmento_unid <= X"25";
		elsif unidades = 6 then segmento_unid <= X"05";
		elsif unidades = 7 then segmento_unid <= X"F1";
		elsif unidades = 8 then segmento_unid <= X"01";
		elsif unidades = 9 then segmento_unid <= X"21";
		else segmento_unid <= X"1D";
		end if;
	end process;
	
	decodificadorDec : process(decenas)
	begin
		if decenas = 0 then segmento_dec <= X"81";
		elsif decenas = 1 then segmento_dec <= X"F3";
		elsif decenas = 2 then segmento_dec <= X"49";
		elsif decenas = 3 then segmento_dec <= X"61";
		elsif decenas = 4 then segmento_dec <= X"33";
		elsif decenas = 5 then segmento_dec <= X"25";
		elsif decenas = 6 then segmento_dec <= X"05";
		elsif decenas = 7 then segmento_dec <= X"F1";
		elsif decenas = 8 then segmento_dec <= X"01";
		elsif decenas = 9 then segmento_dec <= X"21";
		else segmento_dec <= X"1D";
		end if;
	end process;

end architecture;