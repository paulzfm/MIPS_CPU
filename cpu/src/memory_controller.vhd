----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    16:05:26 11/24/2015
-- Design Name:
-- Module Name:    memory_controller - Behavioral
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

entity memory_controller is
    Port ( in_pc_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           in_ram_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           in_ram_data : in  STD_LOGIC_VECTOR (15 downto 0);
           in_rd : in  STD_LOGIC;
           in_wr : in  STD_LOGIC;
           out_ram_data : out  STD_LOGIC_VECTOR (15 downto 0);
           out_pc_ins : out  STD_LOGIC_VECTOR (15 downto 0);

           -- ram2 ports
           ram2_oe : out  STD_LOGIC;
           ram2_we : out  STD_LOGIC;
           ram2_en : out  STD_LOGIC;
           ram2_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_data : inout  STD_LOGIC_VECTOR (15 downto 0);

           -- ram1 ports
           ram1_oe : out  STD_LOGIC;
           ram1_we : out  STD_LOGIC;
           ram1_en : out  STD_LOGIC;
           ram1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram1_data : inout  STD_LOGIC_VECTOR (15 downto 0)
           );
end memory_controller;

architecture Behavioral of memory_controller is

begin
    ins : entity work.ins_ram_controller port map (
        
    );

end Behavioral;
