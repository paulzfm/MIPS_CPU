library IEEE;
use IEEE.STD_LOGIC_1164.all;

package constants is
    -- instruction op codes
    constant INSTRUCTION_ADDIU : STD_LOGIC_VECTOR(4 downto 0) := "01001";
    constant INSTRUCTION_ADDIU3 : STD_LOGIC_VECTOR(4 downto 0) := "01000";
    constant INSTRUCTION_ADDSP : STD_LOGIC_VECTOR(4 downto 0) := "01100";
    constant INSTRUCTION_ADDU : STD_LOGIC_VECTOR(4 downto 0) := "11100";
    constant INSTRUCTION_AND : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_B : STD_LOGIC_VECTOR(4 downto 0) := "00010";
    constant INSTRUCTION_BEQZ : STD_LOGIC_VECTOR(4 downto 0) := "00100";
    constant INSTRUCTION_BNEZ : STD_LOGIC_VECTOR(4 downto 0) := "00101";
    constant INSTRUCTION_BTEQZ : STD_LOGIC_VECTOR(4 downto 0) := "01100";
    constant INSTRUCTION_BTNEZ : STD_LOGIC_VECTOR(4 downto 0) := "01100";
    constant INSTRUCTION_CMP : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_JALR : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_JR : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_JRRA : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_LI : STD_LOGIC_VECTOR(4 downto 0) := "01101";
    constant INSTRUCTION_LW : STD_LOGIC_VECTOR(4 downto 0) := "10011";
    constant INSTRUCTION_LWSP : STD_LOGIC_VECTOR(4 downto 0) := "10010";
    constant INSTRUCTION_MFIH : STD_LOGIC_VECTOR(4 downto 0) := "11110";
    constant INSTRUCTION_MFPC : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_MTIH : STD_LOGIC_VECTOR(4 downto 0) := "11110";
    constant INSTRUCTION_MTSP : STD_LOGIC_VECTOR(4 downto 0) := "01100";
    constant INSTRUCTION_NOT : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_NOP : STD_LOGIC_VECTOR(4 downto 0) := "00001";
    constant INSTRUCTION_OR : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_SLL : STD_LOGIC_VECTOR(4 downto 0) := "00110";
    constant INSTRUCTION_SLT : STD_LOGIC_VECTOR(4 downto 0) := "11101";
    constant INSTRUCTION_SRA : STD_LOGIC_VECTOR(4 downto 0) := "00110";
    constant INSTRUCTION_SUBU : STD_LOGIC_VECTOR(4 downto 0) := "11100";
    constant INSTRUCTION_SW : STD_LOGIC_VECTOR(4 downto 0) := "11011";
    constant INSTRUCTION_SWSP : STD_LOGIC_VECTOR(4 downto 0) := "11010";

    constant REG_SP : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    constant REG_IH : STD_LOGIC_VECTOR(3 downto 0) := "1001";
    constant REG_T : STD_LOGIC_VECTOR(3 downto 0) := "1010";
    constant REG_RA : STD_LOGIC_VECTOR(3 downto 0) := "1100";

    constant EXT_3 : STD_LOGIC_VECTOR(2 downto 0) := "000";
    constant EXT_4 : STD_LOGIC_VECTOR(2 downto 0) := "001";
    constant EXT_5 : STD_LOGIC_VECTOR(2 downto 0) := "010";
    constant EXT_8 : STD_LOGIC_VECTOR(2 downto 0) := "011";
    constant EXT_11 : STD_LOGIC_VECTOR(2 downto 0) := "100";
    constant EXT_ZERO : STD_LOGIC := '0';
    constant EXT_SIGNED : STD_LOGIC := '1';
end constants;
