----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:20 11/17/2015 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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

entity CPU is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  rdn : out  STD_LOGIC;
           wrn : out  STD_LOGIC;
           bus1_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           bus2_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           bus1_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           bus2_data : inout  STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is

begin


end Behavioral;

