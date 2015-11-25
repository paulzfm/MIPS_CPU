----------------------------------------------------------------------------------
-- Company:
-- Engineer: Zhu Fengmin
--
-- Create Date:    14:27:37 11/17/2015
-- Design Name:
-- Module Name:    registers - Behavioral
-- Project Name:
-- Target Devices:
-- Tool versions:
-- Description:
--    The register heap, including 8 general registers and SP, IH, T.
--        0000 ~ 0111 - general registers R0 ~ R7
--        1000 - SP
--        1001 - IH
--        1010 - T
--        1100 - RA
--    Illegal address will be IGNORED: always output 0 if read!
--    @falling_edge write if wr='1'
--    reset if rst='0'
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registers is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           wr : in  STD_LOGIC; -- write enable
           addr_a : in  STD_LOGIC_VECTOR (3 downto 0);
           addr_b : in  STD_LOGIC_VECTOR (3 downto 0);
           addr_c : in  STD_LOGIC_VECTOR (3 downto 0);
           data_a : out  STD_LOGIC_VECTOR (15 downto 0);
           data_b : out  STD_LOGIC_VECTOR (15 downto 0);
           data_c : in  STD_LOGIC_VECTOR (15 downto 0);
           -- debug
           debug_in : in STD_LOGIC_VECTOR (3 downto 0);
           debug_out : out STD_LOGIC_VECTOR (15 downto 0));
end registers;

architecture Behavioral of registers is
    signal reg_r0: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_r1: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_r2: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_r3: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_r4: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_r5: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_r6: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_r7: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_sp: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_ih: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_t: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_ra: STD_LOGIC_VECTOR (15 downto 0);
    signal reg_null: STD_LOGIC_VECTOR (15 downto 0);
begin
    rd_a: process(addr_a, reg_r0, reg_r1, reg_r2, reg_r3, reg_r4, reg_r5, reg_r6, reg_r7, reg_sp, reg_ih, reg_t, reg_ra, reg_null)
    begin
        case addr_a is -- read x
            when "0000" => data_a <= reg_r0;
            when "0001" => data_a <= reg_r1;
            when "0010" => data_a <= reg_r2;
            when "0011" => data_a <= reg_r3;
            when "0100" => data_a <= reg_r4;
            when "0101" => data_a <= reg_r5;
            when "0110" => data_a <= reg_r6;
            when "0111" => data_a <= reg_r7;
            when "1000" => data_a <= reg_sp;
            when "1001" => data_a <= reg_ih;
            when "1010" => data_a <= reg_t;
            when "1100" => data_a <= reg_ra;
            when "1111" => data_a <= reg_null;
            when others => data_a <= (others => '0');
        end case;
    end process;

    rd_b : process(addr_b, reg_r0, reg_r1, reg_r2, reg_r3, reg_r4, reg_r5, reg_r6, reg_r7, reg_sp, reg_ih, reg_t, reg_ra, reg_null)
    begin
        case addr_b is -- read y
            when "0000" => data_b <= reg_r0;
            when "0001" => data_b <= reg_r1;
            when "0010" => data_b <= reg_r2;
            when "0011" => data_b <= reg_r3;
            when "0100" => data_b <= reg_r4;
            when "0101" => data_b <= reg_r5;
            when "0110" => data_b <= reg_r6;
            when "0111" => data_b <= reg_r7;
            when "1000" => data_b <= reg_sp;
            when "1001" => data_b <= reg_ih;
            when "1010" => data_b <= reg_t;
            when "1100" => data_b <= reg_ra;
            when "1111" => data_b <= reg_null;
            when others => data_b <= (others => '0');
        end case;
    end process;

    wr_z : process(clk,  rst)
    begin
        if rst = '0' then -- set all registers to 0
            reg_r0 <= (others => '0');
            reg_r1 <= (others => '0');
            reg_r2 <= (others => '0');
            reg_r3 <= (others => '0');
            reg_r4 <= (others => '0');
            reg_r5 <= (others => '0');
            reg_r6 <= (others => '0');
            reg_r7 <= (others => '0');
            reg_sp <= (others => '0');
            reg_ih <= (others => '0');
            reg_t <= (others => '0');
            reg_ra <= (others => '0');
            reg_null <= (others => '0');
        elsif falling_edge(clk) and wr = '1' then -- write
            case addr_c is
                when "0000" => reg_r0 <= data_c;
                when "0001" => reg_r1 <= data_c;
                when "0010" => reg_r2 <= data_c;
                when "0011" => reg_r3 <= data_c;
                when "0100" => reg_r4 <= data_c;
                when "0101" => reg_r5 <= data_c;
                when "0110" => reg_r6 <= data_c;
                when "0111" => reg_r7 <= data_c;
                when "1000" => reg_sp <= data_c;
                when "1001" => reg_ih <= data_c;
                when "1010" => reg_t <= data_c;
                when "1100" => reg_ra <= data_c;
                when "1111" => reg_null <= data_c;
                when others => null;
            end case;
        end if;
    end process;

    debug : process(debug_in, reg_r0, reg_r1, reg_r2, reg_r3, reg_r4, reg_r5, reg_r6, reg_r7, reg_sp, reg_ih, reg_t, reg_ra, reg_null)
    begin
        case debug_in is
            when "0000" => debug_out <= reg_r0;
            when "0001" => debug_out <= reg_r1;
            when "0010" => debug_out <= reg_r2;
            when "0011" => debug_out <= reg_r3;
            when "0100" => debug_out <= reg_r4;
            when "0101" => debug_out <= reg_r5;
            when "0110" => debug_out <= reg_r6;
            when "0111" => debug_out <= reg_r7;
            when "1000" => debug_out <= reg_sp;
            when "1001" => debug_out <= reg_ih;
            when "1010" => debug_out <= reg_t;
            when "1100" => debug_out <= reg_ra;
            when "1111" => debug_out <= reg_null;
            when others => debug_out <= (others => '0');
        end case;
    end process;
end Behavioral;
