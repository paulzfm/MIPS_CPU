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
           clk_50 : in STD_LOGIC;
           rst : in  STD_LOGIC;
           --keyboard
           datain,clkin: in std_logic;
           
           serial_data_ready : in STD_LOGIC;
           serial_tbre: in  STD_LOGIC;
           serial_tsre: in  STD_LOGIC;
           ram1_oe : out  STD_LOGIC;
           ram2_oe : out  STD_LOGIC;
           ram1_we : out  STD_LOGIC;
           ram2_we : out  STD_LOGIC;
           ram1_en : out  STD_LOGIC;
           ram2_en : out  STD_LOGIC;
           serial_rdn : out  STD_LOGIC;
           serial_wrn : out  STD_LOGIC;
           ram1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram2_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram1_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           ram2_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           debug : out STD_LOGIC_VECTOR(15 downto 0);
           debug_control_ins : in STD_LOGIC_VECTOR(15 downto 0);
           display1 : out STD_LOGIC_VECTOR(0 to 6);
           display2 : out STD_LOGIC_VECTOR(0 to 6));
end top;

architecture Behavioral of top is
-- signal
signal real_clk : STD_LOGIC;
signal cpu_clk : STD_LOGIC;
-- cpu_out
signal cpu_out_pc : STD_LOGIC_VECTOR(15 downto 0);
signal cpu_out_mem_rdn, cpu_out_mem_wrn : STD_LOGIC;
signal cpu_out_mem_data, cpu_out_mem_addr : STD_LOGIC_VECTOR(15 downto 0);
-- cpu_in
signal cpu_in_mem_data, cpu_in_instruction_data : STD_LOGIC_VECTOR(15 downto 0);
-- debug
signal debug_out_cpu, debug_out_mem : STD_LOGIC_VECTOR(15 downto 0);
signal ta, tb, tc, td, clk_40 : STD_LOGIC;
--keyboard
signal kb_in_rd_en, kb_in_rd_clk, kb_out_brk : STD_LOGIC;
signal kb_out_ascii : STD_LOGIC_VECTOR(7 downto 0);

begin
keyboard_instance : entity work.keyboard_top port map (
        datain => datain, 
        clkin => clkin, 
        fclk => clk_50, 
        rst_in => rst, 
        rd_en => kb_in_rd_en, 
        rd_clk => kb_in_rd_clk, 
        out_brk => kb_out_brk, 
        out_ascii => kb_out_ascii
     );

cpu_instance : entity work.cpu port map(
        clk => cpu_clk,
        rst => not rst,
        out_mem_rdn => cpu_out_mem_rdn,
        out_mem_wrn => cpu_out_mem_wrn,
        out_mem_data => cpu_out_mem_data,
        out_mem_addr => cpu_out_mem_addr,
        out_pc => cpu_out_pc,
        in_mem_data => cpu_in_mem_data,
        in_instruction_data => cpu_in_instruction_data,
        debug => debug_out_cpu,
        debug_control_ins => debug_control_ins,
        in_brk_come => kb_out_brk
    );

memory_controller_instance : entity work.memory_controller port map(
        clk => real_clk,
        rst => rst,
        in_pc_addr => cpu_out_pc,
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
        serial_rdn => serial_rdn,
        serial_wrn => serial_wrn,
        serial_data_ready => serial_data_ready,
        serial_tbre => serial_tbre,
        serial_tsre => serial_tsre,

        -- debug
        debug_in => debug_control_ins(3 downto 0),
        debug_out => debug_out_mem
    );

    disp1 : entity work.display7 port map (
        input => cpu_out_pc(7 downto 4),
        display => display1
    );

    disp2 : entity work.display7 port map (
        input => cpu_out_pc(3 downto 0),
        display => display2
    );

    divider : entity work.divider port map (
        input => real_clk,
        output => cpu_clk
    );
	 
--    divider1 : entity work.divider port map (
--        input => clk_50,
--        output => real_clk
--    );

     divider1 : entity work.divider1 port map (
         en => not clk,
         clk => clk_50,
         clk_1hz => real_clk
     );
--	 real_clk <= clk_40;
--	 divider222 : entity work.divider20 PORT MAP(
--		CLKIN_IN => clk_50,
--		CLKFX_OUT => clk_40,
--		CLKIN_IBUFG_OUT => ta,
--		CLK0_OUT => tb,
--		CLK2X_OUT => td
--	);


    output_debug : process (debug_control_ins)
    begin
        case debug_control_ins(15) is
            when '0' => debug <= debug_out_cpu;
            when '1' => debug <= debug_out_mem;
            when others => null;
        end case;
    end process;
end Behavioral;
