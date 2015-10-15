library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
    port (
        a, b: in std_logic_vector(15 downto 0);
        op: in std_logic_vector(3 downto 0);
        y: out std_logic_vector(15 downto 0);
		  flag: out std_logic
    );
end ALU;

architecture beh of ALU is
begin
    process (op,a,b)
	 begin
    case op is
        when "0000" => -- ADD
            y <= std_logic_vector(unsigned(a) + unsigned(b));
				--y <= a+b ;
				flag <= '0';
        when "0001" => -- SUB
            y <= std_logic_vector(unsigned(a) - unsigned(b));
				--y <= a-b ;
				flag <= '0';
        when "0010" => -- AND
            y <= a and b;
				flag <= '0';
        when "0011" => -- OR
            y <= a or b;
				flag <= '0';
        when "0100" => -- XOR
            y <= a xor b;
				flag <= '0';
        when "0101" => -- NOT
            y <= not a;
				flag <= '0';
        when "0110" => -- SLL
            y <= std_logic_vector(unsigned(a) sll to_integer(unsigned(b)));
				flag <= '0';
        when "0111" => -- SRL
            y <= std_logic_vector(unsigned(a) srl to_integer(unsigned(b)));
				flag <= '0';
        when "1000" => -- SRA
            y <= to_stdlogicvector(to_bitvector(a) sra to_integer(unsigned(b)));
				flag <= '0';
        when "1001" => -- ROL
            y <= std_logic_vector(unsigned(a) rol to_integer(unsigned(b)));
				flag <= '0';
        when others => 
            y <= (others => '0');
				flag <= '0';
    end case;
	 end process;
end beh;