----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:10:42 11/22/2015 
-- Design Name: 
-- Module Name:    ram_controller - Behavioral 
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

entity ram_controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           in_en : in  STD_LOGIC;
           in_wr : in  STD_LOGIC;
           in_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data : in  STD_LOGIC_VECTOR (15 downto 0);
           out_data : in  STD_LOGIC_VECTOR (15 downto 0);
           ram1_oe : out  STD_LOGIC;
           ram1_we : out  STD_LOGIC;
           ram1_en : out  STD_LOGIC;
           ram1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram1_serial_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           serial_rdn : out  STD_LOGIC;
           serial_wrn : out  STD_LOGIC;
           serial_data_ready : in  STD_LOGIC;
           serial_tbre : in  STD_LOGIC;
           serial_tsre : in  STD_LOGIC);
end ram_controller;

architecture Behavioral of ram_controller is

begin

end Behavioral;

