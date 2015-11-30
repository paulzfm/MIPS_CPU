----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:33:27 11/30/2015 
-- Design Name: 
-- Module Name:    forward_decode - Behavioral 
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

entity forward_decode is
    Port ( in_decode_ra : in  STD_LOGIC_VECTOR (3 downto 0);
           in_decode_rb : in  STD_LOGIC_VECTOR (3 downto 0);
           in_decode_use_imm : in STD_LOGIC;
           in_states_idalu_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           in_states_alumem_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           in_states_idalu_alu_res_equal_rc : in  STD_LOGIC;
           in_states_alumem_alu_res_equal_rc : in  STD_LOGIC;
           out_forward_a : out  STD_LOGIC_VECTOR (1 downto 0);
           out_forward_b : out  STD_LOGIC_VECTOR (1 downto 0);
           out_forward_d : out  STD_LOGIC_VECTOR (1 downto 0)
           );
end forward_decode;

architecture Behavioral of forward_decode is

begin
    process (in_decode_ra, in_decode_rb, in_states_idalu_rc, in_states_alumem_rc, 
        in_states_idalu_alu_res_equal_rc, in_states_alumem_alu_res_equal_rc, in_decode_use_imm)
    begin
        -- 00 select origin A
        -- 01 select alu/memory data
        -- 10 select memory/wb data

        
        if (in_states_idalu_rc = in_decode_ra and in_states_idalu_alu_res_equal_rc = '1')
        then
            out_forward_a <= "01";
        elsif ((in_states_alumem_rc = in_decode_ra and in_states_alumem_alu_res_equal_rc = '1'))
        then
            out_forward_a <= "10";
        else
            out_forward_a <= "00";
        end if;

        if (in_states_idalu_rc = in_decode_rb and in_states_idalu_alu_res_equal_rc = '1')
        then
            out_forward_d <= "01";
        elsif ((in_states_alumem_rc = in_decode_rb and in_states_alumem_alu_res_equal_rc = '1'))
        then
            out_forward_d <= "10";
        else
            out_forward_d <= "00";
        end if;

        if (in_decode_use_imm = '1')
        then
            out_forward_b <= "11";
        elsif (in_states_idalu_rc = in_decode_rb and in_states_idalu_alu_res_equal_rc = '1')
        then
            out_forward_b <= "01";
        elsif ((in_states_alumem_rc = in_decode_rb and in_states_alumem_alu_res_equal_rc = '1'))
        then
            out_forward_b <= "10";
        else
            out_forward_b <= "00";
        end if;

    end process;
    --calc_out_forward_alu_a:
    --process (in_alumem_rc, in_idalu_ra,
    --    in_alumem_alu_res_equal_rc, in_memwb_wr_reg, in_memwb_rc )
    --begin
    --    -- 00 select origin A
    --    -- 01 select alu/memory data
    --    -- 10 select memory/wb data

        
    --        if (in_alumem_rc = in_idalu_ra and in_alumem_alu_res_equal_rc = '1')
    --        then
    --            out_forward_alu_a <= "01";
    --        elsif ((in_memwb_rc = in_idalu_ra and in_memwb_wr_reg = '1'))
    --        then
    --            out_forward_alu_a <= "10";
    --        else
    --            out_forward_alu_a <= "00";
    --        end if;
        
    --end process;


    --calc_out_forward_alu_b:
    --process ( in_alumem_rc, in_idalu_rb, in_idalu_use_imm_ry,
    --    in_memwb_wr_reg, in_alumem_alu_res_equal_rc, in_memwb_rc)
    --begin
    --    -- 00 select origin A
    --    -- 01 select alu/memory data
    --    -- 10 select memory/wb data
    --    -- 11 select imm
        
    --        if (in_idalu_use_imm_ry = '1')
    --        then
    --            out_forward_alu_b <= "11";
    --        elsif (in_alumem_rc = in_idalu_rb and in_alumem_alu_res_equal_rc = '1')
    --        then
    --            out_forward_alu_b <= "01";
    --        elsif (in_memwb_rc = in_idalu_rb and in_memwb_wr_reg = '1')
    --        then
    --            out_forward_alu_b <= "10";
    --        else
    --            out_forward_alu_b <= "00";
    --        end if;
        
    --end process;

    --calc_out_forward_alu_d:
    --process (in_alumem_rc, in_idalu_rd,
    --    in_alumem_alu_res_equal_rc, in_memwb_wr_reg, in_memwb_rc)
    --begin
    --    -- 00 select origin A
    --    -- 01 select alu/memory data
    --    -- 10 select memory/wb data

        
    --        if (in_alumem_rc = in_idalu_rd and in_alumem_alu_res_equal_rc = '1')
    --        then
    --            out_forward_alu_d <= "01";
    --        elsif ((in_memwb_rc = in_idalu_rd and in_memwb_wr_reg = '1'))
    --        then
    --            out_forward_alu_d <= "10";
    --        else
    --            out_forward_alu_d <= "00";
    --        end if;
        
    --end process;
end Behavioral;

