library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity RAMController is
    port (
        clk: in std_logic;
        rst: in std_logic;
        inputs: in std_logic_vector(15 downto 0); -- addr / data

        -- digits: 0,1,...,6 = a,b,...,g
        display1: out std_logic_vector(0 to 6);
        display2: out std_logic_vector(0 to 6);
        outputs: out std_logic_vector(15 downto 0); -- addr & data

        -- ram 1 ports
        ram1_addr: out std_logic_vector(17 downto 0) := (others => '0');
        ram1_data: inout std_logic_vector(15 downto 0);
        ram1_oe: out std_logic; -- output enabled
        ram1_we: out std_logic; -- write enabled
        ram1_en: out std_logic := '0'; -- enabled

        -- ram 2 ports
        ram2_addr: out std_logic_vector(17 downto 0) := (others => '0');
        ram2_data: inout std_logic_vector(15 downto 0);
        ram2_oe: out std_logic; -- output enabled
        ram2_we: out std_logic; -- write enabled
        ram2_en: out std_logic := '0' -- enabled
    );
end RAMController;

architecture arch of RAMController is
    type state is (s_init, s_read_addr, s_read_data, s_write1, s_ready1, s_read1, s_end);
    signal curr_state, next_state: state;
    signal count: std_logic_vector(3 downto 0) := (others => '0');
    signal start_addr: std_logic_vector(17 downto 0);
    signal start_data: std_logic_vector(15 downto 0);
    signal curr_addr: std_logic_vector(17 downto 0);
    signal curr_data: std_logic_vector(15 downto 0);
begin
    machine : process(curr_state)
    begin
        case curr_state is
            when s_init =>
                ram1_en <= '1';
                ram2_en <= '0';
                next_state <= s_read_addr;
            when s_read_addr =>
                start_addr <= "00" & inputs;
                next_state <= s_read_data;
            when s_read_data =>
                start_data <= inputs;
                ram1_oe <= '1';
                ram1_we <= '1';
                ram1_data <= start_data;
                ram1_addr <= start_addr;
                curr_data <= start_data;
                curr_addr <= start_addr;
                next_state <= s_write1;
            when s_write1 =>
                ram1_we <= '0';
                count <= count + "1";
                next_state <= s_ready1;
            when s_ready1 =>
                ram1_we <= '1';
                if count = "1010" then -- write ram1 done
                    ram1_oe <= '0';
                    ram1_data <= (others => 'Z');
                    ram1_addr <= start_addr;
                    count <= "0000";
                    next_state <= s_read1;
                else
                    ram1_data <= start_data + count;
                    ram1_addr <= start_addr + count;
                    ram1_data <= curr_data + count;
                    ram1_addr <= curr_addr + count;
                    next_state <= s_write1;
                end if;
            when s_read1 =>
                ram1_data <= (others => 'Z');
                ram1_addr <= start_addr + count;
                curr_addr <= start_addr + count;
                curr_data <= ram1_data;
                if count = "1010" then -- read ram1 done
                    next_state <= s_end;
                else
                    count <= count + "1";
                    next_state <= s_read1;
                end if;
            when others =>
                next_state <= s_end;
        end case;
    end process;

    transaction : process(clk, rst)
    begin
        if rst = '0' then
            curr_state <= s_init;
        elsif falling_edge(clk) then
            curr_state <= next_state;
        end if;
    end process;

    display : process(curr_state, count)
    begin
        case curr_state is
            when s_init => display1 <= "1011011"; display2 <= "0000001"; -- S-
            when s_read_addr => display1 <= "1011011"; display2 <= "1110111"; -- SA
            when s_read_data => display1 <= "1011011"; display2 <= "0111110"; -- Sd
            when s_write1 => display1 <= "0110000"; -- 1.
            when s_ready1 => display1 <= "0000001"; display2 <= "0000001"; -- --
            when s_read1 => display1 <= "0110000"; -- 1.
            when s_end => display1 <= "1001111"; display2 <= "0000001"; -- E-
            when others => display1 <= "0000000"; display2 <= "0000000"; --
        end case;
        if curr_state = s_write1 or curr_state = s_read1 then
            case count is
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
                when "1010" => display2 <= "1110111";
                when others => display2 <= "0000000";
            end case;
        end if;
    end process;

    outputs(15 downto 8) <= curr_addr(7 downto 0);
    outputs(7 downto 0) <= curr_data(7 downto 0);
end arch;
