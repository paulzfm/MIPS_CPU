----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:45:37 11/17/2015 
-- Design Name: 
-- Module Name:    states_ifid - Behavioral 
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

entity states_ifid is
    Port ( in_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_pc_inc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_instruction : in  STD_LOGIC_VECTOR (15 downto 0);
           out_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_pc_inc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_instruction : out  STD_LOGIC_VECTOR (15 downto 0);
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ctl_bubble : in  STD_LOGIC;
           ctl_copy : in  STD_LOGIC;
           ctl_rst : in  STD_LOGIC);
end states_ifid;

architecture Behavioral of states_ifid is

begin
--process
process(clk,rst,ctl_bubble)
begin
	--rst async
	if(rst='1')then
			out_pc <= (others=> '0');
			out_pc_inc <= (others=> '0');
			out_instruction <= (others=> '0');
	--clk up work
	elsif(clk'event and clk='1') then
		if(ctl_rst = '1') then
			out_pc <= (others=> '0');
			out_pc_inc <= (others=> '0');
			out_instruction <= (others=> '0');
		elsif(ctl_bubble = '0') then
			out_pc <= in_pc;
			out_pc_inc <= in_pc_inc;
			out_instruction <= in_instruction;
		end if;
	end if;
	
	
end process;

end Behavioral;

