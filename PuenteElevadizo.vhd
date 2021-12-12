library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PuenteElevadizo is
	port(
		clk : in std_logic;
		
		buzz   : out std_logic;
		
		-- Led RGB
		led_red : out std_logic;
		led_green : out std_logic;
		led_blue : out std_logic; 
		
		-- sensores ultrasonicos
		leftTrigger: out std_logic;
		leftEcho : in std_logic;
		
		rightTrigger: out std_logic;
		rightEcho : in std_logic
	);
end PuenteElevadizo;

architecture behavioral of PuenteElevadizo is

	-- Sensor ultrasonico
	component sonicos is
		port
		(
			clk : in std_logic;
			inicio : in std_logic;
			sensor_disp : out std_logic;
			sensor_eco : in std_logic;
			
			cm: out unsigned(7 downto 0)
		);
	end component;
	
	-- Led RGB
	component RGB is
		port(
			clk : in std_logic;
			color : in integer;
			led_red : out std_logic;
			led_green : out std_logic;
			led_blue : out std_logic
		);
	end component;
	
	-- Piezo Buzzer 
	component Buzzer is
		port
		(
			clk    : in std_logic;
			inicio : in integer;
			buzz   : out std_logic
		);
	end component;
	
	signal distanciaEntrada : unsigned(7 downto 0);
	signal distanciaSalida  : unsigned(7 downto 0);
	signal inicio				: std_logic := '0';
	
	signal senal : integer;
	
	constant distanciaDeteccion : unsigned(7 downto 0) := X"0A";	-- distancia a la que se detecta un objeto = 2cm
	
begin

	B1 : Buzzer port map(clk, senal, buzz);

	S1 : sonicos port map(clk, inicio, leftTrigger, leftEcho, distanciaEntrada);	 -- sensor de entrada
	S2 : sonicos port map(clk, inicio, rightTrigger, rightEcho, distanciaSalida); -- sensor de salida
	
	L1 : RGB port map(clk, senal, led_red, led_green, led_blue);
	
	-- Detecta entrada de un objeto
	entraObjeto : process(distanciaEntrada)
	begin
		if distanciaEntrada <= distanciaDeteccion then
			senal <= 1;
		else
			senal <= 2;
		end if;
	end process;
	
	-- Detecta salida de un objeto
--	saleObjeto : process(distanciaSalida)
--	begin
--		if distanciaSalida < distanciaDeteccion then
--			senal <= 0;
--		end if;
--	end process;

	
end behavioral;



