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
--    Illegal address will be IGNORED: always output 0 if read!
--    @rising_edge write if wr='1'
--    @falling_edge read
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
           addr_x : in  STD_LOGIC_VECTOR (3 downto 0);
           addr_y : in  STD_LOGIC_VECTOR (3 downto 0);
           addr_z : in  STD_LOGIC_VECTOR (3 downto 0);
           data_A : out  STD_LOGIC_VECTOR (15 downto 0);
           data_B : out  STD_LOGIC_VECTOR (15 downto 0);
           data_C : in  STD_LOGIC_VECTOR (15 downto 0));
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
begin
    rd_or_wr : process(clk, rst)
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
        elsif rising_edge(clk) and wr = '1' then -- write
            case addr_z is
                when "0000" => reg_r0 <= data_C;
                when "0001" => reg_r1 <= data_C;
                when "0010" => reg_r2 <= data_C;
                when "0011" => reg_r3 <= data_C;
                when "0100" => reg_r4 <= data_C;
                when "0101" => reg_r5 <= data_C;
                when "0110" => reg_r6 <= data_C;
                when "0111" => reg_r7 <= data_C;
                when "1000" => reg_sp <= data_C;
                when "1001" => reg_ih <= data_C;
                when "1010" => reg_t <= data_C;
                when others => ;
            end case;
        elsif falling_edge(clk) then -- read
            case addr_x is -- read x
                when "0000" => data_A <= reg_r0;
                when "0001" => data_A <= reg_r1;
                when "0010" => data_A <= reg_r2;
                when "0011" => data_A <= reg_r3;
                when "0100" => data_A <= reg_r4;
                when "0101" => data_A <= reg_r5;
                when "0110" => data_A <= reg_r6;
                when "0111" => data_A <= reg_r7;
                when "1000" => data_A <= reg_sp;
                when "1001" => data_A <= reg_ih;
                when "1010" => data_A <= reg_t;
                when others => data_A <= (others => '0');
            end case;
            case addr_y is -- read y
                when "0000" => data_B <= reg_r0;
                when "0001" => data_B <= reg_r1;
                when "0010" => data_B <= reg_r2;
                when "0011" => data_B <= reg_r3;
                when "0100" => data_B <= reg_r4;
                when "0101" => data_B <= reg_r5;
                when "0110" => data_B <= reg_r6;
                when "0111" => data_B <= reg_r7;
                when "1000" => data_B <= reg_sp;
                when "1001" => data_B <= reg_ih;
                when "1010" => data_B <= reg_t;
                when others => data_B <= (others => '0');
            end case;
        end if;
    end process;
end Behavioral;
