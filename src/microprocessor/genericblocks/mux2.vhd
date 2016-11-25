-- MUX2
-- GENERIG WORD WIDTH (DEFAULT 16 BITS)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux2 IS
	GENERIC(word_width    : INTEGER := 16);
	PORT   (data0, data1  : IN  STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
			data_out      : OUT STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
			sel           : IN  STD_LOGIC);
END ENTITY;

ARCHITECTURE behave OF mux2 IS
BEGIN
	data_out <= data0 WHEN sel = '0' ELSE
				data1 WHEN sel = '1';  
END ARCHITECTURE;