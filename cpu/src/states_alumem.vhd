----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:10:08 11/17/2015 
-- Design Name: 
-- Module Name:    states_alumem - Behavioral 
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

entity states_alumem is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ctl_bubble : in  STD_LOGIC;
           ctl_copy : in  STD_LOGIC;
           in_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           out_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           in_alu_res : in  STD_LOGIC_VECTOR (15 downto 0);
           out_alu_res : out  STD_LOGIC_VECTOR (15 downto 0);
           in_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           out_rc : out  STD_LOGIC_VECTOR (3 downto 0);
           in_alu_t : in  STD_LOGIC;
           out_alu_t : out  STD_LOGIC;
           in_wr_reg : in  STD_LOGIC;
           in_wr_mem : in  STD_LOGIC;
			  in_rd_mem : in  STD_LOGIC;
           out_wr_reg : out  STD_LOGIC;
           out_wr_mem : out  STD_LOGIC;
			  out_rd_mem : out  STD_LOGIC);
end states_alumem;

architecture Behavioral of states_alumem is

begin


end Behavioral;

