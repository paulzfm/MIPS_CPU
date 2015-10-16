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
SIGNAL y_temp :STD_LOGIC_VECTOR (15 downto 0);
--SIGNAL FOR PROCESS
begin
    process (y_temp)
	 begin
	     y<=y_temp;
		      flag(3)<='1';
				--flag(1)<='1';
				if(y_temp = "0000000000000000") then
				    flag(2)<='1';
				else
				    flag(2)<='0';
				end if;
--				if(a(15)='0')then
--				    if(b(15)='0')then
--					     if(temp_y(15)='1')then
--						    flag(1)<='1';
--				        end if;
--				    end if;
--				elsif(a(15)='1')then
--				    if(b(15)='1')then
--					     if(temp_y(15)='0')then
--						    flag(1)<='1';
--				        end if;
--				    end if;
--				else
--				    flag(1)<='0';
--				end if;
				if((a(15 downto 15) = "0") and (b(15 downto 15) = "0") and (temp_y(15 downto 15) = "1"))then
					flag(1) <= '1';
				elsif((a(15 downto 15) = "1") and (b(15 downto 15) = "1") and (temp_y(15 downto 15) = "0"))then
					flag(1) <= '1';
				else
					flag(1) <= '0';
				end if;
				flag(0 downto 0) <= y_temp(15 downto 15);
	 end process;
    process (op,a,b)
	 begin
    case op is
        when "0000" => -- ADD
            y_temp <= std_logic_vector(unsigned(a) + unsigned(b));
--				if(temp_y(15 downto 0) = "0000000000000000")
--					flag(2 downto 2) <= '1';
--				else
--					flag(2 downto 2) <= '0';
--				end if;
--				if((a(15 downto 15) = '0') and (b(15 downto 15) = '0') and (temp_y(15 downto 15) = '1'))
--					flag(1 downto 1) <= '1';
--				elsif((a(15 downto 15) = '1') and (b(15 downto 15) = '1') and (temp_y(15 downto 15) = '0'))
--					flag(1 downto 1) <= '1';
--				else
--					flag(1 downto 1) <= '0';
--				end if;
        when "0001" => -- SUB
            y_temp <= std_logic_vector(unsigned(a) - unsigned(b));
				--y <= a-b ;
        when "0010" => -- AND
            y_temp <= a and b;
				--flag() <= "0000";
        when "0011" => -- OR
            y_temp <= a or b;
				--flag <= "0000";
        when "0100" => -- XOR
            y_temp <= a xor b;
				--flag <= "0000";
        when "0101" => -- NOT
            y_temp <= not a;
				--flag <= "0000";
        when "0110" => -- SLL
            y_temp <= std_logic_vector(unsigned(a) sll to_integer(unsigned(b)));
				--flag <= "0000";
        when "0111" => -- SRL
            y_temp <= std_logic_vector(unsigned(a) srl to_integer(unsigned(b)));
				--flag <= "0000";
        when "1000" => -- SRA
            y_temp <= to_stdlogicvector(to_bitvector(a) sra to_integer(unsigned(b)));
				--flag <= "0000";
        when "1001" => -- ROL
            y_temp <= std_logic_vector(unsigned(a) rol to_integer(unsigned(b)));
				--flag <= "0000";
        when others => 
            y_temp <= (others => '0');
				--flag <= "0000";
    end case;
	 end process;
end beh;