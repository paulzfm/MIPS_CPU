----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:31:59 11/29/2015 
-- Design Name: 
-- Module Name:    FIFO_key - Behavioral 
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
use IEEE.STD_LOGIC_unsigned.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO_key is
PORT (
    rst : IN STD_LOGIC;
    wr_clk : IN STD_LOGIC;
    rd_clk : IN STD_LOGIC;
    din : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    wr_en : IN STD_LOGIC;
    rd_en : IN STD_LOGIC;
	 out_empty : OUT STD_LOGIC;
    dout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    --wr_data_count : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
  );
end FIFO_key;

architecture Behavioral of FIFO_key is

signal temp_count : std_logic_vector(2 downto 0);
signal rd_count : std_logic_vector(2 downto 0);
signal empty : std_logic;

signal data_000 : std_logic_vector(15 DOWNTO 0);
signal data_001 : std_logic_vector(15 DOWNTO 0);
signal data_010 : std_logic_vector(15 DOWNTO 0);
signal data_011 : std_logic_vector(15 DOWNTO 0);
signal data_100 : std_logic_vector(15 DOWNTO 0);
signal data_101 : std_logic_vector(15 DOWNTO 0);
signal data_110 : std_logic_vector(15 DOWNTO 0);
signal data_111 : std_logic_vector(15 DOWNTO 0);

begin

wr_data_count <= '1' & temp_count & rd_count;
out_empty <= empty;

process(temp_count, rd_count)
begin
if temp_count = rd_count then
	empty <= '1';
else
	empty <= '0';
end if;
end process;

process(rst, wr_clk)
begin
	if rst = '1' then
		temp_count <= "000";
	elsif (wr_clk'event and wr_clk = '1') then
		if wr_en = '1' then
			 case temp_count is
				when "000" =>
					data_000 <= din;
					temp_count <= "001";
				when "001" =>
					data_001 <= din;
					temp_count <= "010";
				when "010" =>
					data_010 <= din;
					temp_count <= "011";
				when "011" =>
					data_011 <= din;
					temp_count <= "100";
				when "100" =>
					data_100 <= din;
					temp_count <= "101";
				when "101" =>
					data_101 <= din;
					temp_count <= "110";
				when "110" =>
					data_110 <= din;
					temp_count <= "111";
				when "111" =>
					data_111 <= din;
					temp_count <= "000";
				when others => null;
			 end case;
		end if;
	end if;
end process;

process(rst, rd_clk)
begin
	if rst = '1' then
		rd_count <= "000";
	elsif (rd_clk'event and rd_clk = '1') then
		if (rd_en = '1' and empty = '0') then
			 case rd_count is
				when "000" =>
					dout <= data_000;
					rd_count <= "001";
				when "001" =>
					dout <= data_001;
					rd_count <= "010";
				when "010" =>
					dout <= data_010;
					rd_count <= "011";
				when "011" =>
					dout <= data_011;
					rd_count <= "100";
				when "100" =>
					dout <= data_100;
					rd_count <= "101";
				when "101" =>
					dout <= data_101;
					rd_count <= "110";
				when "110" =>
					dout <= data_110;
					rd_count <= "111";
				when "111" =>
					dout <= data_111;
					rd_count <= "000";
				when others => null;
			 end case;
		end if;
	end if;
end process;

end Behavioral;

