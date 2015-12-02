----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    19:35:26 12/01/2015
-- Design Name:
-- Module Name:    vga - Behavioral
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

entity vga is
    Port ( clk : in  STD_LOGIC; -- 50 MHz
           rst : in  STD_LOGIC;
           vga_data : in  STD_LOGIC_VECTOR (0 downto 0);
           vga_addr : in  STD_LOGIC_VECTOR (18 downto 0);
           --vga_offset : in  STD_LOGIC_VECTOR (14 downto 0);
           vga_data_clk : in  STD_LOGIC;
           --vga_offset_clk : in  STD_LOGIC;
           hs : out  STD_LOGIC;
           vs : out  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (0 to 2);
           g : out  STD_LOGIC_VECTOR (0 to 2);
           b : out  STD_LOGIC_VECTOR (0 to 2));
end vga;

architecture Behavioral of vga is
    signal rd_addr: STD_LOGIC_VECTOR (18 downto 0);
    signal pixel: STD_LOGIC_VECTOR (0 downto 0);
    signal clk_25: STD_LOGIC;
    --signal offset: STD_LOGIC_VECTOR (14 downto 0);
begin
    divider : entity work.divider port map (
        input => clk,
        output => clk_25
    );

    vga_controller : entity work.vga_controller port map (
        clk => clk_25,
        rst => not rst,
        hs => hs,
        vs => vs,
        r => r,
        g => g,
        b => b,
        addr => rd_addr,
        pixel => pixel(0)
        --offset => offset
    );

    vga_ram : entity work.vga_ram port map (
        clka => vga_data_clk,
        wea => "1",
        addra => vga_addr,
        dina => vga_data,
        clkb => not clk_25,
        addrb => rd_addr,
        doutb => pixel
    );

--    update_offset : process (vga_offset_clk)
--    begin
--        if rising_edge(vga_offset_clk) then
--            offset <= vga_offset;
--        end if;
--    end process;

end Behavioral;
