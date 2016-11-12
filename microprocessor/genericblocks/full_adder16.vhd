LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY full_adder16 IS
	PORT(source_a, source_b   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		 result				  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
		 carry_in             : IN  STD_LOGIC;  
		 carry_out            : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE behave OF full_adder16 IS
	COMPONENT full_adder1 IS
	PORT(source_a, source_b, carry_in : IN  STD_LOGIC;
		 result, carry_out            : OUT STD_LOGIC);
	END COMPONENT;

	-- INTERNAL CARRY OUT
	SIGNAL cout_internal : STD_LOGIC_VECTOR(16 DOWNTO 0);  
BEGIN
	-- CARRY IN AND CARRY OUT
	cout_internal(0) <= carry_in;
	carry_out        <= cout_internal(16); 

	-- GENERATE THE FULLADDER16 WITH FULLADDER1
	gen_adder16 : FOR i IN 0 TO 15 GENERATE
		adder1 : full_adder1 PORT MAP(source_a(i), source_b(i), cout_internal(i), cout_internal(i+1));
	END GENERATE gen_adder16;

END ARCHITECTURE;