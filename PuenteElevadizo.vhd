library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PuenteElevadizo is
	port(
		clk : in std_logic;
		
		buzz   : out std_logic;
		mot  : out std_logic_vector(3 downto 0);
		
		-- Display de 7 segmentos
		segmento_unid : out std_logic_vector(7 downto 0);
		segmento_dec : out std_logic_vector(7 downto 0);
		
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
	
	-- Display para el contador
	component Display is
		port(
			unidades : integer;
			decenas  : integer;
			segmento_unid : out std_logic_vector(7 downto 0);
			segmento_dec : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component Divisor is
		Generic 	( N : integer := 24);
		Port		( clk : in std_logic;
						div_clk : out std_logic);
	end component;
	
	component Motor is
		Port	(paso : in std_logic;
				UD : in std_logic;
				rst : in std_logic;
				FH : in std_logic_vector(1 downto 0);
				MOT : out std_logic_vector(3 downto 0)
				);
	end component;
	
	-- Ultrasonicos
	signal distanciaEntrada : unsigned(7 downto 0);
	signal distanciaSalida  : unsigned(7 downto 0);
	signal inicio				: std_logic := '0';
	
	-- Contador
	signal unidades : integer := 0;
	signal decenas : integer := 1;
	signal relojContador : std_logic;
	
	-- Motor
	signal reloj : std_logic;
	signal UD : std_logic;
	signal rst : std_logic;
	signal FH : std_logic_vector(1 downto 0) := "01";
	
	-- Senales
	signal senal : integer;
	signal senalSalida  : std_logic := '0';
	signal inicioContador   : std_logic := '0';
	signal reinicioContador : std_logic := '0';
	
	-- Constantes
	constant distanciaDeteccion : unsigned(7 downto 0)  := X"0A";	  			 -- distancia a la que se detecta un objeto = 10cm
	constant pasosMax				 : std_logic_vector(11 downto 0) := X"7D0";   -- pasos que dara el motor = 2000
	
begin

	B1 : Buzzer port map(clk, senal, buzz);

	S1 : sonicos port map(clk, inicio, leftTrigger, leftEcho, distanciaEntrada);	 -- sensor de entrada
	S2 : sonicos port map(clk, inicio, rightTrigger, rightEcho, distanciaSalida); -- sensor de salida
	
	L1 : RGB port map(clk, senal, led_red, led_green, led_blue);
	
	D1 : divisor generic map (17) port map (clk, reloj);
	M1 : Motor port map (reloj, UD, rst, FH, mot);
	
	C1 : display port map(unidades, decenas, segmento_unid, segmento_dec);
	D2 : divisor generic map (24) port map (clk, relojContador);
	
	-- Detecta entrada de un objeto
	detectaObjeto : process(distanciaEntrada)
	begin
	
		-- se detecta un objeto de entrada
		if distanciaEntrada < distanciaDeteccion then
			senal <= 1;
			reinicioContador <= '1';
		
		-- se detecta un objeto de salida
		elsif distanciaSalida < distanciaDeteccion then
			inicioContador <= '1';
			reinicioContador <= '0';
		
		-- el contador termina
		elsif senalSalida = '1' then
			senal <= 0;
			inicioContador <= '0';
		
		else
			senal <= 2;
		end if;
	
	end process;
	
	-- Cuenta 10 segundos luego de que el sensor detecta una salida de objeto
	contador : process(relojContador) is
	begin
		
		if(inicioContador = '1' and reinicioContador = '0') then
			if rising_edge(relojContador) then
				if (decenas = 1 and unidades = 0) then
					decenas <= 0;
					unidades <= 9;
				elsif (decenas = 0 and unidades = 0) then
					senalSalida <= '1';
					unidades <= 0;
					decenas  <= 1;
				elsif (reinicioContador = '1') then
					senalSalida <= '0';
					decenas <= 1;
					unidades <= 0;
				else
					unidades <= unidades - 1;
				end if;
			end if;
			
		elsif (senal = 1) then
			senalSalida <= '0';
			decenas <= 1;
			unidades <= 0;
		end if;
		
	end process contador;
	
	-- Mueve el motor para abrir o cerrar el puente
	mueveMotor : process(clk, UD, rst)
		variable contador : std_logic_vector(11 downto 0) := X"000";
	begin
		if(reloj'event and reloj = '1') then
			
			if(senal = 1) then
				UD <= '1';
			end if;
			
			if(contador < pasosMax) then
				contador := contador + 1;
			else
				contador := X"000";
				UD <= '0';
				rst <= '0';
			end if;
		
		end if;
	end process;

end behavioral;



