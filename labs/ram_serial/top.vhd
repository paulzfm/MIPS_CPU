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

signal state : STD_LOGIC_VECTOR (3 downto 0);
signal device : STD_LOGIC;

begin
ram_addr(7 downto 0) <= addr;
ram_addr(17 downto 8) <= (others=>'0');
output_state <= state;


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
		state <= (others=>'0');
		wrn <= '1';
		rdn <= '1';
		WE <= '1';
		OE <= '1';
		EN <= '0';
		ramdata <= (others=>'Z');
	elsif(clk'event and clk = '1') then
		case state is
			when "0000" =>
				if(device = '0' and wr_rd = '0') then
					state <= "0010";
				elsif(device = '0' and wr_rd = '1') then
					state <= "0100";
					--rdn <= '1';
					--ramdata <= (others=>'Z');
				elsif(device = '1' and wr_rd = '0') then
					state <= "1010";
				else
					state <= "1101";
					WE <= '1';
					OE <= '0';
					ramdata <= (others=>'Z');
				end if;
			when "0010"=>
				state <= "0001";
				wrn <= '0';
				ramdata <= "000000000000"&data;
			when "1010"=>
				state <= "1001";
				WE <= '1';
				OE <= '1';
				ramdata <= "000000000000"&data;
			when "0100"=>
				state <= "0101";
				rdn <= '1';
				ramdata <= (others=>'Z');
			when "0001" =>
				wrn <= '1';
				state <= "0011";
			when "0011" =>
				if(tsre = '1' and tbre = '1')then
					state <= "0000";
				end if;
			when "0101" =>
				if(data_ready = '1')then
					state <= "0111";
					rdn <= '0';
				end if;
			when "0111" =>
				output_data <= ramdata(7 downto 0);
				rdn <= '1';
				state <= "0000";
			when "1001" =>
				WE <='0';
				state <= "1011";
			when "1011" =>
				WE <='1';
				state <= "0000";
			when "1101" =>
				output_data <= ramdata(7 downto 0);
				state <= "0000";
			when others => null;
		end case;
	end if;
end process;


end Behavioral;

