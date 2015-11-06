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
        ram1_addr: out std_logic_vector(17 downto 0);
        ram1_data: inout std_logic_vector(15 downto 0);
        ram1_oe: out std_logic; -- output enabled
        ram1_we: out std_logic; -- write enabled
        ram1_en: out std_logic := '0'; -- enabled

        -- ram 2 ports
        ram2_addr: out std_logic_vector(17 downto 0) := (others => '0');
        ram2_data: inout std_logic_vector(15 downto 0);
        ram2_oe: out std_logic; -- output enabled
        ram2_we: out std_logic; -- write enabled
        ram2_en: out std_logic := '0'; -- enabled
        
        -- set it as '1'
        rdn: out std_logic := '1'
    );
end RAMController;

architecture arch of RAMController is
    type state is (s_init, s_read_addr, s_read_data, 
                   s_write1, s_wready1, s_read1, s_rready1, 
                   s_write2, s_wready2, s_read2, s_rready2,
                   s_end);
    signal curr_state, next_state: state;
    signal curr_count, next_count: integer range 0 to 10;
    
    signal curr_addr: std_logic_vector(17 downto 0);
    signal curr_data: std_logic_vector(15 downto 0);
begin
    machine : process(curr_state, curr_count)
        variable start_addr: std_logic_vector(17 downto 0);
        variable start_data: std_logic_vector(15 downto 0);
    begin
        case curr_state is
            when s_init =>
                rdn <= '1';
                ram1_en <= '0';
                ram2_en <= '0';
                next_state <= s_read_addr;
                next_count <= 0;
            when s_read_addr =>
                start_addr := ("00" & inputs);
                next_state <= s_read_data;
                next_count <= 0;
            when s_read_data =>
                start_data := inputs;
                ram1_oe <= '1';
                ram1_we <= '1';
                curr_data <= start_data;
                curr_addr <= start_addr;
                ram1_data <= start_data;
                ram1_addr <= start_addr;
                next_state <= s_write1;
                next_count <= 0;
            when s_write1 =>
                ram1_we <= '0';
                ram1_oe <= '1';
                if curr_count = 9 then -- write ram1 done, ready to read
                    next_state <= s_rready1;
                    next_count <= 0;
                else
                    next_state <= s_wready1;
                    next_count <= curr_count + 1;
                end if;
            when s_wready1 =>
                curr_data <= start_data + conv_std_logic_vector(curr_count, 16);
                curr_addr <= start_addr + conv_std_logic_vector(curr_count, 18);
                ram1_we <= '1';
                ram1_oe <= '1';
                ram1_data <= curr_data;
                ram1_addr <= curr_addr;
                next_state <= s_write1;
                next_count <= curr_count;
            when s_read1 =>
                ram1_oe <= '0';
                ram1_we <= '1';
                curr_data <= ram1_data;
                if curr_count = 9 then -- read ram1 done, ready to write ram2
                    next_state <= s_wready2;
                    ram2_en <= '1';
                    next_count <= 0;
                else
                    next_state <= s_rready1;
                    next_count <= curr_count + 1;
                end if;
            when s_rready1 =>
                ram1_oe <= '0';
                ram1_we <= '1';
                curr_addr <= start_addr + conv_std_logic_vector(curr_count, 18);
                ram1_addr <= curr_addr;
                ram1_data <= (others => 'Z');
                next_state <= s_read1;
                next_count <= curr_count;
                
            when s_write2 =>
                ram2_we <= '0';
                ram2_oe <= '1';
                if curr_count = 9 then -- write ram2 done, ready to read
                    next_count <= 0;
                    next_state <= s_rready2;
                else
                    next_count <= curr_count + 1;
                    next_state <= s_wready2;
                end if;
            when s_wready2 =>
                curr_data <= start_data + conv_std_logic_vector(curr_count - 1, 16);
                curr_addr <= start_addr + conv_std_logic_vector(curr_count, 18);
                ram2_we <= '1';
                ram2_oe <= '1';
                ram2_data <= curr_data;
                ram2_addr <= curr_addr;
                next_state <= s_write2;
                next_count <= curr_count;
            when s_read2 =>
                ram2_oe <= '0';
                ram2_we <= '1';
                curr_data <= ram2_data;
                if curr_count = 9 then -- read ram2 done
                    next_state <= s_end;
                    next_count <= 0;
                else
                    next_state <= s_rready2;
                    next_count <= curr_count + 1;
                end if;
            when s_rready2 =>
                ram2_oe <= '0';
                ram2_we <= '1';
                curr_addr <= start_addr + conv_std_logic_vector(curr_count, 18);
                ram2_addr <= curr_addr;
                ram2_data <= (others => 'Z');
                next_state <= s_read2;
                next_count <= curr_count;
                
            when others =>
                next_state <= s_end;
                next_count <= 0;
        end case;
    end process;

    transaction : process(clk, rst)
    begin
        if rst = '0' then
            curr_state <= s_init;
            curr_count <= 0;
        elsif falling_edge(clk) then
            curr_state <= next_state;
            curr_count <= next_count;
        end if;
    end process;

    display : process(curr_state, curr_count)
    begin
        case curr_state is
            when s_init => display1 <= "1011011"; --display2 <= "0000001"; -- S-
            when s_read_addr => display1 <= "1110111"; --display2 <= "1110111"; -- SA
            when s_read_data => display1 <= "0111101"; --display2 <= "0111101"; -- Sd
            
            when s_write1 => display1 <= "1000000"; -- |.
            when s_wready1 => display1 <= "0000001"; --display2 <= "0000001"; -- --
            when s_read1 => display1 <= "0001000"; -- _.
            when s_rready1 => display1 <= "0000001";
            
            when s_write2 => display1 <= "1000000"; -- |.
            when s_wready2 => display1 <= "0000001"; --display2 <= "0000001"; -- --
            when s_read2 => display1 <= "0001000"; -- _.
            when s_rready2 => display1 <= "0000001";
            
            when s_end => display1 <= "1001111"; --display2 <= "0000001"; -- E-
            when others => display1 <= "0000000"; --display2 <= "0000000"; --
        end case;
        
        case curr_count is
                when 0 => display2 <= "1111110";
                when 1 => display2 <= "0110000";
                when 2 => display2 <= "1101101";
                when 3 => display2 <= "1111001";
                when 4 => display2 <= "0110011";
                when 5 => display2 <= "1011011";
                when 6 => display2 <= "0011111";
                when 7 => display2 <= "1110000";
                when 8 => display2 <= "1111111";
                when 9 => display2 <= "1110011";
                when 10 => display2 <= "1110111";
                when others => display2 <= "0000000";
            end case;
    end process;
    
    --cnt: process(count)
    --begin
        
    -- end process;
    
    --outputs(15 downto 8) <= "0000" & count;
    outputs(15 downto 8) <= curr_addr(7 downto 0);
    outputs(7 downto 0) <= curr_data(7 downto 0);
end arch;
