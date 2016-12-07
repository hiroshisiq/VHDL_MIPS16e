LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY main_controller IS
	PORT(Clk           : IN  STD_LOGIC;
		 Opcode        : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
         MemToReg      : OUT STD_LOGIC;
         RegDst        : OUT STD_LOGIC;
         IorD          : OUT STD_LOGIC;
         PCSrc         : OUT STD_LOGIC;
         ALUSrcB       : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
         ALUSrcA       : OUT STD_LOGIC;
         IRWrite       : OUT STD_LOGIC;
		 MemWrite      : OUT STD_LOGIC;
		 PCWrite       : OUT STD_LOGIC;
		 Branch        : OUT STD_LOGIC;
         RegWrite      : OUT STD_LOGIC;
		 ALUOpOut      : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF main_controller IS
	-- State type
	TYPE st IS (fetch, decode, memAdr, memRead, memWriteBack, memWrite, execute, branch);
	SIGNAL state : st := fetch;

	-- Sets controls signals for state fetch
	PROCEDURE fetch_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
						  MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
						  ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function
        IorD     := '0';  -- Select adress from PC
        ALUSrcA  := '0';  -- Select PC as ALU's source A  
        ALUSrcB  := "01"; -- Select constant 4 as ALU's source B
		ALUOpOut := "00"; -- Select ALU's operation as sum
        PCSrc    := '0';  -- Select PC source as ALU's result   
        IRWrite  := '1';  -- Enable write on instruction register
		PCWrite  := '1';  -- Enable write on program counter register  
		-- Default value
		MemToReg := '0'; RegDst := '0'; MemWrite := '0'; Branch := '0'; RegWrite := '0';     
	END PROCEDURE;

	-- Sets controls signals for state decode
	PROCEDURE decode_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
						   MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
						   ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function
		ALUSrcA  := '0';  -- Select register file output d1 for ALU's source A
		ALUSrcB  := "11"; -- Select sign extended signal(offset) for ALU's source B
		ALUOpOut := "00"; -- Select ALU's sum function
		-- Default value
        IorD     := '0'; PCSrc    := '0'; IRWrite  := '0'; PCWrite  := '0'; MemToReg := '0' ; 
        RegDst   := '0'; MemWrite := '0'; Branch   := '0'; RegWrite := '0';		
	END PROCEDURE;

	-- Sets controls signals for state decode
	PROCEDURE memAdr_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
						   MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
						   ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function
		ALUSrcA  := '1';  -- Select register file output d1 for ALU's source A
		ALUSrcB  := "10"; -- Select sign extended signal(offset) for ALU's source B
		ALUOpOut := "00"; -- Select ALU's sum function
		-- Default value
        IorD     := '0'; PCSrc    := '0'; IRWrite  := '0'; PCWrite  := '0'; MemToReg := '0' ; 
        RegDst   := '0'; MemWrite := '0'; Branch   := '0'; RegWrite := '0';     
	END PROCEDURE;

	-- Sets controls signals for state decode
	PROCEDURE memRead_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
						    MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
						    ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function
		IorD     := '1'; -- Select data from ALU's result buffer
		-- Default value
        ALUSrcA  := '0'; ALUSrcB  := "00"; ALUOpOut := "00"; PCSrc    := '0'; IRWrite  := '0'; PCWrite  := '0'; 
        MemToReg := '0'; RegDst   := '0' ; MemWrite := '0' ; Branch   := '0'; RegWrite := '0';     
	END PROCEDURE;

	-- Sets controls signals for state decode
	PROCEDURE memWriteBack_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
						         MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
						         ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function 
		RegDst   := '0'; -- Select Ry adress on register file
		RegWrite := '1'; -- Enable write to register file
		MemToReg := '1'; -- Select data from data buffer to write on register file
		-- Default value
        IorD     := '0'; ALUSrcA  := '0'; ALUSrcB  := "00"; ALUOpOut := "00"; PCSrc := '0';    
        IRWrite  := '0'; PCWrite  := '0'; MemWrite := '0' ; Branch   := '0' ;     
	END PROCEDURE;

	PROCEDURE memWrite_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
					         MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
					         ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function 
		MemWrite := '1'; -- Enable write no memory
		IorD     := '1'; -- Enter data
		-- Default value
        ALUSrcA  := '0'; ALUSrcB  := "00"; ALUOpOut := "00"; PCSrc := '0'   ; RegDst   := '0';    
        IRWrite  := '0'; PCWrite  := '0' ; Branch   := '0' ; RegWrite := '0'; MemToReg := '0';       
	END PROCEDURE;

	PROCEDURE execute_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
					        MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
					        ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function 
		ALUSrcA  := '1' ; -- From Register Data 1
		ALUSrcB  := "00"; -- From Register Data 2
		ALUOpOut := "10"; 
		-- Default value
        PCSrc := '0'   ; RegDst   := '0'; MemWrite := '1'; IorD     := '1'; 
        IRWrite  := '0'; PCWrite  := '0'; Branch   := '0'; RegWrite := '0'; MemToReg := '0';       
	END PROCEDURE;

	PROCEDURE ALUWriteBack_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
						         MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
						         ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function 
		RegDst   := '1'; -- Select Ry adress on register file
		RegWrite := '1'; -- Enable write to register file
		MemToReg := '0'; -- Select data from data buffer to write on register file
		-- Default value
        IorD     := '0'; ALUSrcA  := '0'; ALUSrcB  := "00"; ALUOpOut := "00"; PCSrc := '0';    
        IRWrite  := '0'; PCWrite  := '0'; MemWrite := '0' ; Branch   := '0' ;     
	END PROCEDURE;

	PROCEDURE branch_state(MemToReg, RegDst, IorD, PCSrc, ALUSrcA, IRWrite : OUT STD_LOGIC;
						   MemWrite, PCWrite, Branch, RegWrite             : OUT STD_LOGIC;
						   ALUSrcB, ALUOpOut                               : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)) IS
	BEGIN
		-- State function 
		ALUSrcA  := '1' ; -- From Register Data 1
		ALUSrcB  := "00"; -- From Register Data 2
		ALUOpOut := "01";
		Branch   := '1' ; -- Enable PC Write
		PCSrc    := '1' ; -- PC will receive data from ALUout register
		-- Default value
        RegDst   := '0'; MemWrite := '1'; IorD     := '1'; 
        IRWrite  := '0'; PCWrite  := '0'; RegWrite := '0'; MemToReg := '0';    
	END PROCEDURE;

