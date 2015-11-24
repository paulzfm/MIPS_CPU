----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:56:20 11/17/2015 
-- Design Name: 
-- Module Name:    CPU - Behavioral 
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

entity CPU is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  rdn : out  STD_LOGIC;
           wrn : out  STD_LOGIC;
           bus1_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           bus2_addr : out  STD_LOGIC_VECTOR (15 downto 0);
           bus1_data : inout  STD_LOGIC_VECTOR (15 downto 0);
           bus2_data : inout  STD_LOGIC_VECTOR (15 downto 0));
end CPU;

architecture Behavioral of CPU is
signal pc_wr, pc_t : STD_LOGIC;
signal pc_input, pc_output, pc_inc : STD_LOGIC_VECTOR(15 downto 0);

begin
    pc_entity : entity work.pc port map(
        clk => clk,
        wr => pc_wr,
        input => pc_input,
        output => pc_output
    );
    -- input pc_output
    -- output pc_output + 1
    pc_inc_add16_entity : entity work.add16 port map(
        in_data_a => pc_output,
        in_data_b => SIGNAL_ONE,
        out_output => pc_inc,
        out_t => pc_t
    );
    

end Behavioral;

