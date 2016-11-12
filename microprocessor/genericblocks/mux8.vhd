-- MUX8
-- GENERIG WORD WIDTH (DEFAULT 16 BITS)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux8 IS
	GENERIC(word_width                  : INTEGER := 16);
	PORT   (data0, data1, data2, data3  : IN  STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
			data4, data5, data6, data7  : IN  STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
			data_out                    : OUT STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
			sel                         : IN  STD_LOGIC_VECTOR(2 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF mux8 IS
	SIGNAL tmp : BIT_VECTOR(1 DOWNTO 0);
BEGIN
	tmp <= to_bitvector(sel); 
	WITH tmp SELECT data_out <=
		data0 WHEN "000",		
		data1 WHEN "001",
		data2 WHEN "010",
		data3 WHEN "011",
		data4 WHEN "100",		
		data5 WHEN "101",
		data6 WHEN "110",
		data7 WHEN "111";
END ARCHITECTURE;