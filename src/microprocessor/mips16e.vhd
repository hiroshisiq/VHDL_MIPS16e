LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mips16e IS
	PORT(Clk_in        : IN  STD_LOGIC;
		 ReadData      : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Clk_out       : OUT STD_LOGIC;
		 EnableWrite   : OUT STD_LOGIC;
		 WriteData     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 Adress        : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY;

ARCHITECTURE behave OF mips16e IS

	-- CONTROL UNIT
	COMPONENT control_unit
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
	END COMPONENT;

	-- DATAPATH
	COMPONENT datapath
		PORT(-- External Inputs
			 clk         : IN  STD_LOGIC;
			 RD          : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
	
			 -- External Outputs
			 adress      : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			 WD          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
				 
			 -- Inputs from Control Unit
			 PCEn        : IN  STD_LOGIC;
	    	 PCSrc       : IN  STD_LOGIC;
	    	 IorD        : IN  STD_LOGIC;
	    	 IRWrite     : IN  STD_LOGIC;
	    	 RegWrite    : IN  STD_LOGIC;
	    	 RegDst      : IN  STD_LOGIC;
	    	 MemToReg    : IN  STD_LOGIC;
	    	 ALUSrcA     : IN  STD_LOGIC;
	    	 ALUSrcB     : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
	    	 ALUControl  : IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
	
    	     -- Outputs for Control Unit         
    	     op          : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    	     funct       : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
    	     zero_signal : OUT STD_LOGIC);
	END COMPONENT;

	-- Internal signals
	SIGNAL tmp_Zero       : STD_LOGIC;                                                                                                   
    SIGNAL tmp_Opcode     : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL tmp_Funct      : STD_LOGIC_VECTOR(4 DOWNTO 0);
    SIGNAL tmp_MemToReg   : STD_LOGIC;                       
    SIGNAL tmp_RegDst     : STD_LOGIC;                           
    SIGNAL tmp_IorD       : STD_LOGIC;                            
    SIGNAL tmp_PCSrc      : STD_LOGIC;                           
    SIGNAL tmp_ALUSrcB    : STD_LOGIC_VECTOR(1 DOWNTO 0); 
    SIGNAL tmp_ALUSrcA    : STD_LOGIC;                                  
    SIGNAL tmp_IRWrite    : STD_LOGIC;                                  
    SIGNAL tmp_RegWrite   : STD_LOGIC;                                  
    SIGNAL tmp_PCEn       : STD_LOGIC;                                  
    SIGNAL tmp_ALUControl : STD_LOGIC_VECTOR(2 DOWNTO 0);

BEGIN
	-- CONTROL UNIT MAP
	controlmap: control_unit PORT MAP
					(CTRL_Clk        => Clk_in        , CTRL_Zero     => tmp_Zero   , 
					 CTRL_Opcode     => tmp_Opcode    , CTRL_Funct    => tmp_Funct  , 
					 CTRL_MemToReg   => tmp_MemToReg  , CTRL_RegDst   => tmp_RegDst ,
					 CTRL_IorD       => tmp_IorD      , CTRL_PCSrc    => tmp_PCSrc  , 
					 CTRL_ALUSrcB    => tmp_ALUSrcB   , CTRL_ALUSrcA  => tmp_ALUSrcA, 
					 CTRL_IRWrite    => tmp_IRWrite   , CTRL_MemWrite => EnableWrite, 
					 CTRL_RegWrite   => tmp_RegWrite  , CTRL_PCEn     => tmp_PCEn   ,
					 CTRL_ALUControl => tmp_ALUControl); 

	-- DATAPATH MAP
	datamap   : datapath PORT MAP
					(clk         => Clk_in      , RD         => ReadData      ,
					 adress      => Adress      , WD         => WriteData     ,
					 PCEn        => tmp_PCEn    , PCSrc      => tmp_PCSrc     ,
					 IorD        => tmp_IorD    , IRWrite    => tmp_IRWrite   , 
					 RegWrite    => tmp_RegWrite, RegDst     => tmp_RegDst    ,
					 MemToReg    => tmp_MemToReg, ALUSrcA    => tmp_ALUSrcA   ,
					 ALUSrcB     => tmp_ALUSrcB , ALUControl => tmp_ALUControl, 
					 op          => tmp_Opcode  , funct      => tmp_Funct     ,
					 zero_signal => tmp_Zero    );

	-- Clock out
	Clk_out <= Clk_in;
END ARCHITECTURE;