LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu_decoder IS
	PORT(Funct      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
		 ALUOpIn    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		 ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF alu_decoder IS
BEGIN	
	ALUControl <= "010" WHEN ALUOpIn    = "00" ELSE                      -- ADD
				  "110" WHEN ALUOpIn    = "01" ELSE                      -- SUB
				  "000" WHEN ALUOpIn(1) = '1'  AND Funct = "01100" ELSE  -- AND
				  "001" WHEN ALUOpIn(1) = '1'  AND Funct = "01101" ELSE  -- OR
				  "111" WHEN ALUOpIn(1) = '1'  AND Funct = "00010" ELSE  -- SLT
				  "011" WHEN OTHERS;                                     -- NOT USED				  
END ARCHITECTURE; 
