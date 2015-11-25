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
           data_ready : in STD_LOGIC;
           tbre: in  STD_LOGIC;
           tsre: in  STD_LOGIC;
           ram1_oe : out  STD_LOGIC;
           ram2_oe : out  STD_LOGIC;
           ram1_we : out  STD_LOGIC;
           ram2_we : out  STD_LOGIC;
           ram1_en : out  STD_LOGIC;
           ram2_en : out  STD_LOGIC;
           rdn : out  STD_LOGIC;
           wrn : out  STD_LOGIC;
           ram1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram1_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_data : inout  STD_LOGIC_VECTOR (15 downto 0));
end top;

architecture Behavioral of top is
-- signal
-- cpu_out
signal cpu_out_pc : STD_LOGIC_VECTOR(15 downto 0);
signal cpu_out_mem_rdn, cpu_out_mem_wrn : STD_LOGIC;
signal cpu_out_mem_data, cpu_out_mem_addr : STD_LOGIC_VECTOR(15 downto 0);
-- cpu_in
signal cpu_in_mem_data, cpu_in_instruction_data : STD_LOGIC_VECTOR(15 downto 0);
-- debug


begin
cpu_instance : entity work.cpu port map(
        clk => clk,
        rst => rst,
        out_mem_rdn => cpu_out_mem_rdn,
        out_mem_wrn => cpu_out_mem_wrn,
        out_mem_data => cpu_out_mem_data,
        out_mem_addr => cpu_out_mem_addr,
        out_pc => cpu_out_pc,
        in_mem_data => cpu_in_mem_data,
        in_instruction_data => cpu_in_instruction_data,
        debug : out STD_LOGIC_VECTOR(127 downto 0)
    );
    
memory_controller_instance : entity work.memory_controller port map(
        clk => clk,
        rst => rst,
        in_pc_addr => cpu_out_pc;
        in_ram_addr => cpu_out_mem_addr,
        in_data => cpu_out_mem_data,
        in_rd => cpu_out_mem_rdn,
        in_wr => cpu_out_mem_wrn,
        out_data => cpu_in_mem_data,
        out_pc_ins => cpu_in_instruction_data,

        -- ram2 ports
        ram2_oe => ram2_oe,
        ram2_we => ram2_we, 
        ram2_en => ram2_en,
        ram2_addr => ram2_addr,
        ram2_data => ram2_data,

        -- ram1 ports
        ram1_oe => ram1_oe,
        ram1_we => ram1_we, 
        ram1_en => ram1_en,
        ram1_addr => ram1_addr,
        ram1_data => ram1_data,

        -- serial ports
        serial_rdn : out  STD_LOGIC;
        serial_wrn : out  STD_LOGIC;
        serial_data_ready : in  STD_LOGIC;
        serial_tbre : in  STD_LOGIC;
        serial_tsre : in  STD_LOGIC
    );
end Behavioral;
