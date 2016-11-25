-- ARITHMETIC LOGIC UNIT CONSTANTS PACKAGE

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

package alu_package is
  CONSTANT ALU_AND1    : STD_LOGIC_VECTOR(2 DOWNTO 1) := "000";
  CONSTANT ALU_OR1     : STD_LOGIC_VECTOR(2 DOWNTO 1) := "001";
  CONSTANT ALU_SUM     : STD_LOGIC_VECTOR(2 DOWNTO 1) := "010";
  CONSTANT ALU_NOTUSED : STD_LOGIC_VECTOR(2 DOWNTO 1) := "011";
  CONSTANT ALU_AND2    : STD_LOGIC_VECTOR(2 DOWNTO 1) := "100";
  CONSTANT ALU_OR2     : STD_LOGIC_VECTOR(2 DOWNTO 1) := "101";
  CONSTANT ALU_SUB     : STD_LOGIC_VECTOR(2 DOWNTO 1) := "110";
  CONSTANT ALU_SLT     : STD_LOGIC_VECTOR(2 DOWNTO 1) := "111";
end alu_package;
