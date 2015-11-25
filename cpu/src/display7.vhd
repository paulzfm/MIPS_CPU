----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    20:39:14 11/24/2015
-- Design Name:
-- Module Name:    display7 - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--   Translate a hex (4 bits) into digit display.
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

entity display7 is
    Port ( input : in  STD_LOGIC_VECTOR (3 downto 0);
           display : out  STD_LOGIC_VECTOR (0 to 6));
end display7;

architecture Behavioral of display7 is

begin
    process (input)
    begin
        case input is
            when "0000" => display <= "1111110";
            when "0001" => display <= "0110000";
            when "0010" => display <= "1101101";
            when "0011" => display <= "1111001";
            when "0100" => display <= "0110011";
            when "0101" => display <= "1011011";
            when "0110" => display <= "0011111";
            when "0111" => display <= "1110000";
            when "1000" => display <= "1111111";
            when "1001" => display <= "1110011";
            when "1010" => display <= "1110111";
            when "1011" => display <= "0011111";
            when "1100" => display <= "1001110";
            when "1101" => display <= "0111101";
            when "1110" => display <= "1001111";
            when "1111" => display <= "1000111";
            when others => null;
        end case;
    end process;
end Behavioral;
