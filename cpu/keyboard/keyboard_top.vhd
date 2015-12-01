library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity keyboard_top is
port(
    datain,clkin,fclk,rst_in: in std_logic;
    rd_en : in  STD_LOGIC;
    rd_clk : in  STD_LOGIC;
    out_brk : out  STD_LOGIC;
    --out_count : out  STD_LOGIC_VECTOR (6 downto 0);
    out_ascii : out  STD_LOGIC_VECTOR (7 downto 0)
);
end keyboard_top;

architecture behave of keyboard_top is

--signal temp_ascii : std_logic_vector(15 downto 0);
--signal fifo_out_full : std_logic;
--signal fifo_out_empty : std_logic;
--begin
--out_ascii <= temp_ascii(7 downto 0);
--out_brk <= '0';
--
--fifo_keyboard_instance: entity work.FIFO port map(
--    --rst => rst,
--    wr_clk => rd_clk,
--    rd_clk => '1',
--    din => "0000000000000000",
--    wr_en => '1',
--    rd_en => '1',
--    dout => temp_ascii,
--    full => fifo_out_full,
--    wr_data_count => out_count,
--    empty => fifo_out_empty
--);


signal scancode : std_logic_vector(7 downto 0);
signal rst, fok : std_logic;
signal temp_ascii : std_logic_vector(15 downto 0);
--signal clk_f: std_logic;

begin
rst<=not rst_in;
out_ascii <= temp_ascii(7 downto 0);
--brk <= '1';

u0: entity work.Keyboard port map(
datain => datain,
clkin => clkin,
fclk => fclk,
rst => rst,
out_fok => fok,
scancode => scancode
);
u1: entity work.keyboard_controller port map(
rst => rst,
--write data
scancode => scancode,
fok => fok,
--read data
rd_en => rd_en,
rd_clk => rd_clk,
out_brk => out_brk,
--out_count => out_count,
out_ascii => temp_ascii
);

end behave;

