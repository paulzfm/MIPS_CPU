----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date:    12:12:46 11/29/2015
-- Design Name:
-- Module Name:    vga_controller - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vga_controller is
    Port ( clk : in  STD_LOGIC; -- 25MHz clock
           rst : in  STD_LOGIC;
           hs : out  STD_LOGIC;
           vs : out  STD_LOGIC;
           r : out  STD_LOGIC_VECTOR (0 to 2);
           g : out  STD_LOGIC_VECTOR (0 to 2);
           b : out  STD_LOGIC_VECTOR (0 to 2);
           addr : out STD_LOGIC_VECTOR (18 downto 0);
           --offset : in STD_LOGIC_VECTOR (14 downto 0);
           pixel : in STD_LOGIC);
end vga_controller;

architecture Behavioral of vga_controller is
    signal x: STD_LOGIC_VECTOR (9 downto 0) := (others => '0');
    signal y: STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
    signal hs1, vs1: STD_LOGIC;
    signal r1, g1, b1: STD_LOGIC_VECTOR (0 to 2);
    --signal curr_offset : STD_LOGIC_VECTOR (18 downto 0) := (others => '0');
begin
    out_hs : process (clk, rst)
    begin
        if rst = '1' then
            hs <= '0';
        elsif rising_edge(clk) then
            hs <= hs1;
        end if;
    end process;

    out_vs : process (clk, rst)
    begin
        if rst = '1' then
            vs <= '0';
        elsif rising_edge(clk) then
            vs <= vs1;
        end if;
    end process;

    cal_hs : process (clk, rst)
    begin
        if rst = '1' then
            hs1 <= '1';
        elsif rising_edge(clk) then
            if x >= 656 and x < 752 then
		    	hs1 <= '0';
		   	else
		    	hs1 <= '1';
		   	end if;
        end if;
    end process;

    cal_vs : process (clk, rst)
    begin
        if rst = '1' then
            vs1 <= '1';
        elsif rising_edge(clk) then
            if y >= 490 and y < 492 then
		    	vs1 <= '0';
		   	else
		    	vs1 <= '1';
		   	end if;
        end if;
    end process;

    cal_x : process (clk, rst)
    begin
        if rst = '1' then
            x <= (others => '0');
        elsif rising_edge(clk) then
            if x = 799 then
		    	x <= (others => '0');
		   	else
		    	x <= x + 1;
		   	end if;
        end if;
    end process;

    cal_y : process (clk, rst)
    begin
        if rst = '1' then
            y <= (others => '0');
        elsif rising_edge(clk) and x = 799 then
            if y = 524 then
		    	y <= (others => '0');
		   	else
		    	y <= y + 1;
		   	end if;
        end if;
    end process;
    
--    update_offset : process (clk, rst)
--    begin
--        if rst = '1' then
--            curr_offset <= offset & x"0";
--        elsif rising_edge(clk) and x = 799 and y = 524 then
--            curr_offset <= offset & x"0";
--        end if;
--    end process;

    out_color : process (hs1, vs1, r1, g1, b1)
    begin
        if hs1 = '1' and vs1 = '1' then
            -- white or black
            r <= r1;
            g <= g1;
            b <= b1;
        else
            r <= "000";
            g <= "000";
            b <= "000";
        end if;
    end process;

    addr <= ((y * "101") & "0000000") + x;
    
--    cal_addr : process (x, y)
--        variable tmp: STD_LOGIC_VECTOR (19 downto 0);
--    begin
--        tmp := ((y * "101") & "0000000") + x + ("0" & curr_offset);
--        if tmp >= 307200 then
--            addr <= tmp - 307200;
--        else
--            addr <= tmp(18 downto 0);
--        end if;
--    end process;

    out_pixel : process (clk, rst)
    begin
        if rst = '1' then
            r1 <= "000";
            g1 <= "000";
            b1 <= "000";
        elsif rising_edge(clk) then
            if x < 640 and y < 480 then
                if pixel = '0' then
                    r1 <= "000";
                    g1 <= "000";
                    b1 <= "000";
                else
                    r1 <= "111";
                    g1 <= "111";
                    b1 <= "111";
                end if;
            else
                r1 <= "000";
                g1 <= "000";
                b1 <= "000";
            end if;
        end if;
    end process;

end Behavioral;
