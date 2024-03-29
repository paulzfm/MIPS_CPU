----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:33:20 11/17/2015 
-- Design Name: 
-- Module Name:    extend - Behavioral 
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
use work.constants.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity extend is
    Port ( ctl_size : in  STD_LOGIC_VECTOR (2 downto 0);
           ctl_type : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (15 downto 0);
           output : out  STD_LOGIC_VECTOR (15 downto 0));
end extend;
-- size
-- 000 3
-- 001 4
-- 010 5
-- 011 8
-- 100 11
-- 111 no extend 16 bit imm
--type 0 zero ext &  1 signed ext   

architecture Behavioral of extend is
begin
process(ctl_size,ctl_type,input)
begin
	case ctl_size is
		when EXT_3 =>
			output(2 downto 0) <= input(2 downto 0);
			if(ctl_type = '0') then
				output(15 downto 3) <= (others=>'0');
			else
				output(15 downto 3) <= (others=>input(2));
			end if;
		when EXT_4 =>
			output(3 downto 0) <= input(3 downto 0);
			if(ctl_type = '0') then
				output(15 downto 4) <= (others=>'0');
			else
				output(15 downto 4) <= (others=>input(3));
			end if;
		when EXT_5 =>
			output(4 downto 0) <= input(4 downto 0);
			if(ctl_type = '0') then
				output(15 downto 5) <= (others=>'0');
			else
				output(15 downto 5) <= (others=>input(4));
			end if;
		when EXT_8 =>
			output(7 downto 0) <= input(7 downto 0);
			if(ctl_type = '0') then
				output(15 downto 8) <= (others=>'0');
			else
				output(15 downto 8) <= (others=>input(7));
			end if;
		when EXT_11 =>
			output(10 downto 0) <= input(10 downto 0);
			if(ctl_type = '0') then
				output(15 downto 11) <= (others=>'0');
			else
				output(15 downto 11) <= (others=>input(10));
			end if;
	   when EXT_NO =>
			output(15 downto 0) <= input(15 downto 0);
		when others => null;
	end case;
end process;

end Behavioral;

