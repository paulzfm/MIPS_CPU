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
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           in_pc_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           in_ram_addr : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data : in  STD_LOGIC_VECTOR (15 downto 0);
           in_rd : in  STD_LOGIC;
           in_wr : in  STD_LOGIC;
           out_data : out  STD_LOGIC_VECTOR (15 downto 0);
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
           ram1_serial_data : inout  STD_LOGIC_VECTOR (15 downto 0),

           -- serial ports
           serial_rdn : out  STD_LOGIC;
           serial_wrn : out  STD_LOGIC;
           serial_data_ready : in  STD_LOGIC;
           serial_tbre : in  STD_LOGIC;
           serial_tsre : in  STD_LOGIC);
end memory_controller;

architecture Behavioral of memory_controller is
    signal ram1_rd, ram1_wr, ram2_rd, ram2_wr : STD_LOGIC;
    signal ram1_in_addr, ram2_in_addr : STD_LOGIC_VECTOR (14 downto 0);
    signal ram1_in_data, ram2_in_data : STD_LOGIC_VECTOR (15 downto 0);
    signal ram1_out_data, ram2_out_data : STD_LOGIC_VECTOR (15 downto 0);
begin
    control : process(in_rd, in_wr, in_pc_addr, in_ram_addr, in_data)
    begin
        if in_ram_addr(15) = '0' then -- read or write instruction memory
            ram1_rd <= '0';
            ram1_wr <= '0';
            ram2_rd <= in_rd;
            ram2_wr <= in_wr;
            ram2_in_addr <= in_ram_addr(14 downto 0);
            ram2_in_data <= in_data;
        else -- no conflicts: fetch and access data memory
            ram1_rd <= in_rd;
            ram1_wr <= in_wr;
            ram1_in_addr <= in_ram_addr(14 downto 0);
            ram1_in_data <= in_data;
            ram2_rd <= '1'; -- fetch instruction
            ram2_wr <= '0';
            ram2_in_addr <= in_pc_addr(14 downto 0);
        end if;
    end process;

    output : process(ram1_out_data, ram2_out_data)
    begin
        if in_ram_addr(15) = '0' then -- read or write instruction memory
            out_data <= ram2_out_data;
        else -- access data memory
            out_data <= ram1_out_data;
        end if;
    end process;

    out_pc_ins <= ram2_out_data;

    ram1 : entity work.ram_controller port map (
        clk => clk,
        rst => rst,
        in_rd => ram1_rd,
        in_wr => ram1_wr,
        in_addr => ram1_in_addr,
        in_data => ram1_in_data,
        out_data => ram1_out_data,
        ram1_oe => ram1_oe,
        ram1_we => ram1_we,
        ram1_en => ram1_en,
        ram1_addr => ram1_addr,
        ram1_serial_data => ram1_serial_data,
        serial_rdn => serial_rdn,
        serial_wrn => serial_wrn,
        serial_data_ready => serial_data_ready,
        serial_tbre => serial_tbre,
        serial_tsre => serial_tsre
    );

    ram2 : entity work.ins_ram_controller port map (
        clk => clk,
        rst => rst,
        in_rd => ram2_rd,
        in_wr => ram2_wr,
        in_addr => ram2_in_addr,
        in_data => ram2_in_data,
        out_data => ram2_out_data,
        ram2_oe => ram2_oe,
        ram2_we => ram2_we,
        ram2_en => ram2_en,
        ram2_addr => ram2_addr,
        ram2_data => ram2_data
    );

end Behavioral;
