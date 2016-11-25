LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY datapath IS
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
END ENTITY;

ARCHITECTURE behave OF datapath IS
-- MAIN BLOCKS
-- ALU
COMPONENT alu 
    PORT(source_a, source_b       : IN     STD_LOGIC_VECTOR(15 DOWNTO 0);
		 alu_control              : IN     STD_LOGIC_VECTOR(2  DOWNTO 0);
		 zero                     : OUT    STD_LOGIC;
		 result                   : BUFFER STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

-- 	Registers
COMPONENT register_file
	PORT(clock                    : IN  STD_LOGIC;
         write_e3                 : IN  STD_LOGIC;
         write_a3                 : IN  STD_LOGIC_VECTOR(2  DOWNTO 0);
         write_d3                 : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);            
         register_a1, register_a2 : IN  STD_LOGIC_VECTOR(2  DOWNTO 0);
         register_d1, register_d2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

-- Sign Extend
COMPONENT sign_extend IS
	PORT(in5                      : IN  STD_LOGIC_VECTOR(4  DOWNTO 0);
         out16                    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

-- GENERIC BLOCKS
-- Buffer
COMPONENT buffer_clk IS
	PORT(clock, control           : IN  STD_LOGIC;
		 buffer_in                : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		 buffer_out               : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END COMPONENT;

-- Mux 2
COMPONENT mux2 IS
	GENERIC(word_width    : INTEGER := 16);	
	PORT(data0, data1             : IN  STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
		 data_out                 : OUT STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
		 sel                      : IN  STD_LOGIC);
END COMPONENT;

-- Mux 4
COMPONENT mux4 IS
	GENERIC(word_width    : INTEGER := 16);	
	PORT   (data0, data1          : IN  STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
		    data2, data3          : IN  STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
			data_out              : OUT STD_LOGIC_VECTOR(word_width-1 DOWNTO 0);
			sel                   : IN  STD_LOGIC_VECTOR(1 DOWNTO 0));
END COMPONENT;

-- INTERNAL SIGNALS
SIGNAL pc_old   : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL pc_new   : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL mem_in   : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL instr    : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL mem_data : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL reg_rd1  : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL reg_rd2  : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL out_rd1  : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL out_rd2  : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL alu_res  : STD_LOGIC_VECTOR(15 DOWNTO 0);   
SIGNAL alu_out  : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL reg_a1   : STD_LOGIC_VECTOR(2  DOWNTO 0);
SIGNAL reg_a2   : STD_LOGIC_VECTOR(2  DOWNTO 0);
SIGNAL reg_a3   : STD_LOGIC_VECTOR(2  DOWNTO 0);
SIGNAL reg_wd3  : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL alu_scra : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL alu_scrb : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL signimm  : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL sllsign  : STD_LOGIC_VECTOR(15 DOWNTO 0);

-- Internal Constants
CONSTANT vcc    : STD_LOGIC := '1';
CONSTANT four   : STD_LOGIC_VECTOR(15 DOWNTO 0) := X"0004";

BEGIN
-- BUFFERS MAP
	bf_pc   : buffer_clk PORT MAP
				(clock=>clk, control=>PCEn   , buffer_in=>pc_old,  buffer_out=>pc_new);
	bf_instr: buffer_clk PORT MAP
				(clock=>clk, control=>IRWrite, buffer_in=>mem_in,  buffer_out=>instr);
	bf_data : buffer_clk PORT MAP
			   	(clock=>clk, control=>vcc    , buffer_in=>mem_in,  buffer_out=>mem_data);
	bf_regA : buffer_clk PORT MAP
			   	(clock=>clk, control=>vcc    , buffer_in=>reg_rd1, buffer_out=>out_rd1);
	bf_regB : buffer_clk PORT MAP
			   	(clock=>clk, control=>vcc    , buffer_in=>reg_rd2, buffer_out=>out_rd2);
	bf_ALU  : buffer_clk PORT MAP
			   	(clock=>clk, control=>vcc    , buffer_in=>alu_res, buffer_out=>alu_out);

-- MUX 2 MAP
	m2_adress: mux2 GENERIC MAP
				(word_width => 16)	
				    PORT MAP
				(data0=>pc_new           , data1=>alu_out          , data_out=>adress  , sel=>IorD);
	m2_reg_a3: mux2 GENERIC MAP
				(word_width => 3)
				    PORT MAP
				(data0=>instr(7 DOWNTO 5), data1=>instr(4 DOWNTO 2), data_out=>reg_a3  , sel=>RegDst);
	m2_wd3   : mux2 GENERIC MAP
				(word_width => 16)	
				    PORT MAP
				(data0=>mem_data         , data1=>alu_out          , data_out=>reg_wd3 , sel=>MemToReg);
	m2_srca  : mux2 GENERIC MAP
				(word_width => 16)	
				    PORT MAP
				(data0=>pc_new           , data1=>out_rd1          , data_out=>alu_scra, sel=>ALUSrcA);
	m2_pc_old: mux2 GENERIC MAP
				(word_width => 16)	
				    PORT MAP
				(data0=>alu_res          , data1=>alu_out          , data_out=>pc_old  , sel=>PCSrc);

-- MUX 4 MAP
	m4_srcb  : mux4 GENERIC MAP
				(word_width => 16)
				    PORT MAP
				(data0=>out_rd2, data1=>four, data2=>signimm, 
					data3=>sllsign, data_out=>alu_scrb, sel=>ALUSrcB);

-- SIGN EXTEND MAP
	sign_ex  : sign_extend PORT MAP
				(in5=>instr(4 DOWNTO 0), out16=>signimm);

-- ALU MAP
	alu_map  : alu PORT MAP
				(source_a=>alu_scra, source_b=>alu_scrb, alu_control=>ALUControl, zero=>zero_signal, result=>alu_res);

-- REGISTER FILE MAP
	reg_file : register_file PORT MAP 
				(clock=>clk, write_e3=>RegWrite, write_a3=>reg_a3, write_d3=>reg_wd3, 
					register_a1=>reg_a1, register_a2=>reg_a2, register_d1=>reg_rd1, register_d2=>reg_rd2);

-- INTERNAL SIGNAL MAP
	reg_a1  <= instr(10 DOWNTO  8);
	reg_a2  <= instr(7  DOWNTO  5);
	WD      <= out_rd2;
	op      <= instr(15 DOWNTO 10);
	funct   <= instr(4  DOWNTO  0);
	mem_in  <= RD;
	sllsign <= std_logic_vector(unsigned(signimm) sll 2);

END ARCHITECTURE;  
