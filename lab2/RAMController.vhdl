library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RAMController is
    port (
        clk: in std_logic;
        rst: in std_logic;
        inputs: in std_logic_vector(15 downto 0);

        addr1: out std_logic_vector(17 downto 0);
        data1: inout std_logic_vector(15 downto 0);
        oe1: out std_logic; -- output enabled
        we1: out std_logic; -- write enabled
        en1: out std_logic := '0'; -- enabled

        addr2: out std_logic_vector(17 downto 0);
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
    type state is (s_init, s_addr, s_write1, s_read1, s_write2, s_read2, s_end);
    signal current_state, next_state: state;
    signal counter: integer range from 0 to 9;
    signal addr: std_logic_vector(17 downto 0);
    signal data: std_logic_vector(15 downto 0);
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
            when s_addr =>
                next_state <= s_write1;
                counter <= 0;
                addr1(15 downto 0) <= inputs;
                addr <= inputs;
            when s_write1 =>
                if counter = 0 then
                    next_state <= s_write1;
                    counter <= counter + 1;
                    data1(15 downto 0) <= inputs;
                    data <= inputs;
                    we1 <= '0';
                elsif counter < 9 then
                    next_state <= s_write1;
                    counter <= counter + 1;
                else
                    next_state <= s_read1;
                    counter <= 0;
                    we1 <= '1';
                end if;
            when s_read1 =>
                if counter = 0 then
                    next_state <= s_write1;
                    counter <= counter + 1;
                    data <= data1;
                    we1 <= '0';
                elsif counter < 9 then
                    next_state <= s_read1;
                    counter <= counter + 1;
                else
                    next_state <= s_end;
                    counter <= 0;
                    we1 <= '1';
                end if;
            others =>
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
        case current_state
        end case;
    end process;

    -- counter display
    process(counter)
    begin
        case counter
        end case;
    end process;

    -- address and data display
    outputs(15 downto 8) <= addr(7 downto 0);
    outputs(7 downto 0) <= data(7 downto 0);
end arch;
