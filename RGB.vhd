library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RGB is
	Port(
		clk : in std_logic;
		color : in integer;
		led_red : out std_logic;
		led_green : out std_logic;
		led_blue : out std_logic
	);
end RGB;

architecture Behavioral of RGB is
	
	component divisor is
		Generic (N : integer := 24);
		Port ( clk : in std_logic;
				 div_clk : out std_logic );
	end component;
	
	component PWM is
		Port ( Reloj : in std_logic;
				 D : in std_logic_vector(7 downto 0);
				 S : out std_logic );
	end component;
	
	signal relojPWM : std_logic;
	
	-- Blanco inicial
	signal a1 : std_logic_vector(7 downto 0) := X"FF"; -- R
	signal a2 : std_logic_vector(7 downto 0) := X"FF"; -- G
	signal a3 : std_logic_vector(7 downto 0) := X"FF"; -- B
	
	signal red 	 : std_logic;
	signal green : std_logic;
	signal blue  : std_logic;
	
begin
	D1: divisor generic map (10) port map (clk, relojPWM);
	P1: PWM port map (relojPWM, a1, red);
	P2: PWM port map (relojPWM, a2, green);
	P3: PWM port map (relojPWM, a3, blue);
	
	genera_color : process(color)
	begin
		
		case color is
			when 0 => 
				-- Rojo
				a1 <= X"FF";
				a2 <= X"00";
				a3 <= X"00";
			when 1 =>
				-- Verde
				a1 <= X"00";
				a2 <= X"FF";
				a3 <= X"00";
			when others =>
				-- Blanco
				a1 <= X"FF";
				a2 <= X"FF";
				a3 <= X"FF";
		end case;
		
	end process;
	
	led_red <= red;
	led_green <= green;
	led_blue <= blue;
	
end Behavioral;