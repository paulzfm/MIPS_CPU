----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:28:58 11/21/2015 
-- Design Name: 
-- Module Name:    center_controllor - Behavioral 
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

entity center_controllor is
    Port ( out_bubble_ifid : out  STD_LOGIC;
           out_bubble_idalu : out  STD_LOGIC;
           out_bubble_alumem : out  STD_LOGIC;
           out_bubble_memwb : out  STD_LOGIC;
           out_rst_ifid : out  STD_LOGIC;
           out_rst_idalu : out  STD_LOGIC;
           out_rst_alumem : out  STD_LOGIC;
           out_rst_memwb : out  STD_LOGIC;
           out_forward_alu_a : out  STD_LOGIC_VECTOR (1 downto 0);
           out_forward_alu_b : out  STD_LOGIC_VECTOR (1 downto 0);
           out_predict_err : out  STD_LOGIC;
           out_predict_res : out  STD_LOGIC;
           out_branch_alu_pc_imm : out  STD_LOGIC;
           in_alumem_instruction_op : in  STD_LOGIC_VECTOR (4 downto 0);
           in_alumem_rz : in  STD_LOGIC_VECTOR (3 downto 0);
           in_alumem_rz_data : in STD_LOGIC_VECTOR(15 downto 0);
           in_memwb_rz : in STD_LOGIC_VECTOR(3 downto 0);
           in_memwb_rz_data : in STD_LOGIC_VECTOR(15 downto 0);
           in_idalu_instruction_op : in  STD_LOGIC_VECTOR (4 downto 0);
           in_idalu_rx : in  STD_LOGIC_VECTOR (3 downto 0);
           in_idalu_ry : in  STD_LOGIC_VECTOR (3 downto 0);
           in_idalu_use_imm_ry : STD_LOGIC;
           in_alu_res : in  STD_LOGIC_VECTOR (15 downto 0);
		   in_key_interrupt : in  STD_LOGIC;

           clk : in  STD_LOGIC;
           rst : in STD_LOGIC);
end center_controllor;

architecture Behavioral of center_controllor is

signal pipeline_stop_time : integer range 0 to 15;
-- predict_res is data that whether next B is true or false
signal predict_res : STD_LOGIC;
-- is_alu_branch means that the id/alu states contains one instruction
-- of Branch.
signal is_alu_branch : STD_LOGIC;
-- predict_error means the predict_res is not equal to the alu result,
-- will output to out_predict_error as a control signal.
signal predict_error : STD_LOGIC;
-- is_alu_lw means that id/alu contains a instruction that will use register.
-- and alu/mem contains a lw instruction.
signal is_alu_lw : STD_LOGIC;

