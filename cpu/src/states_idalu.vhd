----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:57:42 11/17/2015 
-- Design Name: 
-- Module Name:    states_idalu - Behavioral 
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

entity states_idalu is
    Port ( in_ra : in  STD_LOGIC_VECTOR (3 downto 0);
           in_rb : in  STD_LOGIC_VECTOR (3 downto 0);
           in_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           out_ra : out  STD_LOGIC_VECTOR (3 downto 0);
           out_rb : out  STD_LOGIC_VECTOR (3 downto 0);
           out_rc : out  STD_LOGIC_VECTOR (3 downto 0);
           in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           out_data_a : out  STD_LOGIC_VECTOR (15 downto 0);
           out_data_b : out  STD_LOGIC_VECTOR (15 downto 0);
           in_op : in  STD_LOGIC_VECTOR (3 downto 0);
           out_op : out  STD_LOGIC_VECTOR (3 downto 0);
           in_is_branch : in  STD_LOGIC;
           out_is_branch : out  STD_LOGIC;
           ctl_bubble : in  STD_LOGIC;
           ctl_copy : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           in_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_pc_inc : in  STD_LOGIC_VECTOR (15 downto 0);
           out_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_pc_inc : out  STD_LOGIC_VECTOR (15 downto 0);
           in_imm : in  STD_LOGIC_VECTOR (15 downto 0);
           out_imm : out  STD_LOGIC_VECTOR (15 downto 0);
			  in_wr_reg : in  STD_LOGIC;
           in_wr_mem : in  STD_LOGIC;
           out_wr_reg : out  STD_LOGIC;
           out_wr_mem : out  STD_LOGIC);
end states_idalu;

architecture Behavioral of states_idalu is

begin


end Behavioral;

