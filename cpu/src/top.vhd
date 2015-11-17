----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:49:26 11/17/2015 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  oe1 : out  STD_LOGIC;
           oe2 : out  STD_LOGIC;
			  we1 : out  STD_LOGIC;
           we2 : out  STD_LOGIC;
			  en1 : out  STD_LOGIC;
           en2 : out  STD_LOGIC;
			  rdn : out  STD_LOGIC;
           wrn : out  STD_LOGIC;
			  bus1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           bus2_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           bus1_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           bus2_data : inout  STD_LOGIC_VECTOR (15 downto 0));
end top;

architecture Behavioral of top is

begin


end Behavioral;

