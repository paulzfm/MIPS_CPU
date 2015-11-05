library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Display is
    port (
        state: in integer range 0 to 42 := 0;
        display1: out std_logic_vector(0 to 6);
        display2: out std_logic_vector(0 to 6)
    );
end entity;

architecture arch of Display is
begin
    translate : process(state)
    begin
        case state is
            when 0 => display1 <= "1110111"; display2 <= "0000001";
            when 1 => display1 <= "0011111"; display2 <= "0000001";

            when 2 => display1 <= "1001110"; display2 <= "0110000";
            when 3 => display1 <= "1001110"; display2 <= "1101101";
            when 4 => display1 <= "1001110"; display2 <= "1111001";
            when 5 => display1 <= "1001110"; display2 <= "0110011";
            when 6 => display1 <= "1001110"; display2 <= "1011011";
            when 7 => display1 <= "1001110"; display2 <= "0011111";
            when 8 => display1 <= "1001110"; display2 <= "1110000";
            when 9 => display1 <= "1001110"; display2 <= "1111111";
            when 10 => display1 <= "1001110"; display2 <= "1110011";
            when 11 => display1 <= "1001110"; display2 <= "1111110";

            when 12 => display1 <= "0111110"; display2 <= "0110000";
            when 13 => display1 <= "0111110"; display2 <= "1101101";
            when 14 => display1 <= "0111110"; display2 <= "1111001";
            when 15 => display1 <= "0111110"; display2 <= "0110011";
            when 16 => display1 <= "0111110"; display2 <= "1011011";
            when 17 => display1 <= "0111110"; display2 <= "0011111";
            when 18 => display1 <= "0111110"; display2 <= "1110000";
            when 19 => display1 <= "0111110"; display2 <= "1111111";
            when 20 => display1 <= "0111110"; display2 <= "1110011";
            when 21 => display1 <= "0111110"; display2 <= "1111110";

            when 22 => display1 <= "1001111"; display2 <= "0110000";
            when 23 => display1 <= "1001111"; display2 <= "1101101";
            when 24 => display1 <= "1001111"; display2 <= "1111001";
            when 25 => display1 <= "1001111"; display2 <= "0110011";
            when 26 => display1 <= "1001111"; display2 <= "1011011";
            when 27 => display1 <= "1001111"; display2 <= "0011111";
            when 28 => display1 <= "1001111"; display2 <= "1110000";
            when 29 => display1 <= "1001111"; display2 <= "1111111";
            when 30 => display1 <= "1001111"; display2 <= "1110011";
            when 31 => display1 <= "1001111"; display2 <= "1111110";

            when 32 => display1 <= "1000111"; display2 <= "0110000";
            when 33 => display1 <= "1000111"; display2 <= "1101101";
            when 34 => display1 <= "1000111"; display2 <= "1111001";
            when 35 => display1 <= "1000111"; display2 <= "0110011";
            when 36 => display1 <= "1000111"; display2 <= "1011011";
            when 37 => display1 <= "1000111"; display2 <= "0011111";
            when 38 => display1 <= "1000111"; display2 <= "1110000";
            when 39 => display1 <= "1000111"; display2 <= "1111111";
            when 40 => display1 <= "1000111"; display2 <= "1110011";
            when 41 => display1 <= "1000111"; display2 <= "1111110";

            when 42 => display1 <= "0000001"; display2 <= "0000001";
            when others => display1 <= "0000000"; display2 <= "0000000";
        end case;
    end process;
end architecture;
