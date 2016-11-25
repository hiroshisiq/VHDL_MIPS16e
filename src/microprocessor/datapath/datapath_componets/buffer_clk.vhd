LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY buffer_clk IS
	PORT   (clock, control : IN  STD_LOGIC;
			buffer_in      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			buffer_out     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF buffer_clk IS
	SIGNAL tmp : STD_LOGIC_VECTOR(15  DOWNTO 0);
BEGIN

	tmp <= buffer_in;

	rising : PROCESS (clock, control, buffer_in)
	BEGIN
		IF (RISING_EDGE(clock) AND control = '1') THEN
			buffer_out <= tmp; 
		END IF;
	END PROCESS; 

END ARCHITECTURE;	 

