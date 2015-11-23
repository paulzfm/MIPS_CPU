----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:56:21 11/22/2015 
-- Design Name: 
-- Module Name:    predict - Behavioral 
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

entity predict is
    Port ( rst : in  STD_LOGIC;
           in_op : in  STD_LOGIC_VECTOR (4 downto 0);
           in_is_jump : in  STD_LOGIC;
           in_is_branch : in  STD_LOGIC;
           in_predict_res : in STD_LOGIC;
           in_jump_reg : in STD_LOGIC_VECTOR(3 downto 0);
           in_jump_reg_data : in STD_LOGIC_VECTOR(15 downto 0);
           in_alumem_rz : in STD_LOGIC_VECTOR(3 downto 0);
           in_alumem_alu_res_equal_rz : in STD_LOGIC;
           in_alumem_alu_res : STD_LOGIC_VECTOR(15 downto 0);
           in_memwb_rz : in STD_LOGIC_VECTOR(3 downto 0);
           in_memwb_alumem_res_equal_rz : in STD_LOGIC;
           in_memwb_alumem_res : in STD_LOGIC_VECTOR(15 downto 0);
           in_branch_imm : in STD_LOGIC_VECTOR(15 downto 0);
           out_jump_reg_data : out STD_LOGIC_VECTOR(15 downto 0);
           out_branch_imm : out STD_LOGIC_VECTOR(15 downto 0);
           out_ctl_predict : out STD_LOGIC_VECTOR(1 downto 0));
end predict;

architecture Behavioral of predict is

begin
    process (rst, in_op, in_is_jump, in_is_branch, in_predict_res, in_alumem_rz, 
        in_jump_reg, in_jump_reg_data, in_alumem_alu_res_equal_rz, in_memwb_alumem_res_equal_rz, 
        in_alumem_alu_res, in_memwb_rz, in_memwb_alumem_res, in_branch_imm)
    begin
        -- 00 select PC + 1
        -- 01 select PC + 1 + Imm
        -- 10 select register
        if (rst = '1')
        then
            out_ctl_predict <= "00";
        else
            if (in_is_jump = '1')
            then
                if (in_alumem_rz = in_jump_reg and in_alumem_alu_res_equal_rz = '1')
                then
                    out_jump_reg_data <= in_alumem_alu_res;
                elsif (in_memwb_rz = in_jump_reg and in_memwb_alumem_res_equal_rz = '1')
                then
                    out_jump_reg_data <= in_memwb_alumem_res;
                else
                    out_jump_reg_data <= in_jump_reg;
                end if;
                out_ctl_predict <= "10";
            else
                -- branch
                out_branch_imm <= in_branch_imm;
                if (in_op = INSTRUCTION_B)
                then
                    out_ctl_predict <= "01";
                else
                    if (in_predict_res = '1')
                    then
                        out_ctl_predict <= "01";
                    else
                        out_ctl_predict <= "00";
                    end if;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
