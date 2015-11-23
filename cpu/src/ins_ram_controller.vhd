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
--   RAM2 (Instruction RAM) Controller.
--     when in_wr = '0' and in_rd = '0' then do nothing
--     when in_wr = '1' then write ram2
--     otherwise (in_rd = '1' and in_wr = '0') read ram2
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
    type state_type is (s_init, s_rd, s_wr);
    signal state: state_type;
begin
    ram2_en <= '0';
    ram2_addr <= "00" & in_addr;

    transaction : process(clk, rst)
    begin
        if rst = '0' then -- reset
            state <= s_init;
        elsif rising_edge(clk) then -- transaction
            if in_rd = '0' and in_wr = '0' then -- disable
                out_data <= (others => 'Z');
            else
                case state is
                    when s_init =>
                        case in_wr is
                            when '0' => -- read ram2
                                state <= s_rd;
                                ram2_oe <= '0';
                                ram2_we <= '1';
                                ram2_data <= (others => 'Z');
                            when '1' => -- write ram2
                                state <= s_wr;
                                ram2_oe <= '1';
                                ram2_we <= '1';
                                ram2_data <= in_data;
                            when others => null;
                        end case;
                    when s_rd =>
                        state <= s_init;
                        out_data <= ram2_data;
                    when s_wr =>
                        state <= s_init;
                        ram2_we <= '0';
                    when others => null;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
