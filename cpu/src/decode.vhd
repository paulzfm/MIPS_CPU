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
           out_op : out STD_LOGIC_VECTOR(4 downto 0);
           out_ctl_write_reg : out STD_LOGIC;
           out_ctl_write_mem : out STD_LOGIC;
           out_ctl_read_mem : out STD_LOGIC;
           out_ctl_alu_op : out STD_LOGIC_VECTOR(3 downto 0);
           out_ctl_imm_extend_size : out STD_LOGIC_VECTOR(2 downto 0);
           out_ctl_imm_extend_type : out STD_LOGIC;
           out_ctl_is_jump : out STD_LOGIC;
           out_ctl_is_branch : out STD_LOGIC;
           out_ctl_jump_reg : out STD_LOGIC_VECTOR(3 downto 0)           
        );
end decode;

architecture Behavioral of decode is
signal ra, rb, rc : STD_LOGIC_VECTOR(2 downto 0);
begin
    ra <= in_instruction(10 downto 8);
    rb <= in_instruction(7 downto 5);
    rc <= in_instruction(4 downto 2);
    out_op <= in_instruction(15 downto 11);

    process (in_instruction, ra, rb, rc, in_pc, in_pc_inc)
    begin
        case (in_instruction(15 downto 11))
            when "01001" =>
                -- addiu rx
                out_ra <= ra;
                out_rb <= "0000";
                out_rc <= ra;
                out_ctl_write_reg <= '1';
                out_ctl_write_mem <= '0';
                out_ctl_alu_op <= "0000";
                out_imm <= (others => '0');
                out_ctl_imm_extend_size <= "000";
                out_ctl_imm_extend_type <= '0';
            when "01000" =>
                -- addiu3 rx ry imm
                out_ra <= ra;
                out_rb <= "0000";
                out_rc <= rb;
                out_ctl_write_reg <= '1';
                out_ctl_write_mem <= '0';
                out_ctl_alu_op <= "0000";
                out_imm <= in_instruction(3 downto 0);
                out_ctl_imm_extend_size <= "000";
                out_ctl_imm_extend_type <= '0';
            when "01000" =>
                -- addiu3 rx ry imm
                out_ra <= ra;
                out_rb <= "0000";
                out_rc <= rb;
                out_ctl_write_reg <= '1';
                out_ctl_write_mem <= '0';
                out_ctl_alu_op <= "0000";
                out_imm <= in_instruction(3 downto 0);
                out_ctl_imm_extend_size <= "000";
                out_ctl_imm_extend_type <= '0';
        end case;
    end process;


end Behavioral;

