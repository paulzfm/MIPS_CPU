----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:25:57 11/23/2015 
-- Design Name: 
-- Module Name:    ins_ram_controller - Behavioral 
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

entity ins_ram_controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           in_rd : in  STD_LOGIC;
           in_wr : in  STD_LOGIC;
           in_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data : in  STD_LOGIC_VECTOR (15 downto 0);
           out_data : out  STD_LOGIC_VECTOR (15 downto 0);
           ram2_oe : out  STD_LOGIC;
           ram2_we : out  STD_LOGIC;
           ram2_en : out  STD_LOGIC;
           ram2_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_data : inout  STD_LOGIC_VECTOR (15 downto 0));
end ins_ram_controller;

architecture Behavioral of ins_ram_controller is

begin


end Behavioral;

