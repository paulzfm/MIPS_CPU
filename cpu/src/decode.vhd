----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:24:48 11/21/2015
-- Design Name:
-- Module Name:    decode - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decode is
    Port ( in_instruction : in  STD_LOGIC_VECTOR (15 downto 0);
           in_pc_inc : in STD_LOGIC_VECTOR(15 downto 0);
           --out_instruction_op : out STD_LOGIC_VECTOR(4 downto 0);
           out_ra : out STD_LOGIC_VECTOR(3 downto 0);
           out_rb : out STD_LOGIC_VECTOR(3 downto 0);
           out_rc : out STD_LOGIC_VECTOR(3 downto 0);
           out_ctl_write_reg : out STD_LOGIC;
           out_ctl_write_mem : out STD_LOGIC;
           out_ctl_read_mem : out STD_LOGIC;
           out_ctl_alu_op : out STD_LOGIC_VECTOR(3 downto 0);
           out_use_imm : out STD_LOGIC;
           out_imm : out STD_LOGIC_VECTOR(15 downto 0);
           out_ctl_imm_extend_size : out STD_LOGIC_VECTOR(2 downto 0);
           out_ctl_imm_extend_type : out STD_LOGIC;
           out_ctl_is_jump : out STD_LOGIC;--jrra jr
           out_ctl_is_b : out STD_LOGIC;--b
           out_ctl_is_branch_except_b : out STD_LOGIC;--branch
           out_alumem_alu_res_equal_rc : out STD_LOGIC;--forward
           out_memwb_wb_alu_mem : out STD_LOGIC;
           out_brk_return : out STD_LOGIC
        );
end decode;

architecture Behavioral of decode is
signal ra, rb, rc : STD_LOGIC_VECTOR(3 downto 0);
signal instruction_op : STD_LOGIC_VECTOR(4 downto 0);
signal signal_imm_3to16 : STD_LOGIC_VECTOR(15 downto 0);
signal signal_imm_4to16 : STD_LOGIC_VECTOR(15 downto 0);
signal signal_imm_5to16 : STD_LOGIC_VECTOR(15 downto 0);
signal signal_imm_8to16 : STD_LOGIC_VECTOR(15 downto 0);
signal signal_imm_11to16 : STD_LOGIC_VECTOR(15 downto 0);

