library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity ALU is 
    port (
        a, b: in std_login_vector(15 downto 0);
        op: in std_login_vector(3 downto 0);
        y: out std_login_vector(15 downto 0)
    );
end ALU;

architecture beh of ALU is
begin
    case op is
        when "0000" => -- ADD
            y <= a + b;
        when "0001" => -- SUB
            y <= a - b;
        when "0010" => -- AND
            y <= a and b;
        when "0011" => -- OR
            y <= a or b;
        when "0100" => -- XOR
            y <= a xor b;
        when "0101" => -- NOT
            y <= not a;
        when "0110" => -- SLL
            y <= a sll to_integer(unsigned(b));
        when "0111" => -- SRL
            y <= a srl to_integer(unsigned(b));
        when "1000" => -- SRA
            y <= a sra to_integer(unsigned(b));
        when "1001" => -- ROL
            y <= a rol to_integer(unsigned(b));
        others => 
            y <= (others => '0');
    end case;
end beh;