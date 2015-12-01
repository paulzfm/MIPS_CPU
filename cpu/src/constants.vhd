library IEEE;
use IEEE.STD_LOGIC_1164.all;

package constants is
    -- instruction op codes
    constant INSTRUCTION_ADDIU : STD_LOGIC_VECTOR(4 downto 0) := "01001";
    constant INSTRUCTION_ADDIU3 : STD_LOGIC_VECTOR(4 downto 0) := "01000";
    -- distinguish these four 01100 instructions by bits from 10 downto 8
    constant INSTRUCTION_ADDSP : STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- 011
    constant INSTRUCTION_BTEQZ : STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- 000
    constant INSTRUCTION_BTNEZ : STD_LOGIC_VECTOR(4 downto 0) := "01100"; -- 001
    constant INSTRUCTION_MTSP : STD_LOGIC_VECTOR(4 downto 0) := "01100";  -- 100
    -- constant INSTRUCTION_RENAME_ADDSP : STD_LOGIC_VECTOR(4 downto 0) := "01010";
    -- distinguish these two 11100 instructions by bit from 1 downto 1
    constant INSTRUCTION_ADDU : STD_LOGIC_VECTOR(4 downto 0) := "11100"; -- 0
    constant INSTRUCTION_SUBU : STD_LOGIC_VECTOR(4 downto 0) := "11100"; -- 1
    -- distinguish these nine 11101 instructions by bits from 3 downto 0
    constant INSTRUCTION_AND : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 1100
    constant INSTRUCTION_CMP : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 1010
    constant INSTRUCTION_NOT : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 1111
    constant INSTRUCTION_OR : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 1101
    constant INSTRUCTION_SLT : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 0010
        -- when 3 downto 0 = 0000, distinguish them by bits from 7 downto 5
        constant INSTRUCTION_JALR : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 110
        constant INSTRUCTION_JR : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 000
        constant INSTRUCTION_JRRA : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 001
        constant INSTRUCTION_MFPC : STD_LOGIC_VECTOR(4 downto 0) := "11101"; -- 010
    constant INSTRUCTION_B : STD_LOGIC_VECTOR(4 downto 0) := "00010";
    constant INSTRUCTION_BEQZ : STD_LOGIC_VECTOR(4 downto 0) := "00100";
    constant INSTRUCTION_BNEZ : STD_LOGIC_VECTOR(4 downto 0) := "00101";
    constant INSTRUCTION_LI : STD_LOGIC_VECTOR(4 downto 0) := "01101";
    constant INSTRUCTION_LW : STD_LOGIC_VECTOR(4 downto 0) := "10011";
    constant INSTRUCTION_LWSP : STD_LOGIC_VECTOR(4 downto 0) := "10010";
    -- distinguish these two 00110 instructions by the lowest bit (0 downto 0)
    constant INSTRUCTION_MFIH : STD_LOGIC_VECTOR(4 downto 0) := "11110"; -- 0
    constant INSTRUCTION_MTIH : STD_LOGIC_VECTOR(4 downto 0) := "11110"; -- 1
    -- constant INSTRUCTION_RENAME_MTSP : STD_LOGIC_VECTOR(4 downto 0) := "01011";
    constant INSTRUCTION_NOP : STD_LOGIC_VECTOR(4 downto 0) := "00001";
    -- distinguish these two 00110 instructions by the lowest bit (0 downto 0)
    constant INSTRUCTION_SLL : STD_LOGIC_VECTOR(4 downto 0) := "00110"; -- 0
    constant INSTRUCTION_SRA : STD_LOGIC_VECTOR(4 downto 0) := "00110"; -- 1
    constant INSTRUCTION_SW : STD_LOGIC_VECTOR(4 downto 0) := "11011";
    constant INSTRUCTION_SWSP : STD_LOGIC_VECTOR(4 downto 0) := "11010";

    -- register address
    constant REG_SP : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    constant REG_IH : STD_LOGIC_VECTOR(3 downto 0) := "1001";
    constant REG_T : STD_LOGIC_VECTOR(3 downto 0) := "1010";
    constant REG_RA : STD_LOGIC_VECTOR(3 downto 0) := "1100";
    constant REG_NULL : STD_LOGIC_VECTOR(3 downto 0) := "1111";

    -- alu op codes
    constant ALU_ADD : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant ALU_SUB : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant ALU_SLL : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant ALU_SRA : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant ALU_XOR : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant ALU_CMP : STD_LOGIC_VECTOR(3 downto 0) := "0101";
    constant ALU_SIGNED_CMP : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    constant ALU_UNSIGNED_CMP : STD_LOGIC_VECTOR(3 downto 0) := "0111";
    constant ALU_DATA_A : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    constant ALU_DATA_B : STD_LOGIC_VECTOR(3 downto 0) := "1001";
    constant ALU_NOT : STD_LOGIC_VECTOR(3 downto 0) := "1010";
    constant ALU_EQUAL_ZERO : STD_LOGIC_VECTOR(3 downto 0) := "1011";
    constant ALU_NOT_EQUAL_ZERO : STD_LOGIC_VECTOR(3 downto 0) := "1100";
    constant ALU_OR : STD_LOGIC_VECTOR(3 downto 0) := "1101";
	 constant ALU_AND : STD_LOGIC_VECTOR(3 downto 0) := "1110";

    -- extend sizes
    constant EXT_3 : STD_LOGIC_VECTOR(2 downto 0) := "000";
    constant EXT_4 : STD_LOGIC_VECTOR(2 downto 0) := "001";
    constant EXT_5 : STD_LOGIC_VECTOR(2 downto 0) := "010";
    constant EXT_8 : STD_LOGIC_VECTOR(2 downto 0) := "011";
    constant EXT_11 : STD_LOGIC_VECTOR(2 downto 0) := "100";
    constant EXT_NO : STD_LOGIC_VECTOR(2 downto 0) := "111";

    -- extend types
    constant EXT_ZERO : STD_LOGIC := '0';
    constant EXT_SIGNED : STD_LOGIC := '1';

    -- forward types
    constant WB_ALU_MEM_ALU : STD_LOGIC := '0';
    constant WB_ALU_MEM_MEM : STD_LOGIC := '1';

    -- zeros
    constant ZERO_16 : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000000";
    constant ZERO_15 : STD_LOGIC_VECTOR(14 downto 0) := "000000000000000";
    constant ZERO_14 : STD_LOGIC_VECTOR(13 downto 0) := "00000000000000";
    constant ZERO_13 : STD_LOGIC_VECTOR(12 downto 0) := "0000000000000";
    constant ZERO_12 : STD_LOGIC_VECTOR(11 downto 0) := "000000000000";
    constant ZERO_11 : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";
    constant ZERO_10 : STD_LOGIC_VECTOR(9 downto 0) := "0000000000";
    constant ZERO_8 : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
    constant ZERO_5 : STD_LOGIC_VECTOR(4 downto 0) := "00000";

    constant SIGNAL_ONE : STD_LOGIC_VECTOR(15 downto 0) := "0000000000000001";
end constants;
