LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
ENTITY control_unit IS
	PORT(CTRL_Clk        : IN  STD_LOGIC;
		 CTRL_Zero       : IN  STD_LOGIC;
		 CTRL_Opcode     : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
         CTRL_Funct      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
         CTRL_MemToReg   : OUT STD_LOGIC;
         CTRL_RegDst     : OUT STD_LOGIC;
         CTRL_IorD       : OUT STD_LOGIC;
         CTRL_PCSrc      : OUT STD_LOGIC;
         CTRL_ALUSrcB    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
         CTRL_ALUSrcA    : OUT STD_LOGIC;
         CTRL_IRWrite    : OUT STD_LOGIC;
		 CTRL_MemWrite   : OUT STD_LOGIC;
         CTRL_RegWrite   : OUT STD_LOGIC;
         CTRL_PCEn       : OUT STD_LOGIC;
		 CTRL_ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));

END ENTITY;

ARCHITECTURE behave OF control_unit IS

	COMPONENT main_controller
		PORT(Clk        : IN  STD_LOGIC;
			 Opcode     : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
    	     MemToReg   : OUT STD_LOGIC;
    	     RegDst     : OUT STD_LOGIC;
    	     IorD       : OUT STD_LOGIC;
    	     PCSrc      : OUT STD_LOGIC;
    	     ALUSrcB    : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
    	     ALUSrcA    : OUT STD_LOGIC;
    	     IRWrite    : OUT STD_LOGIC;
			 MemWrite   : OUT STD_LOGIC;
			 PCWrite    : OUT STD_LOGIC;
			 Branch     : OUT STD_LOGIC;
    	     RegWrite   : OUT STD_LOGIC;
			 ALUOpOut   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0));
	END COMPONENT;

	COMPONENT alu_decoder
		PORT(Funct      : IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
			 ALUOpIn    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			 ALUControl : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
	END COMPONENT;

	SIGNAL ALUOp       : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL tmp_PCWrite : STD_LOGIC;
	SIGNAL tmp_Branch  : STD_LOGIC;

BEGIN

	main_ctrl: main_controller PORT MAP
				(Clk      => CTRL_Clk     , Opcode   => CTRL_Opcode , MemToReg => CTRL_MemToReg, 
    	     	 RegDst   => CTRL_RegDst  , IorD     => CTRL_IorD   , PCSrc    => CTRL_PCSrc   , 
    	     	 ALUSrcB  => CTRL_ALUSrcB , ALUSrcA  => CTRL_ALUSrcA, IRWrite  => CTRL_IRWrite , 
			 	 MemWrite => CTRL_MemWrite, PCWrite  => tmp_PCWrite , Branch   => tmp_Branch   ,
    	     	 RegWrite => CTRL_RegWrite, ALUOpOut => ALUOp);

	CTRL_PCEn <= (tmp_Branch AND CTRL_Zero) OR tmp_PCWrite;

	decoder  : alu_decoder PORT MAP
				(Funct    => CTRL_Funct   , ALUOpIn  => ALUOp       , ALUControl => CTRL_ALUControl);

END ARCHITECTURE;