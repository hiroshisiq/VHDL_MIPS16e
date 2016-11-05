LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY full_adder1 IS
	PORT(source_a, source_b, carry_in : IN  STD_LOGIC;
		 result, carry_out            : OUT STD_LOGIC);
END ENTITY;

ARCHITECTURE baheave OF  full_adder1 IS
BEGIN
	result    <= (source_a XOR source_b) XOR carry_in;
	carry_out <= ((source_a XOR source_b) AND carry_in) OR (source_a AND source_b);
END ARCHITECTURE;