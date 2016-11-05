-- ARITHMETIC LOGIC UNIT

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
--USE ALU_CONSTANT_PACKAGE.ALL;

ENTITY alu IS
	PORT   (source_a, source_b : IN     STD_LOGIC_VECTOR(15 DOWNTO 0);
			alu_control        : IN     STD_LOGIC_VECTOR(2  DOWNTO 0);
			zero               : OUT    STD_LOGIC;
			result             : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF alu IS	
	-- MOVER PARA O PACKAGE 
	CONSTANT ALU_AND1    : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "000";
	CONSTANT ALU_OR1     : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "001";
	CONSTANT ALU_SUM     : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "010";
	CONSTANT ALU_NOTUSED : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "011";
	CONSTANT ALU_AND2    : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "100";
	CONSTANT ALU_OR2     : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "101";
	CONSTANT ALU_SUB     : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "110";
	CONSTANT ALU_SLT     : STD_LOGIC_VECTOR(2  DOWNTO 0) :=   "111";
	CONSTANT ALU_ONE     : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0001";
	-- END MOVER PARA O PACKAGE

	COMPONENT full_adder16 IS
		PORT(source_a, source_b   : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
			 result				  : OUT STD_LOGIC_VECTOR(15 DOWNTO 0); 
			 carry_in             : IN  STD_LOGIC;  
			 carry_out            : OUT STD_LOGIC);
	END COMPONENT;
	
	SIGNAL add_in_a, add_in_b, add_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL two_complement              : STD_LOGIC_VECTOR(15 DOWNTO 0);
	SIGNAL cin, cout                   : STD_LOGIC;

BEGIN
	-- CONFIGURE FULL ADDER PORT MAP
	adder16 : full_adder16 PORT MAP(add_in_a, add_in_b, add_out, cin, cout);

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
        			add_in_a <= source_a;
        			add_in_b <= source_b;  
        			result   <= add_out;

        		-- A - B
        		WHEN ALU_SUB     =>
        			two_complement <= std_logic_vector(signed(NOT source_b) + 1);
        			add_in_a <= source_a;
        			add_in_b <= two_complement;
        			result <= add_out;
        		
        		-- A < B
        		WHEN ALU_SLT     => 
        			two_complement <= std_logic_vector(signed(NOT source_b) + 1);
        			add_in_a <= source_a;
        			add_in_b <= two_complement;
        			
        			IF add_out(15) = '1' THEN
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