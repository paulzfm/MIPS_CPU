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
           in_is_jump_ra : in STD_LOGIC;
           in_predict_res : in STD_LOGIC;
           in_forward_ra_reg : in STD_LOGIC_VECTOR(3 downto 0);
           out_ctl_predict : out STD_LOGIC_VECTOR(1 downto 0));
end predict;

architecture Behavioral of predict is

begin
    process (rst, in_op, in_is_jump, in_is_branch, in_predict_res)
    begin
        -- 00 select PC + 1
        -- 01 select PC + 1 + Imm
        -- 10 select register
        -- 11 select ra register
        if (rst = '1')
        then
            out_ctl_predict <= "00";
        else
            if (in_is_jump = '1')
            then
                if (in_is_jump_ra = '1') then
                    out_ctl_predict <= "11";
                else
                    out_ctl_predict <= "10";
                end if;
            else
                -- branch
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