begin
    ra <= "0" & in_instruction(10 downto 8);
    rb <= "0" & in_instruction(7 downto 5);
    rc <= "0" & in_instruction(4 downto 2);
    instruction_op <= in_instruction(15 downto 11);

    --imm n to 16
    signal_imm_3to16 <= "00000000000"&in_instruction(4 downto 2)&"00";
    signal_imm_4to16 <= "000000000000"&in_instruction(3 downto 0);
    signal_imm_5to16 <= "00000000000"&in_instruction(4 downto 0);
    signal_imm_8to16 <= "00000000"&in_instruction(7 downto 0);
    signal_imm_11to16 <= "00000"&in_instruction(10 downto 0);
    ----

    process (in_instruction, ra, rb, rc, in_pc_inc, instruction_op,
        signal_imm_3to16, signal_imm_4to16, signal_imm_5to16,
        signal_imm_8to16, signal_imm_11to16)
    begin
        case (instruction_op) is
            when INSTRUCTION_ADDIU =>
               -- addiu rx
               out_ra <= ra;
               out_rb <= REG_NULL;
               out_rc <= ra;
               out_ctl_write_reg <= '1';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='0';
               out_ctl_alu_op <= ALU_ADD;
               out_use_imm <= '1';
               out_imm <= signal_imm_8to16;
               out_ctl_imm_extend_size <= EXT_8;
               out_ctl_imm_extend_type <= EXT_SIGNED;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '0';--b
               out_ctl_is_branch_except_b <= '0';--branch
               out_alumem_alu_res_equal_rc <= '1';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_ADDIU3 =>
               -- addiu3 rx ry imm
               out_ra <= ra;
               out_rb <= REG_NULL;
               out_rc <= rb;
               out_ctl_write_reg <= '1';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='0';
               out_ctl_alu_op <= ALU_ADD;
               out_use_imm <= '1';
               out_imm <= signal_imm_4to16;
               out_ctl_imm_extend_size <= EXT_4;
               out_ctl_imm_extend_type <= EXT_SIGNED;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '0';--b
               out_ctl_is_branch_except_b <= '0';--branch
               out_alumem_alu_res_equal_rc <= '1';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_ADDSP =>
                -- 01100
                case (in_instruction(10 downto 8)) is
                    when "011" =>
                       -- ADDSP
                       out_ra <= REG_SP;
                       out_rb <= REG_NULL;
                       out_rc <= REG_SP;
                       out_ctl_write_reg <= '1';
                       out_ctl_write_mem <= '0';
                       out_ctl_read_mem <='0';
                       out_ctl_alu_op <= ALU_ADD;
                       out_use_imm <= '1';
                       out_imm <= signal_imm_8to16;
                       out_ctl_imm_extend_size <= EXT_8;
                       out_ctl_imm_extend_type <= EXT_SIGNED;
                       out_ctl_is_jump <= '0';--jrra jr
                       out_ctl_is_b <= '0';--b
                       out_ctl_is_branch_except_b <= '0';--branch
                       out_alumem_alu_res_equal_rc <= '1';--forward
                       out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "000" =>
                       -- BTEQZ
                       out_ra <= REG_T;
                       out_rb <= REG_NULL;
                       out_rc <= REG_NULL;
                       out_ctl_write_reg <= '0';
                       out_ctl_write_mem <= '0';
                       out_ctl_read_mem <='0';
                       out_ctl_alu_op <= ALU_EQUAL_ZERO;
                       out_use_imm <= '1';
                       out_imm <= signal_imm_8to16;
                       out_ctl_imm_extend_size <= EXT_8;
                       out_ctl_imm_extend_type <= EXT_SIGNED;
                       out_ctl_is_jump <= '0';--jrra jr
                       out_ctl_is_b <= '0';--b
                       out_ctl_is_branch_except_b <= '1';--branch
                       out_alumem_alu_res_equal_rc <= '0';--forward
                       out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "001" =>
                       -- BTNEZ
                       out_ra <= REG_T;
                       out_rb <= REG_NULL;
                       out_rc <= REG_NULL;
                       out_ctl_write_reg <= '0';
                       out_ctl_write_mem <= '0';
                       out_ctl_read_mem <='0';
                       out_ctl_alu_op <= ALU_NOT_EQUAL_ZERO;
                       out_use_imm <= '1';
                       out_imm <= signal_imm_8to16;
                       out_ctl_imm_extend_size <= EXT_8;
                       out_ctl_imm_extend_type <= EXT_SIGNED;
                       out_ctl_is_jump <= '0';--jrra jr
                       out_ctl_is_b <= '0';--b
                       out_ctl_is_branch_except_b <= '1';--branch
                       out_alumem_alu_res_equal_rc <= '0';--forward
                       out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "100" =>
                       -- MTSP
                       out_ra <= rb;
                       out_rb <= REG_NULL;
                       out_rc <= REG_SP;
                       out_ctl_write_reg <= '1';
                       out_ctl_write_mem <= '0';
                       out_ctl_read_mem <='0';
                       out_ctl_alu_op <= ALU_DATA_A;
                       out_use_imm <= '0';
                       out_imm <= signal_imm_8to16;
                       out_ctl_imm_extend_size <= EXT_8;
                       out_ctl_imm_extend_type <= EXT_SIGNED;
                       out_ctl_is_jump <= '0';--jrra jr
                       out_ctl_is_b <= '0';--b
                       out_ctl_is_branch_except_b <= '0';--branch
                       out_alumem_alu_res_equal_rc <= '1';--forward
                       out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when others =>
                        null;
                end case;
            when INSTRUCTION_AND =>
                case (in_instruction(4 downto 0)) is
                    when "01100" =>
                        --AND
                        out_ra <= ra;
                        out_rb <= rb;
                        out_rc <= ra;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_AND;
                        out_use_imm <= '0';
                        out_imm <= signal_imm_8to16;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "01010" =>
                        --CMP
                        out_ra <= ra;
                        out_rb <= rb;
                        out_rc <= REG_T;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_CMP;
                        out_use_imm <= '0';
                        out_imm <= signal_imm_8to16;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "01111" =>
                        --NOT
                        out_ra <= rb;
                        out_rb <= REG_NULL;
                        out_rc <= ra;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_NOT;
                        out_use_imm <= '0';
                        out_imm <= signal_imm_8to16;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "01101" =>
                        --OR
                        out_ra <= ra;
                        out_rb <= rb;
                        out_rc <= ra;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_OR;
                        out_use_imm <= '0';
                        out_imm <= signal_imm_8to16;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "00010" =>
                        --SLT
                        out_ra <= ra;
                        out_rb <= rb;
                        out_rc <= REG_T;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_SIGNED_CMP;
                        out_use_imm <= '0';
                        out_imm <= signal_imm_8to16;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
						  when "00000" =>
								case (in_instruction(7 downto 5)) is
								  when "110" =>
										--JALR
										out_ra <= ra;
										out_rb <= REG_NULL;
										out_rc <= REG_RA;
										out_ctl_write_reg <= '1';
										out_ctl_write_mem <= '0';
										out_ctl_read_mem <='0';
										out_ctl_alu_op <= ALU_DATA_B;
										out_use_imm <= '1';
										out_imm <= in_pc_inc;
										out_ctl_imm_extend_size <= EXT_NO;
										out_ctl_imm_extend_type <= EXT_SIGNED;
										out_ctl_is_jump <= '1';--jrra jr
										out_ctl_is_b <= '0';--b
										out_ctl_is_branch_except_b <= '0';--branch
										out_alumem_alu_res_equal_rc <= '0';--forward
										out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
								  when "000" =>
										--JR
										out_ra <= ra;
										out_rb <= REG_NULL;
										out_rc <= REG_NULL;
										out_ctl_write_reg <= '0';
										out_ctl_write_mem <= '0';
										out_ctl_read_mem <='0';
										out_ctl_alu_op <= ALU_DATA_B;
										out_use_imm <= '0';
										out_imm <= signal_imm_8to16;
										out_ctl_imm_extend_size <= EXT_NO;
										out_ctl_imm_extend_type <= EXT_SIGNED;
										out_ctl_is_jump <= '1';--jrra jr
										out_ctl_is_b <= '0';--b
										out_ctl_is_branch_except_b <= '0';--branch
										out_alumem_alu_res_equal_rc <= '0';--forward
										out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
								  when "001" =>
										--JRRA
										out_ra <= REG_RA;
										out_rb <= REG_NULL;
										out_rc <= REG_NULL;
										out_ctl_write_reg <= '0';
										out_ctl_write_mem <= '0';
										out_ctl_read_mem <='0';
										out_ctl_alu_op <= ALU_DATA_B;
										out_use_imm <= '0';
										out_imm <= signal_imm_8to16;
										out_ctl_imm_extend_size <= EXT_NO;
										out_ctl_imm_extend_type <= EXT_SIGNED;
										out_ctl_is_jump <= '1';--jrra jr
										out_ctl_is_b <= '0';--b
										out_ctl_is_branch_except_b <= '0';--branch
										out_alumem_alu_res_equal_rc <= '0';--forward
										out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
								  when "010" =>
										--MFPC
										out_ra <= REG_NULL;
										out_rb <= REG_NULL;
										out_rc <= ra;
										out_ctl_write_reg <= '1';
										out_ctl_write_mem <= '0';
										out_ctl_read_mem <='0';
										out_ctl_alu_op <= ALU_DATA_B;
										out_use_imm <= '1';
										out_imm <= in_pc_inc;
										out_ctl_imm_extend_size <= EXT_NO;
										out_ctl_imm_extend_type <= EXT_SIGNED;
										out_ctl_is_jump <= '0';--jrra jr
										out_ctl_is_b <= '0';--b
										out_ctl_is_branch_except_b <= '0';--branch
										out_alumem_alu_res_equal_rc <= '1';--forward
										out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
								  when others =>null;
								end case;
                    when others => null;
                end case;
            when INSTRUCTION_ADDU =>
                case (in_instruction(1 downto 0)) is
                    when "01" =>
                       -- addu
                       out_ra <= ra;
                       out_rb <= rb;
                       out_rc <= rc;
                       out_ctl_write_reg <= '1';
                       out_ctl_write_mem <= '0';
                       out_ctl_read_mem <='0';
                       out_ctl_alu_op <= ALU_ADD;
                       out_use_imm <= '0';
                       out_imm <= signal_imm_8to16;
                       out_ctl_imm_extend_size <= EXT_8;
                       out_ctl_imm_extend_type <= EXT_SIGNED;
                       out_ctl_is_jump <= '0';--jrra jr
                       out_ctl_is_b <= '0';--b
                       out_ctl_is_branch_except_b <= '0';--branch
                       out_alumem_alu_res_equal_rc <= '1';--forward
                       out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "11" =>
                       -- subu
                       out_ra <= ra;
                       out_rb <= rb;
                       out_rc <= rc;
                       out_ctl_write_reg <= '1';
                       out_ctl_write_mem <= '0';
                       out_ctl_read_mem <='0';
                       out_ctl_alu_op <= ALU_SUB;
                       out_use_imm <= '0';
                       out_imm <= signal_imm_8to16;
                       out_ctl_imm_extend_size <= EXT_8;
                       out_ctl_imm_extend_type <= EXT_SIGNED;
                       out_ctl_is_jump <= '0';--jrra jr
                       out_ctl_is_b <= '0';--b
                       out_ctl_is_branch_except_b <= '0';--branch
                       out_alumem_alu_res_equal_rc <= '1';--forward
                       out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when others =>
                        null;
                end case;
            when INSTRUCTION_B =>
               out_ra <= REG_NULL;
               out_rb <= REG_NULL;
               out_rc <= REG_NULL;
               out_ctl_write_reg <= '0';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='0';
               out_ctl_alu_op <= ALU_ADD;
               out_use_imm <= '1';
               out_imm <= signal_imm_11to16;
               out_ctl_imm_extend_size <= EXT_11;
               out_ctl_imm_extend_type <= EXT_SIGNED;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '1';--b
               out_ctl_is_branch_except_b <= '0';--branch
               out_alumem_alu_res_equal_rc <= '0';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_BEQZ =>
               out_ra <= ra;
               out_rb <= REG_NULL;
               out_rc <= REG_NULL;
               out_ctl_write_reg <= '0';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='0';
               out_ctl_alu_op <= ALU_EQUAL_ZERO;
               out_use_imm <= '1';
               out_imm <= signal_imm_8to16;
               out_ctl_imm_extend_size <= EXT_8;
               out_ctl_imm_extend_type <= EXT_SIGNED;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '0';--b
               out_ctl_is_branch_except_b <= '1';--branch
               out_alumem_alu_res_equal_rc <= '0';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_BNEZ =>
               out_ra <= ra;
               out_rb <= REG_NULL;
               out_rc <= REG_NULL;
               out_ctl_write_reg <= '0';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='0';
               out_ctl_alu_op <= ALU_NOT_EQUAL_ZERO;
               out_use_imm <= '1';
               out_imm <= signal_imm_8to16;
               out_ctl_imm_extend_size <= EXT_8;
               out_ctl_imm_extend_type <= EXT_SIGNED;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '0';--b
               out_ctl_is_branch_except_b <= '1';--branch
               out_alumem_alu_res_equal_rc <= '0';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_LI =>
               out_ra <= REG_NULL;
               out_rb <= REG_NULL;
               out_rc <= ra;
               out_ctl_write_reg <= '1';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='0';
               out_ctl_alu_op <= ALU_DATA_B;
               out_use_imm <= '1';
               out_imm <= signal_imm_8to16;
               out_ctl_imm_extend_size <= EXT_8;
               out_ctl_imm_extend_type <= EXT_ZERO;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '0';--b
               out_ctl_is_branch_except_b <= '0';--branch
               out_alumem_alu_res_equal_rc <= '1';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_LW =>
               out_ra <= ra;
               out_rb <= REG_NULL;
               out_rc <= rb;
               out_ctl_write_reg <= '1';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='1';
               out_ctl_alu_op <= ALU_ADD;
               out_use_imm <= '1';
               out_imm <= signal_imm_5to16;
               out_ctl_imm_extend_size <= EXT_5;
               out_ctl_imm_extend_type <= EXT_SIGNED;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '0';--b
               out_ctl_is_branch_except_b <= '0';--branch
               out_alumem_alu_res_equal_rc <= '0';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_MEM;
            when INSTRUCTION_LWSP =>
               out_ra <= REG_SP;
               out_rb <= REG_NULL;
               out_rc <= ra;
               out_ctl_write_reg <= '1';
               out_ctl_write_mem <= '0';
               out_ctl_read_mem <='1';
               out_ctl_alu_op <= ALU_ADD;
               out_use_imm <= '1';
               out_imm <= signal_imm_8to16;
               out_ctl_imm_extend_size <= EXT_8;
               out_ctl_imm_extend_type <= EXT_SIGNED;
               out_ctl_is_jump <= '0';--jrra jr
               out_ctl_is_b <= '0';--b
               out_ctl_is_branch_except_b <= '0';--branch
               out_alumem_alu_res_equal_rc <= '0';--forward
               out_memwb_wb_alu_mem <= WB_ALU_MEM_MEM;
            when INSTRUCTION_MFIH =>
                case (in_instruction(0 downto 0)) is
                    when "0" =>
                        --MFIH
                        out_ra <= REG_IH;
                        out_rb <= REG_NULL;
                        out_rc <= ra;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_DATA_A;
                        out_use_imm <= '0';
                        out_imm <= signal_imm_8to16;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "1" =>
                        --MTIH
                        out_ra <= ra;
                        out_rb <= REG_NULL;
                        out_rc <= REG_IH;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_DATA_A;
                        out_use_imm <= '0';
                        out_imm <= signal_imm_8to16;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when others => null;
                end case;
            when INSTRUCTION_NOP =>
                out_ra <= REG_NULL;
                out_rb <= REG_NULL;
                out_rc <= REG_NULL;
                out_ctl_write_reg <= '0';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <='0';
                out_ctl_alu_op <= ALU_DATA_A;
                out_use_imm <= '0';
                out_imm <= signal_imm_8to16;
                out_ctl_imm_extend_size <= EXT_8;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';--jrra jr
                out_ctl_is_b <= '0';--b
                out_ctl_is_branch_except_b <= '0';--branch
                out_alumem_alu_res_equal_rc <= '0';--forward
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_SLL =>
                case (in_instruction(1 downto 0)) is
                    when "00" =>
                        --SLL
                        out_ra <= rb;
                        out_rb <= REG_NULL;
                        out_rc <= ra;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_SLL;
                        out_use_imm <= '1';
                        out_imm <= signal_imm_3to16;
                        out_ctl_imm_extend_size <= EXT_3;
                        out_ctl_imm_extend_type <= EXT_ZERO;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "11" =>
                        --SRA
                        out_ra <= rb;
                        out_rb <= REG_NULL;
                        out_rc <= ra;
                        out_ctl_write_reg <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <='0';
                        out_ctl_alu_op <= ALU_SRA;
                        out_use_imm <= '1';
                        out_imm <= signal_imm_3to16;
                        out_ctl_imm_extend_size <= EXT_3;
                        out_ctl_imm_extend_type <= EXT_ZERO;
                        out_ctl_is_jump <= '0';--jrra jr
                        out_ctl_is_b <= '0';--b
                        out_ctl_is_branch_except_b <= '0';--branch
                        out_alumem_alu_res_equal_rc <= '1';--forward
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when others => null;
                end case;
            when INSTRUCTION_SW =>
                out_ra <= ra;
                out_rb <= rb;
                out_rc <= REG_NULL;
                out_ctl_write_reg <= '0';
                out_ctl_write_mem <= '1';
                out_ctl_read_mem <='0';
                out_ctl_alu_op <= ALU_ADD;
                out_use_imm <= '1';
                out_imm <= signal_imm_5to16;
                out_ctl_imm_extend_size <= EXT_5;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';--jrra jr
                out_ctl_is_b <= '0';--b
                out_ctl_is_branch_except_b <= '0';--branch
                out_alumem_alu_res_equal_rc <= '0';--forward
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_SWSP =>
                out_ra <= REG_SP;
                out_rb <= ra;
                out_rc <= REG_NULL;
                out_ctl_write_reg <= '0';
                out_ctl_write_mem <= '1';
                out_ctl_read_mem <='0';
                out_ctl_alu_op <= ALU_ADD;
                out_use_imm <= '1';
                out_imm <= signal_imm_5to16;
                out_ctl_imm_extend_size <= EXT_5;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';--jrra jr
                out_ctl_is_b <= '0';--b
                out_ctl_is_branch_except_b <= '0';--branch
                out_alumem_alu_res_equal_rc <= '0';--forward
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_MOVE =>
                out_ra <= rb;
                out_rb <= REG_NULL;
                out_rc <= ra;
                out_ctl_write_reg <= '1';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <='0';
                out_ctl_alu_op <= ALU_DATA_A;
                out_use_imm <= '0';
                out_imm <= signal_imm_5to16;
                out_ctl_imm_extend_size <= EXT_5;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';--jrra jr
                out_ctl_is_b <= '0';--b
                out_ctl_is_branch_except_b <= '0';--branch
                out_alumem_alu_res_equal_rc <= '1';--forward
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when others =>
                -- regard as nop
                out_ra <= REG_NULL;
                out_rb <= REG_NULL;
                out_rc <= REG_NULL;
                out_ctl_write_reg <= '0';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <='0';
                out_ctl_alu_op <= ALU_DATA_A;
                out_use_imm <= '0';
                out_imm <= signal_imm_8to16;
                out_ctl_imm_extend_size <= EXT_8;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';--jrra jr
                out_ctl_is_b <= '0';--b
                out_ctl_is_branch_except_b <= '0';--branch
                out_alumem_alu_res_equal_rc <= '0';--forward
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
        end case;

    end process;

    process(instruction_op)
    begin
        case (in_instruction) is
            when x"FFFF" =>
                out_brk_return <= '1';
            when others =>
                out_brk_return <= '0';
        end case;
    end process;

end Behavioral;
