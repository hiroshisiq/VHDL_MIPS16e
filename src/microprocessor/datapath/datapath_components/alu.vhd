-- ARITHMETIC LOGIC UNIT

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
use work.alu_package.all;

ENTITY alu IS
	PORT   (source_a, source_b : IN     STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_control        : IN     STD_LOGIC_VECTOR(2  DOWNTO 0);
			zero               : OUT    STD_LOGIC;
			result             : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF alu IS	
    SIGNAL tmp : STD_LOGIC_VECTOR(15  DOWNTO 0);
BEGIN
	op: PROCESS(source_a, source_b, alu_control)
		BEGIN
    		CASE alu_control IS
    			-- A AND B
        		WHEN ALU_AND1    => 
        			result <= source_a AND source_b;
        		
        		-- A AND NOT B
        		WHEN ALU_AND2    => 
        			result <= source_a AND NOT source_b;
        		
        		-- A OR B
        		WHEN ALU_OR1     => 
        			result <= source_a OR  source_b;
        		
        		-- A OR NOT B
        		WHEN ALU_OR2     => 
        			result <= source_a OR  NOT source_b;
        		
        		-- A + B
        		WHEN ALU_SUM     =>  
        			result <= std_logic_vector(signed(source_a) + signed(source_b));

        		-- A - B
        		WHEN ALU_SUB     =>
        			result <= std_logic_vector(signed(source_a) - signed(source_b));
        		
        		-- A < B
        		WHEN ALU_SLT     => 
        			tmp <= std_logic_vector(signed(source_a) - signed(source_b));
                
        			IF tmp(15) = '1' THEN
        				result <= X"FFFF";
        			ELSE
        				result <= X"0000";
        			END IF;
        		
        		-- NOT USED
        		WHEN others => 
        			result <= X"FFFF";
    	END CASE;

    	IF result = X"0000" THEN
    		zero <= '1';
    	END IF;

	END PROCESS;

END ARCHITECTURE;