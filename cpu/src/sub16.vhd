----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:30:54 11/17/2015 
-- Design Name: 
-- Module Name:    sub16 - Behavioral 
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
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sub16 is
    Port ( in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           out_output : out  STD_LOGIC_VECTOR (15 downto 0);
           out_t : out STD_LOGIC);
end sub16;

architecture Behavioral of sub16 is
signal result : STD_LOGIC_VECTOR(16 downto 0);
begin
    out_output <= result(15 downto 0);
    out_t <= result(16);
    process (in_data_a, in_data_b)
    begin
        result <= (("0" & in_data_a) - ("0" & in_data_b));
    end process;
    

end Behavioral;

