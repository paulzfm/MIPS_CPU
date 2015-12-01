----------------------------------------------------------------------------------
-- Company:
-- Engineer: Zhu Fengmin
--
-- Create Date:    21:10:42 11/22/2015
-- Design Name:
-- Module Name:    ram_controller - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--   RAM1 and Serial Controller.
--     when in_wr = '0' and in_rd = '0' then do nothing
--     when in_wr = '1' then write ram1 or serial (BF00)
--     otherwise (in_wr = '0' and in_rd = '1') read ram1 or serial (BF00) or serial control (BF01)
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
           in_rd : in  STD_LOGIC; -- '1': read, '0': not read
           in_wr : in  STD_LOGIC; -- '1': write, '0': not write
           in_addr : in  STD_LOGIC_VECTOR (14 downto 0);
           in_data : in  STD_LOGIC_VECTOR (15 downto 0);
           out_data : out  STD_LOGIC_VECTOR (15 downto 0);

           -- ram1 ports
           ram1_oe : out  STD_LOGIC;
           ram1_we : out  STD_LOGIC;
           ram1_en : out  STD_LOGIC;
           ram1_addr : out  STD_LOGIC_VECTOR (17 downto 0);
           ram1_serial_data : inout  STD_LOGIC_VECTOR (15 downto 0);

           -- serial ports
           serial_rdn : out  STD_LOGIC;
           serial_wrn : out  STD_LOGIC;
           serial_data_ready : in  STD_LOGIC;
           serial_tbre : in  STD_LOGIC;
           serial_tsre : in  STD_LOGIC;

           -- vga ports
           vga_data : out STD_LOGIC_VECTOR (15 downto 0);
           vga_addr : out STD_LOGIC_VECTOR (14 downto 0);
           vga_offset : out STD_LOGIC_VECTOR (14 downto 0);
           vga_data_clk : out STD_LOGIC := '0';
           vga_offset_clk : out STD_LOGIC := '0';

           -- keyboard ports
           kb_data : in STD_LOGIC_VECTOR (15 downto 0);
           kb_clk : out STD_LOGIC := '0';
           kb_en : out STD_LOGIC);
end ram_controller;

architecture Behavioral of ram_controller is
    type state_type is (s_init, s_rd_ram, s_rd_serial, s_rd_serial_ctl,
                        s_wr_ram, s_wr_serial, s_empty, s_rd_kb, s_wr_vga_data,
                        s_wr_vga_offset);
    signal state: state_type;
    signal ctl: STD_LOGIC_VECTOR (3 downto 0);
    signal write_ready: STD_LOGIC;
    signal write_addr: STD_LOGIC_VECTOR (15 downto 0) := x"0000"; -- vga addr
begin
    ram1_en <= '0';
    ram1_addr <= "000" & in_addr;
    ctl(0) <= in_wr; -- write?

    control : process(in_addr)
    begin
        case in_addr is
            when "011" & x"F00" => -- is serial
                ctl(3 downto 1) <= "001";
            when "011" & x"F01" => -- is serial control
                ctl(3 downto 1) <= "010";
            when "011" & x"F04" => -- is kb data
                ctl(3 downto 1) <= "011";
            when "011" & x"F05" => -- is kb control
                ctl(3 downto 1) <= "100";
            when "011" & x"F06" => -- is vga data
                ctl(3 downto 1) <= "101";
            when "011" & x"F07" => -- is vga addr
                ctl(3 downto 1) <= "110";
            when "011" & x"F08" => -- is vga offset
                ctl(3 downto 1) <= "111";
            when others => -- is ram
                ctl(3 downto 1) <= "000";
        end case;
    end process;

    wr_ready : process (serial_tsre, serial_tbre)
    begin
        if serial_tsre = '1' and serial_tbre = '1' then
            write_ready <= '1';
        else
            write_ready <= '0';
        end if;
    end process;

    transaction : process(clk, rst)
    begin
        if rst = '0' then -- reset
            state <= s_init;
            write_addr <= x"0000";
        elsif falling_edge(clk) then -- transaction
            case state is
                when s_init =>
                    if in_rd = '0' and in_wr = '0' then
                        state <= s_empty;
                        serial_rdn <= '1';
                        serial_wrn <= '1';
                        ram1_oe <= '1';
                        ram1_we <= '1';
                    else
                        case ctl is
                            when "0100" => -- read serial control
                                state <= s_rd_serial_ctl;
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_oe <= '1';
                                ram1_we <= '1';
                            when "0000" => -- read ram1
                                state <= s_rd_ram;
                                ram1_oe <= '0';
                                ram1_we <= '1';
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_serial_data <= (others => 'Z');
                            when "0001" => -- write ram1
                                state <= s_wr_ram;
                                ram1_oe <= '1';
                                ram1_we <= '1';
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_serial_data <= in_data;
                            when "0010" => -- read serial
                                state <= s_rd_serial;
                                serial_rdn <= '0';
                                serial_wrn <= '1';
                                ram1_serial_data <= (others => 'Z');
                                ram1_oe <= '1';
                                ram1_we <= '1';
                            when "0011" => -- write serial
                                state <= s_wr_serial;
                                serial_rdn <= '1';
                                serial_wrn <= '0';
                                ram1_serial_data <= x"00" & in_data(7 downto 0);
                                ram1_oe <= '1';
                                ram1_we <= '1';
                            when "0110" => -- read kb data
                                state <= s_rd_kb;
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_oe <= '1';
                                ram1_we <= '1';
                                kb_clk <= '0';
                                kb_en <= '1';
                            when "1000" => -- read kb control
                                state <= s_rd_kb_ctl;
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_oe <= '1';
                                ram1_we <= '1';
                            when "1011" => -- write vga data
                                state <= s_wr_vga_data;
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_oe <= '1';
                                ram1_we <= '1';
                                vga_data_clk <= '0';
                                vga_data <= in_data;
                                vga_addr <= write_addr(14 downto 0);
                            when "1101" => -- write vga addr
                                state <= s_empty;
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_oe <= '1';
                                ram1_we <= '1';
                                write_addr <= in_data;
                            when "1111" => -- write vga offset
                                state <= s_wr_vga_offset;
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_oe <= '1';
                                ram1_we <= '1';
                                vga_offset_clk <= '0';
                                vga_offset <= in_data(14 downto 0);
                            when others => null;
                        end case;
                    end if;
                when s_rd_serial_ctl =>
                    state <= s_init;
                    out_data <= (0 => write_ready, 1 => serial_data_ready, others => '0');
                when s_rd_kb =>
                    state <= s_init;
                    out_data <= kb_data;
                    kb_en <= '0';
                when s_rd_kb_ctl =>
                    state <= s_init;
                    out_data <= kb_data;
                when s_rd_serial =>
                    state <= s_init;
                    out_data <= ram1_serial_data;
                    serial_rdn <= '1';
                when s_wr_serial =>
                    state <= s_init;
                    serial_wrn <= '1';
                when s_rd_ram =>
                    state <= s_init;
                    out_data <= ram1_serial_data;
                when s_wr_ram =>
                    state <= s_init;
                    ram1_we <= '0';
                when s_wr_vga_data =>
                    state <= s_init;
                    vga_data_clk <= '1';
                when s_wr_vga_offset =>
                    state <= s_init;
                    vga_offset_clk <= '1';
                when s_empty =>
                    state <= s_init;
                when others => null;
            end case;
        end if;
    end process;

end Behavioral;