begin
    out_predict_res <= predict_res;
    out_predict_err <= predict_error;

    calc_is_alu_branch:
    process (rst, in_idalu_instruction_op)
    begin
        if (rst = '1')
        then
            is_alu_branch <= '0';
        else
            if (in_idalu_instruction_op = INSTRUCTION_BEQZ or 
                in_idalu_instruction_op = INSTRUCTION_BNEZ or 
                in_idalu_instruction_op = INSTRUCTION_BTEQZ or 
                in_idalu_instruction_op = INSTRUCTION_BTNEZ)
            then
                is_alu_branch <= '1';
            else
                is_alu_branch <= '0';
            end if;
        end if;
    end process;

    calc_predict_error:
    process (rst, in_alu_res, predict_res)
    begin
        if (rst = '1')
        then 
            predict_error <= '0';
        else
            if (predict_res /= in_alu_res(0) and is_alu_branch = '1')
            then
                predict_error <= '1';
            else
                predict_error <= '0';
            end if;
        end if;
    end process;

    calc_predict_res:
    process (rst, clk)
    begin
        if (rst = '1')
        then
            predict_res <= '0';
        else
            if (rising_edge(clk))
            then
                if (is_alu_branch = '1')
                then
                    predict_res <= in_alu_res(0);
                end if;
            end if;
        end if;
    end process;
    
    calc_is_alu_lw:
    process (rst, in_idalu_instruction_op, in_alumem_instruction_op, 
        in_alumem_rz, in_idalu_rx, in_idalu_ry)
    variable idalu_alu, alumem_lw, reg_same : STD_LOGIC;
    begin
        if (rst = '1')
        then
            is_alu_lw <= '0';
        else
            idalu_alu := '0';
            alumem_lw := '0';
            reg_same := '0';
            if (in_idalu_instruction_op = INSTRUCTION_NOT or
                in_idalu_instruction_op = INSTRUCTION_SLT or
                in_idalu_instruction_op = INSTRUCTION_ADDIU or
                in_idalu_instruction_op = INSTRUCTION_ADDIU3 or
                in_idalu_instruction_op = INSTRUCTION_ADDSP or
                in_idalu_instruction_op = INSTRUCTION_ADDU or
                in_idalu_instruction_op = INSTRUCTION_AND or
                in_idalu_instruction_op = INSTRUCTION_BEQZ or
                in_idalu_instruction_op = INSTRUCTION_BNEZ or
                in_idalu_instruction_op = INSTRUCTION_CMP or
                in_idalu_instruction_op = INSTRUCTION_JR or
                in_idalu_instruction_op = INSTRUCTION_OR or
                in_idalu_instruction_op = INSTRUCTION_SLL or
                in_idalu_instruction_op = INSTRUCTION_SRA or
                in_idalu_instruction_op = INSTRUCTION_SUBU or
                in_idalu_instruction_op = INSTRUCTION_SW or
                in_idalu_instruction_op = INSTRUCTION_SWSP
                )
            then
                idalu_alu := '1';
            end if;
            if (in_alumem_instruction_op = INSTRUCTION_LW)
            then
                alumem := '1';
            end if;

            if (in_alumem_rz = in_idalu_rx or in_alumem_rz = in_idalu_ry)
            then
                reg_same := '1';
            end if;

            if (idalu_alu = '1' and alumem_lw = '1' and reg_same = '1')
            then
                is_alu_lw <= '1';
            else
                is_alu_lw <= '0';
            end if;
        end if;
    end process;

    calc_out_forward_alu_a:
    process (rst, in_alumem_rz, in_idalu_rx, in_idalu_rx)
    begin
        -- 00 select origin A
        -- 01 select alu/memory data
        -- 10 select memory/wb data
        if (rst = '1')
        then
            out_forward_alu_a <= "00";
        else
            if (in_alumem_rz = in_idalu_rx)
            then
                out_forward_alu_a <= "01";
            elsif (in_memwb_rz = in_idalu_rx)
            then
                out_forward_alu_a <= "10";
            else
                out_forward_alu_a <= "00";
            end if;
        end if;
    end process;
    
    
    calc_out_forward_alu_b:
    process (rst, in_alumem_rz, in_idalu_rx, in_idalu_rx, in_idalu_use_imm_ry)
    begin
        -- 00 select origin A
        -- 01 select alu/memory data
        -- 10 select memory/wb data
        -- 11 select imm
        if (rst = '1')
        then
            out_forward_alu_b <= "00";
        else
            if (in_alumem_rz = in_idalu_rx)
            then
                out_forward_alu_b <= "01";
            elsif (in_memwb_rz = in_idalu_rx)
            then
                out_forward_alu_b <= "10";
            elsif (in_idalu_use_imm_ry = '1')
            then
                out_forward_alu_b <= "11";
            else
                out_forward_alu_b <= "00";
            end if;
        end if;
    end process;

    calc_out_bubble_ifid:
    process (rst, is_alu_lw)
    begin
        if (rst = '1')
        then
            out_bubble_ifid <= '0';
        else
            out_bubble_ifid <= is_alu_lw;
        end if;
    end process;

    calc_out_bubble_idalu:
    process (rst, is_alu_lw, predict_error)
    begin
        if (rst = '1')
        then
            out_bubble_idalu <= '0';
        else
            if (predict_error = '1')
            then
                out_bubble_idalu <= '1';
            elsif (is_alu_lw = '1')
            then
                out_bubble_idalu <= '1';
            else
                out_bubble_idalu <= '0';
            end if;
        end if;
    end process;

    calc_out_bubble_alu_mem:
    process (rst)
    begin
        if (rst = '1')
        then
            out_bubble_alumem <= '0';
        else
            out_bubble_alumem <= '0';
        end if;
    end process;

    calc_out_bubble_mem_wb:
    process (rst)
    begin
        if (rst = '1')
        then
            out_bubble_memwb <= '0';
        else
            out_bubble_memwb <= '0';
        end if;
    end process;


    calc_out_rst_ifid:
    process (rst)
    begin
        if (rst = '1')
        then
            out_rst_ifid <= '0';
        else
            out_rst_ifid <= '0';
        end if;
    end process;

    calc_out_rst_idalu:
    process (rst)
    begin
        if (rst = '1')
        then
            out_rst_idalu <= '0';
        else
            out_rst_idalu <= '0';
        end if;
    end process;

    calc_out_rst_alu_mem:
    process (rst, is_alu_lw)
    begin
        if (rst = '1')
        then
            out_rst_alumem <= '0';
        else
            if (is_alu_lw = '1')
            then
                out_rst_alumem <= '1';
            else
                out_rst_alumem <= '0';
            end if;
        end if;
    end process;

    calc_out_rst_memwb:
    process (rst)
    begin
        if (rst = '1')
        then
            out_rst_memwb <= '0';
        else
            out_rst_memwb <= '0';
        end if;
    end process;

    calc_out_branch_alu_pc_imm:
    process (rst)
    begin
        if (rst = '0')
        then
            out_branch_alu_pc_imm <= '0';
        else
            out_branch_alu_pc_imm <= in_alu_res(0);
        end if;
    end process;
    --process (rst, clk, in_ifid_instruction_op, in_idalu_instruction_op, in_idalu_rz, in_ifid_rx, in_ifid_ry, in_alu_res, in_key_interrupt)
    --begin
    --    if (rst = '0')
    --    then
    --    elsif (falling_down(clk))
    --    then
    --        -- update predict

    --    else
    --        -- error branch reset id alu
    --        -- ALU LW  bu bu reset
    --        -- read ser 
    --        -- write ser
    --        -- write instruction memory 

    --        -- out_bubble_ifid
    --        if (predict_error)
    --        then
    --            out_bubble_idalu <= '1';
    --        else
    --            out_bubble_idalu <= '0';
    --        end if;

    --        if (alu_lw_occur)
    --        then
    --            out_bubble_id
    --            -- idif  ifalu  aluwb 
    --        else
    --        end if;

            



    --    end if;
    --end process;



    
end Behavioral;

