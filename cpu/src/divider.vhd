----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    00:15:20 11/26/2015
-- Design Name:
-- Module Name:    divider - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--   Frequency divider. f_out = f_in / 2.
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

entity divider is
    Port ( input : in  STD_LOGIC;
           output : out  STD_LOGIC);
end divider;

architecture Behavioral of divider is
    signal data : STD_LOGIC := '1';
begin
    ff : process(input)
    begin
        if rising_edge(input) then
            output <= data;
            data <= not data;
        end if;
    end process;

end Behavioral;
