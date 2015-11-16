----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:01:16 11/05/2015 
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
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           l : out  STD_LOGIC_VECTOR (7 downto 0);
           ram1data : inout  STD_LOGIC_VECTOR (7 downto 0);
           ram1we : out  STD_LOGIC;
           ram1oe : out  STD_LOGIC;
           ram1en : out  STD_LOGIC;
           data_ready : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC;
           wrn : out  STD_LOGIC);
end top;

architecture Behavioral of top is



--component receiver is port(
--	clk : in STD_LOGIC;
--	rst :¡¡in STD_LOGIC;
--	rdn : out  STD_LOGIC;
--	data_ready : in  STD_LOGIC;
--	data : inout  STD_LOGIC_VECTOR (7 downto 0)
--	rev_data_ready : in STD_LOGIC
--)
--end component;

component sender is port(
			  clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           sw : in  STD_LOGIC_VECTOR (7 downto 0);
           ram1data : inout  STD_LOGIC_VECTOR (7 downto 0);
           ram1we : out  STD_LOGIC;
           ram1oe : out  STD_LOGIC;
           ram1en : out  STD_LOGIC;
           tbre : in  STD_LOGIC;
           tsre : in  STD_LOGIC;
           wrn : out  STD_LOGIC
);
end component;

signal rev_data_ready : STD_LOGIC := '0';

begin

	-- sender YZP --------------------------
	snd : sender port map(
		clk => clk,
		rst => rst,
		sw => sw,
		ram1data => ram1data,
		ram1we => ram1we,
		ram1oe => ram1oe,
		ram1en => ram1en,
		tbre => tbre, 
		tsre => tsre,
		wrn => wrn
	);
	l <= "00000000";
	rdn <= '0';
	-- sender end ---------------------------- 
	

	


end Behavioral;

