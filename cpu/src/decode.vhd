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
           out_ra : out STD_LOGIC_VECTOR(3 downto 0);
           out_rb : out STD_LOGIC_VECTOR(3 downto 0);
           out_rc : out STD_LOGIC_VECTOR(3 downto 0);
           out_imm : out STD_LOGIC_VECTOR(15 downto 0);
           out_instruction_op : out STD_LOGIC_VECTOR(4 downto 0);
           out_ctl_write_reg : out STD_LOGIC;
           out_ctl_write_mem : out STD_LOGIC;
           out_ctl_read_mem : out STD_LOGIC;
           out_ctl_alu_op : out STD_LOGIC_VECTOR(3 downto 0);
           out_ctl_imm_extend_size : out STD_LOGIC_VECTOR(2 downto 0);
           out_ctl_imm_extend_type : out STD_LOGIC;
           out_ctl_is_jump : out STD_LOGIC;
           out_ctl_is_branch : out STD_LOGIC;
           out_use_imm : out STD_LOGIC;
           out_alumem_alu_res_equal_rz : out STD_LOGIC;
           out_memwb_wb_alu_mem : out STD_LOGIC;
           out_memwb_memalu_res_equal_rz : out STD_LOGIC
        );
end decode;

architecture Behavioral of decode is
signal ra, rb, rc, instruction_op : STD_LOGIC_VECTOR(2 downto 0);

begin
    ra <= in_instruction(10 downto 8);
    rb <= in_instruction(7 downto 5);
    rc <= in_instruction(4 downto 2);
    instruction_op <= in_instruction(15 downto 11);
    out_instruction_op <= in_instruction(15 downto 11);

    process (in_instruction, ra, rb, rc, in_pc, in_pc_inc, instruction_op)
    begin
        case (instruction_op) is
            when INSTRUCTION_ADDIU =>
                -- addiu rx
                out_ra <= ra;
                out_rb <= REG_NULL;
                out_rc <= ra;
                out_imm <= ZERO_8 & in_instruction(7 downto 0);
                out_instruction_op <= instruction_op;
                out_ctl_write_reg <= '1';
                out_memwb_memalu_res_equal_rz <= '1';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <= '0';
                out_ctl_alu_op <= ALU_ADD;
                out_ctl_imm_extend_size <= EXT_8;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';
                out_ctl_is_branch <= '0';
                out_use_imm <= '1';
                out_alumem_alu_res_equal_rz <= '1';
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_ADDIU3 =>
                -- addiu3 rx ry imm
                out_ra <= ra;
                out_rb <= REG_NULL;
                out_rc <= rb;
                out_imm <= ZERO_12 & in_instruction(3 downto 0);
                out_instruction_op <= instruction_op;
                out_ctl_write_reg <= '1';
                out_memwb_memalu_res_equal_rz <= '1';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <= '0';
                out_ctl_alu_op <= ALU_ADD;
                out_ctl_imm_extend_size <= EXT_4;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';
                out_ctl_is_branch <= '0';
                out_use_imm <= '1';
                out_alumem_alu_res_equal_rz <= '1';
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_ADDSP =>
                -- 01100
                case ra is 
                    when "011" =>
                        -- ADDSP 
                        out_ra <= REG_SP;
                        out_rb <= REG_NULL;
                        out_rc <= REG_SP;
                        out_imm <= ZERO_8 & in_instruction(7 downto 0);
                        out_instruction_op <= INSTRUCTION_RENAME_ADDSP;
                        out_ctl_write_reg <= '1';
                        out_memwb_memalu_res_equal_rz <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <= '0';
                        out_ctl_alu_op <= ALU_ADD;
                        out_ctl_imm_extend_size <= EXT_8;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';
                        out_ctl_is_branch <= '0';
                        out_use_imm <= '1';
                        out_alumem_alu_res_equal_rz <= '1';
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;

                    when others =>
                        null;
                end case;
            when INSTRUCTION_ADDU =>
                out_ra <= ra;
                out_rb <= rb;
                out_rc <= rc;
                out_imm <= ZERO_16;
                out_instruction_op <= instruction_op;
                out_ctl_write_reg <= '1';
                out_memwb_memalu_res_equal_rz <= '1';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <= '0';
                out_ctl_alu_op <= ALU_ADD;
                out_ctl_imm_extend_size <= EXT_3;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';
                out_ctl_is_branch <= '0';
                out_use_imm <= '0';
                out_alumem_alu_res_equal_rz <= '1';
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_ADDU =>
                case (instruction_op(1 downto 0)) is
                    when "01" =>
                        -- addu
                        out_ra <= ra;
                        out_rb <= rb;
                        out_rc <= ra;
                        out_imm <= ZERO_16;
                        out_instruction_op <= instruction_op;
                        out_ctl_write_reg <= '1';
                        out_memwb_memalu_res_equal_rz <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <= '0';
                        out_ctl_alu_op <= ALU_AND;
                        out_ctl_imm_extend_size <= EXT_3;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';
                        out_ctl_is_branch <= '0';
                        out_use_imm <= '0';
                        out_alumem_alu_res_equal_rz <= '1';
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when "11"
                        -- subu
                        out_ra <= ra;
                        out_rb <= rb;
                        out_rc <= rc;
                        out_imm <= ZERO_16;
                        out_instruction_op <= instruction_op;
                        out_ctl_write_reg <= '1';
                        out_memwb_memalu_res_equal_rz <= '1';
                        out_ctl_write_mem <= '0';
                        out_ctl_read_mem <= '0';
                        out_ctl_alu_op <= ALU_SUB;
                        out_ctl_imm_extend_size <= EXT_3;
                        out_ctl_imm_extend_type <= EXT_SIGNED;
                        out_ctl_is_jump <= '0';
                        out_ctl_is_branch <= '0';
                        out_use_imm <= '0';
                        out_alumem_alu_res_equal_rz <= '1';
                        out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
                    when others =>
                        null;
                end case;
            when INSTRUCTION_B =>
                out_ra <= REG_NULL;
                out_rb <= REG_NULL;
                out_rc <= REG_NULL;
                out_imm <= in_instruction(10 downto 0);
                out_instruction_op <= instruction_op;
                out_ctl_write_reg <= '0';
                out_memwb_memalu_res_equal_rz <= '0';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <= '0';
                out_ctl_alu_op <= ALU_ADD;
                out_ctl_imm_extend_size <= EXT_11;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';
                out_ctl_is_branch <= '1';
                out_use_imm <= '0';
                out_alumem_alu_res_equal_rz <= '0';
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when INSTRUCTION_BEQZ =>
                out_ra <= ra;
                out_rb <= REG_NULL;
                out_rc <= REG_NULL;
                out_imm <= in_instruction(7 downto 0);
                out_instruction_op <= instruction_op;
                out_ctl_write_reg <= '0';
                out_memwb_memalu_res_equal_rz <= '0';
                out_ctl_write_mem <= '0';
                out_ctl_read_mem <= '0';
                out_ctl_alu_op <= ALU_EQUAL_ZERO;
                out_ctl_imm_extend_size <= EXT_8;
                out_ctl_imm_extend_type <= EXT_SIGNED;
                out_ctl_is_jump <= '0';
                out_ctl_is_branch <= '1';
                out_use_imm <= '0';
                out_alumem_alu_res_equal_rz <= '0';
                out_memwb_wb_alu_mem <= WB_ALU_MEM_ALU;
            when others =>
                null;
        end case;
    end process;


end Behavioral;

