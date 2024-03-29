----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:41:14 11/17/2015 
-- Design Name: 
-- Module Name:    mux2 - Behavioral 
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

entity mux2 is
    Port ( input0 : in  STD_LOGIC_VECTOR (15 downto 0);
           input1 : in  STD_LOGIC_VECTOR (15 downto 0);
           addr : in  STD_LOGIC;
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end mux2;

architecture Behavioral of mux2 is

begin

    process (input0, input1, addr)
    begin
        case addr is
            when '0' =>
                output <= input0;
            when '1' =>
                output <= input1;
				when others =>
				    output <= (others => '0');
        end case;
    end process;
end Behavioral;

