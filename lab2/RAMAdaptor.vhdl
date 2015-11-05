library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RAMAdaptor is
    port (
        clk: in std_logic;

        addr: in std_logic_vector(17 downto 0);
        data_in: in std_logic_vector(15 downto 0);
        en: in std_logic;
        rd: in std_logic;

        data_out: out std_logic_vector(15 downto 0) := (others => '0');

        -- ram ports
        ram_addr: out std_logic_vector(17 downto 0);
        ram_data: inout std_logic_vector(15 downto 0);
        ram_oe: out std_logic; -- output enabled
        ram_we: out std_logic; -- write enabled
        ram_en: out std_logic := '0' -- enabled
    );
end entity;

architecture arch of RAMAdaptor is
begin
    en <= en;
    ram_addr <= addr;
    raw_we <= rd;
    raw_oe <= not rd;

    control_signals : process(rd)
    begin
        if rd = '0' then -- write
            raw_data <= data_in;
        else -- read
            raw_data <= (others => 'Z');
        end if;
    end process;

    data_output : process(clk, rd)
    begin
        if falling_edge(clk) then
            if rd = '0' then -- write
                data_out <= ram_data;
            else
                data_out <= data_in;
            end if;
        end if;
    end process;
end architecture;
