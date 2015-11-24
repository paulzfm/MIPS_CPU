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
           in_is_jump : in  STD_LOGIC;
           in_is_b : in  STD_LOGIC;
           in_is_branch_except_b : in STD_LOGIC;
           in_predict_res : in STD_LOGIC;
           in_jump_reg : in STD_LOGIC_VECTOR(3 downto 0);
           in_jump_reg_data : in STD_LOGIC_VECTOR(15 downto 0);
           in_idalu_alu_res_equal_rc : in STD_LOGIC;
           in_idalu_rc : in STD_LOGIC_VECTOR(3 downto 0);
           in_alu_res : in STD_LOGIC_VECTOR(15 downto 0);
           in_alumem_rc : in STD_LOGIC_VECTOR(3 downto 0);
           in_alumem_alu_res_equal_rc : in STD_LOGIC;
           in_alumem_alu_res : in STD_LOGIC_VECTOR(15 downto 0);
           in_memwb_rc : in STD_LOGIC_VECTOR(3 downto 0);
           in_memwb_alumem_res_equal_rc : in STD_LOGIC;
           in_memwb_alumem_res : in STD_LOGIC_VECTOR(15 downto 0);
           in_branch_imm : in STD_LOGIC_VECTOR(15 downto 0);
           out_jump_reg_data : out STD_LOGIC_VECTOR(15 downto 0);
           out_branch_imm : out STD_LOGIC_VECTOR(15 downto 0);
           out_ctl_predict : out STD_LOGIC_VECTOR(1 downto 0));
end predict;

architecture Behavioral of predict is

begin
    process (rst, in_is_jump, in_is_b, in_is_branch_except_b, 
        in_predict_res, in_jump_reg, in_jump_reg_data, in_idalu_alu_res_equal_rc, 
        in_idalu_rc, in_alu_res, in_alumem_rc, in_alumem_alu_res_equal_rc, 
        in_alumem_alu_res, in_memwb_rc, in_memwb_alumem_res_equal_rc, 
        in_memwb_alumem_res, in_branch_imm)
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
                if (in_idalu_rc = in_jump_reg and in_idalu_alu_res_equal_rc = '1')
                then
                    out_jump_reg_data <= in_alu_res;
                elsif (in_alumem_rc = in_jump_reg and in_alumem_alu_res_equal_rc = '1')
                then
                    out_jump_reg_data <= in_alumem_alu_res;
                elsif (in_memwb_rc = in_jump_reg and in_memwb_alumem_res_equal_rc = '1')
                then
                    out_jump_reg_data <= in_memwb_alumem_res;
                else
                    out_jump_reg_data <= in_jump_reg_data;
                end if;
                out_ctl_predict <= "10";
            elsif (in_is_b = '1')
            then
                out_branch_imm <= in_branch_imm;
                out_ctl_predict <= "01";
            elsif (in_is_branch_except_b = '1')
                out_branch_imm <= in_branch_imm;
                if (in_predict_res = '1')
                then
                    out_ctl_predict <= "01";
                else
                    out_ctl_predict <= "00";
                end if;
            end if;
        end if;
    end process;

end Behavioral;

