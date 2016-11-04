-- REGISTER FILE
-- 8 REGISTERS OF 16 BITS WORDS
-- WRITE ON THE RISING EDGE IF WRITE ENABLE 3 = '1'

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY register_file IS
	port(clock                    : IN  STD_LOGIC;
         write_e3                 : IN  STD_LOGIC;
         write_a3                 : IN  STD_LOGIC_VECTOR(3  DOWNTO 0);
         write_d3                 : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);            
         register_a1, register_a2 : IN  STD_LOGIC_VECTOR(3  DOWNTO 0);
         register_d1, register_d2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF register_file IS
	TYPE ramtype IS ARRAY(7 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL memory : ramtype;	
BEGIN

	-- WRITE ONTO REGISTER PROCESS
	write_process : PROCESS(clock)
	BEGIN
		IF RISING_EDGE (clock) THEN
			IF write_e3 = '1'  THEN
				memory(TO_INTEGER(unsigned(write_a3))) <= write_d3;
			END IF;
		END IF;
	END PROCESS;

	-- READ FROM A REGISTER PROCESS
	read_process : PROCESS(clock, write_e3, write_a3, write_d3, register_a1, register_a2)
	BEGIN
		-- READ FROM REGISTER 1
		IF TO_INTEGER(unsigned(register_a1)) = 0 THEN
			register_d1 <= "0000000000000000";
		ELSE
			register_d1 <= memory(TO_INTEGER(unsigned(register_a1)));
		END IF;

		-- READ FROM REGISTER 2
		IF TO_INTEGER(unsigned(register_a2)) = 0 THEN
			register_d2 <= "0000000000000000";
		ELSE
			register_d2 <= memory(TO_INTEGER(unsigned(register_a2)));
		END IF;
	END PROCESS;

END ARCHITECTURE;
