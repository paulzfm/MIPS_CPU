library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RAMController is
    port (
        clk: in std_logic;
        rst: in std_logic;
        inputs: in std_logic_vector(15 downto 0); -- addr & data

        addr1: out std_logic_vector(17 downto 0) := (others => '0');
        data1: inout std_logic_vector(15 downto 0);
        oe1: out std_logic; -- output enabled
        we1: out std_logic; -- write enabled
        en1: out std_logic := '0'; -- enabled

        addr2: out std_logic_vector(17 downto 0) := (others => '0');
        data2: inout std_logic_vector(15 downto 0);
        oe2: out std_logic; -- output enabled
        we2: out std_logic; -- write enabled
        en2: out std_logic := '0'; -- enabled

        -- digits: 0,1,...,6 = a,b,...,g
        display1: out std_logic_vector(0 to 6);
        display2: out std_logic_vector(0 to 6);
        outputs: out std_logic_vector(15 downto 0)
    );
end RAMController;

architecture arch of RAMController is
    type state is (s_init, s_ready, s_write1, s_read1, s_write2, s_read2, s_end);
    signal current_state, next_state: state := s_init;
    signal counter: std_logic_vector(3 downto 0) := (others => '0');
    signal addr: std_logic_vector(17 downto 0) := (others => '0');
    signal data: std_logic_vector(15 downto 0) := (others => '0');
begin
    -- state machine
    process(current_state, inputs)
    begin
        case current_state is
            when s_init =>
                next_state <= s_addr;
                oe1 <= '1';
                we1 <= '1';
                en1 <= '1';
                oe2 <= '1';
                we2 <= '1';
                en2 <= '0';
                counter <= 0;
            when s_ready =>
                next_state <= s_write1;
                counter <= 1;
                addr <= "0000000000" & inputs(15 downto 8);
                data <= "00000000" & inputs(7 downto 0);
                addr1 <= addr;
                data1 <= data;
                we1 <= '0';
            when s_write1 =>
                if counter < 9 then
                    next_state <= s_write1;
                    counter <= counter + 1;
                    addr1 <= addr + counter - "1";
                    data1 <= data + counter - "1";
                else
                    next_state <= s_read1;
                    counter <= 0;
                    we1 <= '1';
                end if;
            when s_read1 =>
                if counter < 9 then
                    next_state <= s_read1;
                    counter <= counter + 1;
                    addr1 <= addr + counter - "1";
                else
                    next_state <= s_end;
                    counter <= 0;
                    we1 <= '1';
                end if;
            when others =>
                next_state <= s_end;
        end case;
    end process;

    -- transaction
    process(clk, rst)
    begin
        if rst = '0' then
            current_state <= s_init;
        elsif falling_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- state display
    process(current_state)
    begin
        case current_state is
            when s_init => display1 <= "1111110";
            when s_ready => display1 <= "0110000";
            when s_write1 => display1 <= "1101101";
            when s_read1 => display1 <= "1111001";
            when s_write2 => display1 <= "0110011";
            when s_read2 => display1 <= "1011011";
            when s_end => display1 <= "0011111";
            when others => display1 <= "0000000";
        end case;
    end process;

    -- counter display
    process(counter)
    begin
        case counter is
            when "0000" => display2 <= "1111110";
            when "0001" => display2 <= "0110000";
            when "0010" => display2 <= "1101101";
            when "0011" => display2 <= "1111001";
            when "0100" => display2 <= "0110011";
            when "0101" => display2 <= "1011011";
            when "0110" => display2 <= "0011111";
            when "0111" => display2 <= "1110000";
            when "1000" => display2 <= "1111111";
            when "1001" => display2 <= "1110011";
            --when 10 => display2 <= "1110111";
            when others => display2 <= "0000000";
        end case;
    end process;

    -- address and data display
    outputs(15 downto 8) <= addr(7 downto 0);
    outputs(7 downto 0) <= data(7 downto 0);
end arch;
