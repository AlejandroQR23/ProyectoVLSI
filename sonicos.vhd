library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sonicos is
	port
	(
		clk : in std_logic;
		inicio : in std_logic; -- boton de inicio
		sensor_disp : out std_logic;
		sensor_eco : in std_logic;
		
		cm: out unsigned(7 downto 0)
	);
end sonicos;

architecture behavioral of sonicos is

	signal cuenta: unsigned(16 downto 0) := (others => '0');
	signal centimetros: unsigned(15 downto 0) := (others => '0');
	signal centimetros_unid: unsigned(3 downto 0) := (others => '0');
	signal centimetros_dece: unsigned(3 downto 0) := (others => '0');
	signal centimetros_cent: unsigned(3 downto 0) := (others => '0');
	
	signal sal_unid: unsigned(3 downto 0) := (others => '0');
	signal sal_dece: unsigned(3 downto 0) := (others => '0');
	signal sal_cent: unsigned(3 downto 0) := (others => '0');
	signal sal_cm: unsigned(7 downto 0) := (others => '0');
	
	signal eco_pasado: std_logic := '0';
	signal eco_sinc: std_logic := '0';
	signal eco_nsinc: std_logic := '0';
	signal espera: std_logic := '0';
	
begin 
	
	Trigger: process(clk, inicio)
	begin
		if inicio = '0' then
		
			if rising_edge(clk) then
				if espera = '0' then
					if cuenta = 500 then
						sensor_disp <= '0';
						espera <= '1';
						cuenta <= (others => '0');
					else 
						sensor_disp <= '1';
						cuenta <= cuenta + 1;
					end if;
				elsif eco_pasado = '0' and eco_sinc = '1' then
					cuenta <= (others => '0');
					centimetros <= (others => '0');
					centimetros_unid <= (others => '0');
					centimetros_dece <= (others => '0');
					centimetros_cent <= (others => '0');
				elsif eco_pasado = '1' and eco_sinc = '0' then
					sal_unid <= centimetros_unid;
					sal_dece <= centimetros_dece;
					sal_cent <= centimetros_cent;
					sal_cm <= sal_unid + (sal_dece*10) + (sal_cent*100);
				elsif cuenta = 2900-1 then
					if centimetros_unid = 9 then
						centimetros_unid <= (others => '0');
						if centimetros_dece = 9 then
							centimetros_dece <= (others => '0');
							centimetros_cent <= centimetros_cent + 1;
						else 
							centimetros_dece <= centimetros_dece + 1;
						end if;
					else
						centimetros_unid <= centimetros_unid + 1;
					end if;
					centimetros <= centimetros + 1;
					cuenta <= (others => '0');
					if centimetros = 3448 then
						espera <= '0';
					end if;
				else
					cuenta <= cuenta + 1;
				end if;
				
				eco_pasado <= eco_sinc;
				eco_sinc <= eco_nsinc;
				eco_nsinc <= sensor_eco;
				
			end if;
		end if;
	end process;
	
	cm <= sal_cm;
	
end behavioral;
				
				
				
			
			
			
				
				
				
			
			
			