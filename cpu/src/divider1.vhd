----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:48 11/26/2015 
-- Design Name: 
-- Module Name:    divider1 - Behavioral 
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

entity divider1 is
    Port ( en : in STD_LOGIC;
           clk : in  STD_LOGIC;
           clk_1hz : out  STD_LOGIC);
end divider1;

architecture Behavioral of divider1 is
    signal cnt : integer range 0 to 7 := 0;
begin
    process (clk)
    begin
        if rising_edge(clk) and en = '1' then
            if cnt = 7 then
                cnt <= 0;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process;
    
    process (cnt)
    begin
        if cnt = 0 then
            clk_1hz <= '1';
        elsif cnt = 4 then
            clk_1hz <= '0';
        end if;
    end process;

end Behavioral;

