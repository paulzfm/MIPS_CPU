----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:27:37 11/17/2015 
-- Design Name: 
-- Module Name:    registers - Behavioral 
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

entity registers is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  addr_x : in  STD_LOGIC_VECTOR (2 downto 0);
           addr_y : in  STD_LOGIC_VECTOR (2 downto 0);
           addr_z : in  STD_LOGIC_VECTOR (2 downto 0);
           data_A : out  STD_LOGIC_VECTOR (15 downto 0);
           data_B : out  STD_LOGIC_VECTOR (15 downto 0);
           data_C : in  STD_LOGIC_VECTOR (15 downto 0));
end registers;

architecture Behavioral of registers is

begin


end Behavioral;

