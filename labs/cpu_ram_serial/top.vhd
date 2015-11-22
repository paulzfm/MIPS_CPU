----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:34:59 11/21/2015 
-- Design Name: 
-- Module Name:    top - Behavioral 
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

entity top is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (7 downto 0);
           data : in  STD_LOGIC_VECTOR (3 downto 0);
           wr_rd : in  STD_LOGIC;
			  enable : in STD_LOGIC;
           output_data : out  STD_LOGIC_VECTOR (7 downto 0);
			  output_state: out  STD_LOGIC_VECTOR (3 downto 0);
           ramdata : inout  STD_LOGIC_VECTOR (15 downto 0);
           OE : out  STD_LOGIC;
           WE : out  STD_LOGIC;
           EN : out  STD_LOGIC;
           data_ready : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC;
           wrn : out  STD_LOGIC;
           ram_addr : out  STD_LOGIC_VECTOR (17 downto 0));
end top;

architecture Behavioral of top is

signal state_ctl : STD_LOGIC_VECTOR (2 downto 0);
--000 init
--100 serial wr
--101 serial rd
--110 ram    wr
--111 ram    rd
signal device : STD_LOGIC;
signal device_wr_rd : STD_LOGIC_VECTOR (1 downto 0);

begin
ram_addr(7 downto 0) <= addr;
ram_addr(17 downto 8) <= (others=>'0');
output_state(2 downto 0) <= state_ctl;
device_wr_rd <= device&wr_rd;
output_state(3) <= '0';
output_data <= (others=>'0');
EN <= '0';

process(addr)
begin
	if(addr = "00000000") then
		device <= '0';
	else
		device <= '1';
	end if;
end process;

process(clk,rst)
begin
	if(rst = '0') then
		state_ctl <= "000";
		wrn <= '1';
		rdn <= '1';
	elsif(rising_edge(clk))then
		case state_ctl is
			when "000" => 
				case device_wr_rd is
					when "00"=> 
						state_ctl <= "100";
						wrn <= '0';
						ramdata <= "000000000000"&data;
						rdn <= '1';
						OE <= '1';
						WE <= '1';
					when "01"=> 
						state_ctl <= "101";
						rdn <= '1';
						ramdata <= (others => 'Z');
						wrn <= '1';
						OE <= '1';
						WE <= '1';
					when "10"=> 
						state_ctl <= "110";
						OE <= '1';
						WE <= '1';
						rdn <= '1';
						wrn <= '1';
						ramdata <= "000000000000"&data;
					when "11"=> 
						state_ctl <= "111";
						OE <= '0';
						WE <= '1';
						rdn <= '1';
						wrn <= '1';
						ramdata <= (others => 'Z');
					when others=>null;
				end case;
			when "100" =>
				state_ctl <= "000";
				wrn <= '1';
			when "101" =>
				state_ctl <= "000";
				rdn <= '0';
				--output_data <= ramdata(7 downto 0);
			when "110" =>
				state_ctl <= "000";
				WE <= '0';
			when "111" =>
				state_ctl <= "000";
				--output_data <= ramdata(7 downto 0);
			when others => null;
		end case;
	end if;
end process;


end Behavioral;

