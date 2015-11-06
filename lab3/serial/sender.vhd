----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:12:40 11/05/2015 
-- Design Name: 
-- Module Name:    sender - Behavioral 
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

entity sender is
	Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           ram1data : inout  STD_LOGIC_VECTOR (7 downto 0);
           ram1we : out  STD_LOGIC;
           ram1oe : out  STD_LOGIC;
           ram1en : out  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC;
           wrn : out  STD_LOGIC);
end sender;

architecture Behavioral of sender is
SIGNAL state :STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
begin
process(clk,rst)
begin
	if(rst = '0') then
		state <= "000";
	elsif(clk'event and clk = '1') then
		case state is
			when "000" =>
				state <= "001";
				wrn <= '1';
				ram1en <= '1';
				ram1oe <= '1';
				ram1we <= '1';
			when "001" =>
				state <= "010";
				ram1data <= sw;
				wrn <= '0';
			when "010" =>
				state <= "011";
				wrn <= '1';
			when "011" =>
				if(tbre = '1') then
					state <= "100";
				end if;
			when "100" =>
				if(tbre = '1') then
					state <= "000";
				end if;
			when others =>
				state <= "000";
		end case;
	end if;
end process;

end Behavioral;

