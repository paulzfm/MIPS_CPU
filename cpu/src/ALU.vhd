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
           out_alu_res : out  STD_LOGIC_VECTOR (15 downto 0);
           out_alu_t : out  STD_LOGIC);
end alu;

architecture Behavioral of alu is

component add16_component is
    Port ( in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           out_output : out  STD_LOGIC_VECTOR (15 downto 0);
           out_t : out STD_LOGIC);
end component;

signal add16_res, sub16_res : STD_LOGIC_VECTOR(15 downto 0);
signal add16_t, sub16_t : STD_LOGIC;

begin
    add16 : add16_component port map(
        in_data_a => in_data_a,
        in_data_b => in_data_b,
        out_output => add16_res,
        out_t => add16_t
    );

    sub16 : add16_component port map(
        in_data_a => in_data_a,
        in_data_b => in_data_b,
        out_output => sub16_res,
        out_t => sub16_t
    );

    -- two complement of input b

    process (in_op, in_data_a, in_data_b)
    begin
        case in_op is
            when "0000" => -- ALU add
                out_alu_res <= add16_res;
                out_alu_t <= add16_t;
            when "0001" => -- ALU sub data_a - data_b = data_a + two_complement(data_b)
                out_alu_res <= sub16_res;
                out_alu_t <= sub16_t;
            when "0010" => -- ALU << data_a << data_b 
            when "0011" => -- ALU >> data_a >> data_b
            when "0100" => -- ALU cmp data_a == data_b
            when "1000" => -- output data_a
                out_output <= in_data_a;
                out_t <= '0';
            when "1001" => -- output data_b
                out_output <= in_data_b;
                out_t <= '0';
            when others =>
                out_output <= (others => '0');
                out_t <= '0';
        end case;
    end process;

end Behavioral;

