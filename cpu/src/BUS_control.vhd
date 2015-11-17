----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:12:44 11/17/2015 
-- Design Name: 
-- Module Name:    BUS_control - Behavioral 
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

entity BUS_control is
    Port ( bus1_addr : in  STD_LOGIC_VECTOR (17 downto 0);
           bus1_data_cpu : inout  STD_LOGIC_VECTOR (15 downto 0);
           bus1_data_serial : inout  STD_LOGIC_VECTOR (15 downto 0);
           bus1_data_key : in  STD_LOGIC_VECTOR (15 downto 0);
           bus1_data_vga : out  STD_LOGIC_VECTOR (15 downto 0));
end BUS_control;

architecture Behavioral of BUS_control is

begin


end Behavioral;

