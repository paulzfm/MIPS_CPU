----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    20:17:55 11/17/2015
-- Design Name:
-- Module Name:    alu - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use ieee.numeric_std.all;
use ieee.std_logic_arith.all;

use work.constants.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           in_op : in  STD_LOGIC_VECTOR (3 downto 0);
           out_alu_res : out  STD_LOGIC_VECTOR (15 downto 0));

end alu;

architecture Behavioral of alu is

component add16 is
    Port ( in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           out_output : out  STD_LOGIC_VECTOR (15 downto 0);
           out_t : out STD_LOGIC);
end component;

component sub16 is
    Port ( in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           out_output : out  STD_LOGIC_VECTOR (15 downto 0);
           out_t : out STD_LOGIC);
end component;


signal add16_res, sub16_res : STD_LOGIC_VECTOR(15 downto 0);
signal add16_t, sub16_t : STD_LOGIC;


begin
    add16_entity : add16 port map(
        in_data_a => in_data_a,
        in_data_b => in_data_b,
        out_output => add16_res,
        out_t => add16_t
    );

    sub16_entity : sub16 port map(
        in_data_a => in_data_a,
        in_data_b => in_data_b,
        out_output => sub16_res,
        out_t => sub16_t
    );


    process (in_op, in_data_a, in_data_b, add16_res, sub16_res, add16_t, sub16_t)
    variable all_zero : STD_LOGIC;
    begin
        case in_op is
            when ALU_ADD =>
                -- ALU add
                -- ATTENTION! unsigned!
                out_alu_res <= add16_res;
            when ALU_SUB =>
                -- ALU sub
                -- ATTENTION! unsigned!
                -- out_alu_res <= sub16_res;
                out_alu_res <= sub16_res;

            when ALU_SLL =>
                -- ALU << data_a << data_b
                -- logic shift

                --if (in_data_b = 0)
                --then
                --    out_alu_res <= std_logic_vector(unsigned(in_data_a) sll 8);
                --else
                --    out_alu_res <= std_logic_vector(unsigned(in_data_a) sll to_integer(unsigned(in_data_b)));
                --end if;
                case in_data_b(2 downto 0) is
                    when "000" =>
                        out_alu_res <= in_data_a(7 downto 0) & "00000000";
                    when "001" =>
                        out_alu_res <= in_data_a(14 downto 0) & "0";
                    when "010" =>
                        out_alu_res <= in_data_a(13 downto 0) & "00";
                    when "011" =>
                        out_alu_res <= in_data_a(12 downto 0) & "000";
                    when "100" =>
                        out_alu_res <= in_data_a(11 downto 0) & "0000";
                    when "101" =>
                        out_alu_res <= in_data_a(10 downto 0) & "00000";
                    when "110" =>
                        out_alu_res <= in_data_a(9 downto 0) & "000000";
                    when "111" =>
                        out_alu_res <= in_data_a(8 downto 0) & "0000000";
                    when others =>
                        null;
                end case;
            when ALU_SRA =>
                -- ALU >> data_a >> data_b
                -- arithmetic shift
        --        if (in_data_b = 0)
        --            then
        --                out_alu_res <= to_stdlogicvector(to_bitvector(in_data_a) sra 8);
								----std_logic_vector(unsigned(in_data_a) sra 8);
        --            else
        --                out_alu_res <= to_stdlogicvector(to_bitvector(in_data_a) sra to_integer(unsigned(in_data_b)));
								----std_logic_vector(unsigned(in_data_a) sra to_integer(unsigned(in_data_b)));
        --            end if;
                case in_data_b(2 downto 0) is
                    when "000" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15) & in_data_a(15) & 
                            in_data_a(15) & in_data_a(15) & in_data_a(15) & in_data_a(15) & in_data_a(15) & in_data_a(15 downto 8);
                    when "001" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15 downto 1);
                    when "010" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15) & in_data_a(15 downto 2);
                    when "011" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15) & in_data_a(15) & in_data_a(15 downto 3);
                    when "100" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15) & in_data_a(15) & 
                            in_data_a(15) & in_data_a(15 downto 4);
                    when "101" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15) & in_data_a(15) & 
                            in_data_a(15) & in_data_a(15) & in_data_a(15 downto 5);
                    when "110" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15) & in_data_a(15) & 
                            in_data_a(15) & in_data_a(15) & in_data_a(15) & in_data_a(15 downto 6);
                    when "111" =>
                        out_alu_res <= in_data_a(15) & in_data_a(15) & in_data_a(15) & 
                            in_data_a(15) & in_data_a(15) & in_data_a(15) & in_data_a(15) & in_data_a(15 downto 7);
                    when others =>
                        null;
                end case;
            when ALU_XOR =>
                -- ALU data_a xor in_data_b
                out_alu_res <= in_data_a xor in_data_b;
				when ALU_OR =>
                -- ALU data_a or in_data_b
                out_alu_res <= in_data_a or in_data_b;
            when ALU_CMP =>
                -- ALU cmp
                -- data_a == data_b => 0
                -- data_a != data_b => 1
                -- UNSIGNED!!

                --all_zero := '0';
                --for i in 0 to 15
                --loop
                --    all_zero := all_zero or sub16_res(i);
                --end loop;
                out_alu_res <= "000000000000000" & 
                (
                    (in_data_a(0) xor in_data_b(0)) or 
                    (in_data_a(1) xor in_data_b(1)) or 
                    (in_data_a(2) xor in_data_b(2)) or 
                    (in_data_a(3) xor in_data_b(3)) or 
                    (in_data_a(4) xor in_data_b(4)) or 
                    (in_data_a(5) xor in_data_b(5)) or 
                    (in_data_a(6) xor in_data_b(6)) or 
                    (in_data_a(7) xor in_data_b(7)) or 
                    (in_data_a(8) xor in_data_b(8)) or 
                    (in_data_a(9) xor in_data_b(9)) or 
                    (in_data_a(10) xor in_data_b(10)) or 
                    (in_data_a(11) xor in_data_b(11)) or 
                    (in_data_a(12) xor in_data_b(12)) or 
                    (in_data_a(13) xor in_data_b(13)) or 
                    (in_data_a(14) xor in_data_b(14)) or 
                    (in_data_a(15) xor in_data_b(15))
                );

            when ALU_SIGNED_CMP =>
                -- ALU signed cmp
                -- data_a < data_b => 1
                -- data_a >= data_b => 0
                --out_alu_res <= "000000000000000" & ((in_data_a(15) and not(in_data_b(15))) or
                --                                  ( not(in_data_a(15) xor in_data_b(15)) and sub16_t ));
                if (signed(in_data_a) < signed(in_data_b))
                then
                    out_alu_res <= "0000000000000001";
                else
                    out_alu_res <= "0000000000000000";
                end if;
            when ALU_UNSIGNED_CMP =>
                -- ALU unsigned cmp
                -- data_a < data_b => 1
                -- data_a >= data_b => 0
                --out_alu_res <= "000000000000000" & (sub16_t);
                if (unsigned(in_data_a) < unsigned(in_data_b))
                then
                    out_alu_res <= "0000000000000001";
                else
                    out_alu_res <= "0000000000000000";
                end if;
            when ALU_DATA_A =>
                -- output data_a
                out_alu_res <= in_data_a;
            when ALU_DATA_B =>
                -- output data_b
                out_alu_res <= in_data_b;
            when ALU_NOT =>
                -- not a
                out_alu_res <= not(in_data_a);
            when ALU_EQUAL_ZERO =>
                -- data_a == zero => 00000000000001
                all_zero := '0';
                for i in 0 to 15
                loop
                    all_zero := all_zero or in_data_a(i);
                end loop;
                out_alu_res <= "000000000000000" & not(all_zero);
            when ALU_NOT_EQUAL_ZERO =>
                -- data_a != zero => 00000000000001
                all_zero := '0';
                for i in 0 to 15
                loop
                    all_zero := all_zero or in_data_a(i);
                end loop;
                out_alu_res <= "000000000000000" & (all_zero);
				when ALU_AND =>
                out_alu_res <= in_data_a and in_data_b;
            when others =>
                out_alu_res <= (others => '0');
        end case;
    end process;

end Behavioral;
