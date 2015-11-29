----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:51:22 11/29/2015 
-- Design Name: 
-- Module Name:    keyboard_controller - Behavioral 
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

entity keyboard_controller is
    Port ( rst : in  STD_LOGIC;
	       --write data
	       scancode : in  STD_LOGIC_VECTOR (7 downto 0);
           fok : in  STD_LOGIC;
	       --read data
           rd_en : in  STD_LOGIC;
           rd_clk : in  STD_LOGIC;
           out_brk : out  STD_LOGIC;
           out_count : out  STD_LOGIC_VECTOR (6 downto 0);
           out_ascii : out  STD_LOGIC_VECTOR (15 downto 0)
			  
			  );
end keyboard_controller;


architecture Behavioral of keyboard_controller is

signal temp_ascii : std_logic_vector(7 downto 0);
signal fifo_in_clk : std_logic := '0';
--signal fifo_out_full : std_logic;
signal fifo_out_empty : std_logic;



signal shift_state : std_logic_vector(1 downto 0) := "00";

begin
out_brk <= not fifo_out_empty;

process(rst, fok)
begin
    if rst = '1' then
        shift_state <= "00";
        fifo_in_clk <= '0';
    elsif (fok'event and fok = '0') then
        fifo_in_clk <= '0';
        case shift_state is
            when "00" =>
                if temp_ascii = x"0E" then
                    shift_state <= "10";
                elsif temp_ascii = x"80" then
                    shift_state <= "01";
                else
                    fifo_in_clk <= '1';
                end if;
            when "01" =>
                shift_state <= "00";
            when "10" =>
                if temp_ascii = x"80" then
                    shift_state <= "11";
                else
                    fifo_in_clk <= '1';
                end if;
            when "11" =>
                if temp_ascii = x"0E" then
                    shift_state <= "00";
                else 
                    shift_state <= "10";
                end if;
            when others => shift_state <= "00";
        end case;
    end if;
end process;

process(scancode, shift_state)
begin
    if shift_state = "00" then
        case scancode is
            when x"12" =>
                temp_ascii <= x"0E";--L shift
            when x"59" =>
                temp_ascii <= x"0E";--R shift
            when x"F0" =>
                temp_ascii <= x"80";--1F BREAK
            when x"29" =>
                temp_ascii <= x"00";--space
            when x"5A" =>
                temp_ascii <= x"0A";--enter
            
            when x"1C" =>
                temp_ascii <= x"61";
            when x"32" =>
                temp_ascii <= x"62";
            when x"21" =>
                temp_ascii <= x"63";
            when x"23" =>
                temp_ascii <= x"64";
            when x"24" =>
                temp_ascii <= x"65";
            when x"2B" =>
                temp_ascii <= x"66";
            when x"34" =>
                temp_ascii <= x"67";
            when x"33" =>
                temp_ascii <= x"68";
            when x"43" =>
                temp_ascii <= x"69";
            when x"3B" =>
                temp_ascii <= x"6A";
            when x"42" =>
                temp_ascii <= x"6B";
            when x"4B" =>
                temp_ascii <= x"6C";
            when x"3A" =>
                temp_ascii <= x"6D";
            when x"31" =>
                temp_ascii <= x"6E";
            when x"44" =>
                temp_ascii <= x"6F";
            when x"4D" =>
                temp_ascii <= x"70";
            when x"15" =>
                temp_ascii <= x"71";
            when x"2D" =>
                temp_ascii <= x"72";
            when x"1B" =>
                temp_ascii <= x"73";
            when x"2C" =>
                temp_ascii <= x"74";
            when x"3C" =>
                temp_ascii <= x"75";
            when x"2A" =>
                temp_ascii <= x"76";
            when x"1D" =>
                temp_ascii <= x"77";
            when x"22" =>
                temp_ascii <= x"78";
            when x"35" =>
                temp_ascii <= x"79";
            when x"1A" =>
                temp_ascii <= x"7A";
            when x"45" =>
                temp_ascii <= x"30";
            when x"16" =>
                temp_ascii <= x"31";
            when x"1E" =>
                temp_ascii <= x"32";
            when x"26" =>
                temp_ascii <= x"33";
            when x"25" =>
                temp_ascii <= x"34";
            when x"2E" =>
                temp_ascii <= x"35";
			when x"36" =>
                temp_ascii <= x"36";
            when x"3D" =>
                temp_ascii <= x"37";
            when x"3E" =>
                temp_ascii <= x"38";
            when x"46" =>
                temp_ascii <= x"39";
            when others => 
                temp_ascii <= (others => '0');
        end case;
    else
        case scancode is
            when x"12" =>
                temp_ascii <= x"0E";--L shift
            when x"59" =>
                temp_ascii <= x"0E";--R shift
            when x"F0" =>
                temp_ascii <= x"80";--1F BREAK
            when x"29" =>
                temp_ascii <= x"00";--space
            when x"5A" =>
                temp_ascii <= x"0A";--enter
            
            when x"1C" =>
                temp_ascii <= x"41";
            when x"32" =>
                temp_ascii <= x"42";
            when x"21" =>
                temp_ascii <= x"43";
            when x"23" =>
                temp_ascii <= x"44";
            when x"24" =>
                temp_ascii <= x"45";
            when x"2B" =>
                temp_ascii <= x"46";
            when x"34" =>
                temp_ascii <= x"47";
            when x"33" =>
                temp_ascii <= x"48";
            when x"43" =>
                temp_ascii <= x"49";
            when x"3B" =>
                temp_ascii <= x"4A";
            when x"42" =>
                temp_ascii <= x"4B";
            when x"4B" =>
                temp_ascii <= x"4C";
            when x"3A" =>
                temp_ascii <= x"4D";
            when x"31" =>
                temp_ascii <= x"4E";
            when x"44" =>
                temp_ascii <= x"4F";
            when x"4D" =>
                temp_ascii <= x"50";
            when x"15" =>
                temp_ascii <= x"51";
            when x"2D" =>
                temp_ascii <= x"52";
            when x"1B" =>
                temp_ascii <= x"53";
            when x"2C" =>
                temp_ascii <= x"54";
            when x"3C" =>
                temp_ascii <= x"55";
            when x"2A" =>
                temp_ascii <= x"56";
            when x"1D" =>
                temp_ascii <= x"57";
            when x"22" =>
                temp_ascii <= x"58";
            when x"35" =>
                temp_ascii <= x"59";
            when x"1A" =>
                temp_ascii <= x"5A";
            when x"45" =>
                temp_ascii <= x"29";
            when x"16" =>
                temp_ascii <= x"21";
            when x"1E" =>
                temp_ascii <= x"40";
            when x"26" =>
                temp_ascii <= x"23";
            when x"25" =>
                temp_ascii <= x"24";
            when x"2E" =>
                temp_ascii <= x"25";
			when x"36" =>
                temp_ascii <= x"5E";
            when x"3D" =>
                temp_ascii <= x"26";
            when x"3E" =>
                temp_ascii <= x"2A";
            when x"46" =>
                temp_ascii <= x"28";
            when others => 
                temp_ascii <= (others => '0');
        end case;
    end if;
end process;

fifo_keyboard_instance: entity work.FIFO_key port map(
    rst => rst,
    wr_clk => fifo_in_clk,
    rd_clk => rd_clk,
    din(7 downto 0) => temp_ascii,
    din(15 downto 8) => "00000000",
    wr_en => '1',
    rd_en => rd_en,
    out_empty => fifo_out_empty,
    dout => out_ascii,
    wr_data_count => out_count
);

end Behavioral;

