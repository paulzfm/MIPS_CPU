library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is 
    port (
        a, b: in std_logic_vector(15 downto 0);
        op: in std_logic_vector(3 downto 0);
        y: out std_logic_vector(15 downto 0);
		flag: out std_logic_vector(3 downto 0)--C Z V S
    );
end ALU;

architecture beh of ALU is
--SIGNAL FOR PROCESS
SIGNAL y_temp :STD_LOGIC_VECTOR (16 downto 0) := (others => '0');
signal b_temp:STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
--SIGNAL FOR PROCESS
begin
    process (y_temp, a, b, op, b_temp)
	 begin
	     y<=y_temp(15 downto 0);
	     		-- carry
	     		flag(0 downto 0) <= y_temp(16 downto 16);

		      	-- zero
				if(y_temp(15 downto 0) = "0000000000000000") then
				    flag(1)<='1';
				else
				    flag(1)<='0';
				end if;

				-- overflow
				if ((a(15 downto 15) = "0") and (b_temp(15 downto 15) = "0") and (y_temp(15 downto 15) = "1")) then
					flag(2) <= '1';
				elsif ((a(15 downto 15) = "1") and (b_temp(15 downto 15) = "1") and (y_temp(15 downto 15) = "0")) then
					flag(2) <= '1';
				else
					flag(2) <= '0';
				end if;

				-- symbol
				flag(3 downto 3) <= y_temp(15 downto 15);
	 end process;
    process (op,a,b)
	 begin
    case op is
        when "0000" => -- ADD
            y_temp <= std_logic_vector(unsigned("0" & a) + unsigned("0" & b));
				b_temp <= b;
        when "0001" => -- SUB
            y_temp <= std_logic_vector(unsigned("0" & a) - unsigned("0" & b));
				b_temp <= std_logic_vector(unsigned(not b) + "0000000000000001");
        when "0010" => -- AND
            y_temp(15 downto 0) <= a and b;
        when "0011" => -- OR
            y_temp(15 downto 0) <= a or b;
        when "0100" => -- XOR
            y_temp(15 downto 0) <= a xor b;
        when "0101" => -- NOT
            y_temp(15 downto 0) <= not a;
        when "0110" => -- SLL
            y_temp(15 downto 0) <= std_logic_vector(unsigned(a) sll to_integer(unsigned(b)));
        when "0111" => -- SRL
            y_temp(15 downto 0) <= std_logic_vector(unsigned(a) srl to_integer(unsigned(b)));
        when "1000" => -- SRA
            y_temp(15 downto 0) <= to_stdlogicvector(to_bitvector(a) sra to_integer(unsigned(b)));
        when "1001" => -- ROL
            y_temp(15 downto 0) <= std_logic_vector(unsigned(a) rol to_integer(unsigned(b)));
        when others => 
            y_temp <= (others => '0');
    end case;
	 end process;
end beh;