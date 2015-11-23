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
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
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
                if (in_data_b = 0)
                then
                    out_alu_res <= std_logic_vector(unsigned(in_data_a) sll 8);
                else
                    out_alu_res <= std_logic_vector(unsigned(in_data_a) sll to_integer(unsigned(in_data_b)));
                end if;
            when ALU_SRA =>
                -- ALU >> data_a >> data_b
                -- arithmetic shift
                if (in_data_b = 0)
                    then
                        out_alu_res <= std_logic_vector(unsigned(in_data_a) sra 8);
                    else
                        out_alu_res <= std_logic_vector(unsigned(in_data_a) sra to_integer(unsigned(in_data_b)));
                    end if;
            when ALU_XOR =>
                -- ALU data_a xor in_data_b
                out_alu_res <= in_data_a xor in_data_b;
				when ALU_OR =>
                -- ALU data_a or in_data_b
                out_alu_res <= in_data_a or in_data_b;
            when ALU_CMP =>
                -- ALU cmp
                -- data_a == data_b => 1
                -- data_a != data_b => 0
                -- UNSIGNED!!
                all_zero := '0';
                for i in 0 to 15
                loop
                    all_zero := all_zero or sub16_res(i);
                end loop;
                out_alu_res <= "000000000000000" & not(all_zero);

            when ALU_SIGNED_CMP =>
                -- ALU signed cmp
                -- data_a < data_b => 1
                -- data_a >= data_b => 0
                out_alu_res <= "000000000000000" & ((in_data_a(15) and not(in_data_b(15))) or
                                                  ( not(in_data_a(15) xor in_data_b(15)) and sub16_t ));
            when ALU_UNSIGNED_CMP =>
                -- ALU unsigned cmp
                -- data_a < data_b => 1
                -- data_a >= data_b => 0
                out_alu_res <= "000000000000000" & (sub16_t);
            when ALU_DATA_A =>
                -- output data_a
                out_alu_res <= in_data_a;
            when ALU_DATA_B =>
                -- output data_b
                out_alu_res <= in_data_b;
            when ALU_NOT =>
                -- not a
                out_alu_res <= not(in_data_a);
            when others =>
                out_alu_res <= (others => '0');
        end case;
    end process;

end Behavioral;