BEGIN

	state_machine : PROCESS(Clk, Opcode)
		-- Internal variable
		VARIABLE tmp_MemToReg : STD_LOGIC;
    	VARIABLE tmp_RegDst   : STD_LOGIC;
    	VARIABLE tmp_IorD     : STD_LOGIC;
    	VARIABLE tmp_PCSrc    : STD_LOGIC;
    	VARIABLE tmp_ALUSrcB  : STD_LOGIC_VECTOR(1 DOWNTO 0);
    	VARIABLE tmp_ALUSrcA  : STD_LOGIC;
    	VARIABLE tmp_IRWrite  : STD_LOGIC;
		VARIABLE tmp_MemWrite : STD_LOGIC;
		VARIABLE tmp_PCWrite  : STD_LOGIC;
		VARIABLE tmp_Branch   : STD_LOGIC;
    	VARIABLE tmp_RegWrite : STD_LOGIC;
		VARIABLE tmp_ALUOpOut : STD_LOGIC_VECTOR(1 DOWNTO 0);
	BEGIN

		IF(RISING_EDGE(Clk)) THEN
			CASE state IS
	   			WHEN fetch        =>
	   				-- Run State
	   				fetch_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   							tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);
	   				
	   				-- Switch state
	   				state <= decode;	     				
	   			
	   			WHEN decode       =>
	   				-- Run State
	   				decode_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   							 tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);
	   				
	   				-- Switch state
	   				CASE Opcode IS
	   					WHEN "10011" => state <= memAdr;   -- LW 
	   					WHEN "11011" => state <= memWrite; -- SW
	   					WHEN "11101" => state <= execute;  -- RR type
	   					WHEN "00100" => state <= branch; -- Branch
	   					WHEN OTHERS  => state <= fetch;
	   				END CASE;
	   			
	   			WHEN memAdr       =>
	      			-- Run State
	      			memAdr_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   							 tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);

	      			-- Switch state
	      			CASE Opcode IS
	   					WHEN "10011" => state <= memRead;
	   					WHEN "11011" => state <= memWrite;
	   					WHEN OTHERS  => state <= fetch;
	   				END CASE;

	
	   			WHEN memRead      =>
	   				-- Run State
	      			memRead_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   							  tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);

	      			-- Switch state
	      			state <= memWriteBack;
	
	   			WHEN memWriteBack =>
	   				-- Run State
	      			memWriteBack_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   							       tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);

	      			-- Switch state
	      			state <= fetch;

	      		WHEN memWrite     =>
	      			-- Run State
	      			memWrite_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   						       tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);

	      			-- Switch state
					state <= fetch; 

				WHEN execute      =>
					-- Run state
					execute_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   					          tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);

					-- Switch state
					state <= ALUWriteBack;

				WHEN ALUWriteBack =>
					-- Run state
					ALUWriteBack_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   						           tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);

					-- Switch state
					state <= fetch;

				WHEN branch       =>
					-- Run state
					branch_state(tmp_MemToReg, tmp_RegDst, tmp_IorD, tmp_PCSrc, tmp_ALUSrcA, tmp_IRWrite,
	   						     tmp_MemWrite, tmp_PCWrite, tmp_Branch, tmp_RegWrite, tmp_ALUSrcB, tmp_ALUOpOut);

					-- Switch state
					state <= fetch;

	   			WHEN OTHERS       =>
	      			state <= fetch;
			END CASE;
		END IF;

		-- Update outputs
		MemToReg <= tmp_MemToReg;
		RegDst   <= tmp_RegDst;    
		IorD     <= tmp_IorD;      
		PCSrc    <= tmp_PCSrc;      
		ALUSrcB  <= tmp_ALUSrcB;
		ALUSrcA  <= tmp_ALUSrcA;
		IRWrite  <= tmp_IRWrite;      
		MemWrite <= tmp_MemWrite;       
		PCWrite  <= tmp_PCWrite;       
		Branch   <= tmp_Branch;       
		RegWrite <= tmp_RegWrite;      
		ALUOpOut <= tmp_ALUOpOut;
	END PROCESS;

END ARCHITECTURE; 