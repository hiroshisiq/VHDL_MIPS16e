LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mips16e IS
	PORT(clk, reset        : IN  STD_LOGIC;
		 instruction       : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc                : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);

		);