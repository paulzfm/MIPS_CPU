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
    type state_type is (s_init, s_rd_ram, s_rd_serial_ctl, s_rd_serial, s_wr_ram, s_wr_serial);
    signal state: state_type;
    signal ctl: STD_LOGIC_VECTOR (2 downto 0);
    signal write_ready: STD_LOGIC;
begin
    ram1_en <= '0';
    ram1_addr <= "000" & in_addr;
    ctl(0) <= in_wr; -- write?

    control : process(in_addr)
    begin
        case in_addr is
            when "011" & x"F00" => -- is serial
                ctl(2 downto 1) <= "01";
            when "011" & x"F01" => -- is serial control
                ctl(2 downto 1) <= "10";
            when others => -- is ram
                ctl(2 downto 1) <= "00";
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
        elsif rising_edge(clk) then -- transaction
            if in_rd = '0' and in_wr = '0' then -- disable
                --out_data <= (others => 'Z');
            else
                case state is
                    when s_init =>
                        case ctl is
                            when "100" => -- serial control signal
                                state <= s_rd_serial_ctl;
                                ram1_serial_data <= (0 => write_ready, 1 => serial_data_ready, others => '0');
                            when "000" => -- read ram1
                                state <= s_rd_ram;
                                ram1_oe <= '0';
                                ram1_we <= '1';
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_serial_data <= (others => 'Z');
                            when "001" => -- write ram1
                                state <= s_wr_ram;
                                ram1_oe <= '1';
                                ram1_we <= '1';
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_serial_data <= in_data;
                            when "010" => -- read serial
                                state <= s_rd_serial;
                                serial_rdn <= '1';
                                serial_wrn <= '1';
                                ram1_serial_data <= (others => 'Z');
                                ram1_oe <= '1';
                                ram1_we <= '1';
                            when "011" => -- write serial
                                state <= s_wr_serial;
                                serial_rdn <= '1';
                                serial_wrn <= '0';
                                ram1_serial_data <= in_data;
                                ram1_oe <= '1';
                                ram1_we <= '1';
                            when others => null;
                        end case;
                    when s_rd_serial_ctl =>
                        state <= s_init;
                    when s_rd_serial =>
                        state <= s_init;
                        serial_rdn <= '0';
                    when s_wr_serial =>
                        state <= s_init;
                        serial_wrn <= '1';
                    when s_rd_ram =>
                        state <= s_init;
                        --out_data <= ram1_serial_data;
                    when s_wr_ram =>
                        state <= s_init;
                        ram1_we <= '0';
                    when others => null;
                end case;
            end if;
        end if;
    end process;

    out_data <= ram1_serial_data;

end Behavioral;
