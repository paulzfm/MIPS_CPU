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
           l : in  STD_LOGIC_VECTOR (7 downto 0);
           ram1data : inout  STD_LOGIC_VECTOR (7 downto 0);
           ram1re : out  STD_LOGIC;
           ram1oe : out  STD_LOGIC;
           ram1en : out  STD_LOGIC;
           data_ready : in  STD_LOGIC;
           rdn : out  STD_LOGIC;
           tbre : out  STD_LOGIC;
           tsre : out  STD_LOGIC;
           wrn : out  STD_LOGIC);
end top;

architecture Behavioral of top is
<<<<<<< HEAD
SIGNAL state :STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
begin

=======

component receiver is port(
	clk : in STD_LOGIC;
	rst :¡¡in STD_LOGIC;
	rdn : out  STD_LOGIC;
	data_ready : in  STD_LOGIC;
	data : inout  STD_LOGIC_VECTOR (7 downto 0)
	rev_data_ready : in STD_LOGIC
)
end component;

signal rev_data_ready : STD_LOGIC := '0';

begin
	ram1re <= '1';
	ram1oe <= '1';
	ram1en <= '1';
	
	-- receiver QDC --------------------------
	rev : receiver port map(
		clk => clk,
		rst => reset,
		rdn => rdn, 
		data_ready => data_ready,
		data => ram1data,
		rev_data_ready => rev_data_ready
	);
	
	process (rev_data_ready)
	begin
		if (rev_data_ready`event and rev_data_ready = '1')
			l <= ram1data;
	end process;
	-- receiver end ---------------------------- 

>>>>>>> 2110b398fba98132353b412080d196a7c840212f
end Behavioral;

