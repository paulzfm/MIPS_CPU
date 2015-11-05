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
    -- 0: init (A-)
    -- 1: ready (B-)
    -- 2~11: write to ram1 (C1..0)
    -- 12~21: read from ram1 (D1..0)
    -- 22~31: write to ram2 (E1..0)
    -- 32~41: read from ram2 (F1..0)
    -- 42: end (--)
    signal state: integer range 0 to 42 := 0;

    -- inputs
    signal start_addr: std_logic_vector(17 downto 0);
    signal start_data: std_logic_vector(15 downto 0);

    -- ram1 adaptor
    signal en1: std_logic;
    signal rd1: std_logic;
    signal addr1: std_logic_vector(17 downto 0);
    signal in1: std_logic_vector(15 downto 0);
    signal out1: std_logic_vector(15 downto 0);

    component RAMAdaptor
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
    end component;

    component Display
        port (
            state: in integer range 0 to 42 := 0;
            display1: out std_logic_vector(0 to 6);
            display2: out std_logic_vector(0 to 6)
        );
    end component;
begin
    transaction: process(clk, rst)
    begin
        if rst = '0' then
            state <= 0;
        elsif falling_edge(clk) then
            state <= state + 1;
        end if;
    end process;

    ctrl: process(state)
    begin
        if state = 0 then
            -- en2 <= '0';
            en1 <= '1';
            rd1 <= '0'; -- ready to write ram1
        elsif state = 1 then
            addr1 <= "00" & inputs(15 downto 0);
            start_addr <= "00" & inputs(15 downto 0);
        elsif state = 2 then
            data1 <= inputs;
            start_data <= inputs;
        elsif state > 2 and state <= 11 then
            addr1 <= start_addr + conv_std_logic_vector(state - 2, 18);
            data1 <= start_data + conv_std_logic_vector(state - 2, 16);
        elsif state = 12 then
            addr1 <= start_addr;
            rd1 <= '1';
        elsif state > 12 and state <= 21 then
            addr1 <= start_addr + conv_std_logic_vector(state - 2, 18);
        end if;
    end process;

    -- address and data display
    outputs(15 downto 8) <= addr1(7 downto 0);
    outputs(7 downto 0) <= out1(7 downto 0);

    r1: RAMAdaptor port map (
        clk => clk,
        addr => addr1,
        data_in => in1,
        en => en1,
        rd => rd1,
        data_out => out1,
        ram_addr => ram1_addr,
        ram_data => ram1_data,
        ram_oe => ram1_oe,
        ram_we => ram1_we,
        ram_en => ram1_en
    );

    disp: Display port map (
        state => state,
        display1 => display1,
        display2 => display2
    );
end arch;
