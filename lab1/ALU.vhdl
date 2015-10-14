library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ALU is 
    port (
        a, b: in std_login_vector(15 downto 0);
        op: in std_login_vector(3 downto 0);
        y: out std_login_vector(15 downto 0)
    );
end ALU;

