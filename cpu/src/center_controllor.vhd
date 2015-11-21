----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:28:58 11/21/2015 
-- Design Name: 
-- Module Name:    center_controllor - Behavioral 
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

entity center_controllor is
    Port ( out_bubble_ifid : out  STD_LOGIC;
           out_bubble_idalu : out  STD_LOGIC;
           out_bubble_alumem : out  STD_LOGIC;
           out_bubble_memwb : out  STD_LOGIC;
           out_rst_ifid : out  STD_LOGIC;
           out_rst_idalu : out  STD_LOGIC;
           out_rst_alumem : out  STD_LOGIC;
           out_rst_memwb : out  STD_LOGIC;
           out_forward_alu_a : out  STD_LOGIC_VECTOR (1 downto 0);
           out_forward_alu_b : out  STD_LOGIC_VECTOR (1 downto 0);
           out_predict_err : out  STD_LOGIC;
           out_branch_alu_pc_imm : out  STD_LOGIC;
           out_predict_res : out  STD_LOGIC;
           in_ifid_instruction_op : in  STD_LOGIC_VECTOR (4 downto 0);
           in_idalu_instruction_op : in  STD_LOGIC_VECTOR (4 downto 0);
           in_idalu_rz : in  STD_LOGIC_VECTOR (3 downto 0);
           in_ifid_rx : in  STD_LOGIC_VECTOR (3 downto 0);
           in_ifid_ry : in  STD_LOGIC_VECTOR (3 downto 0);
           in_alu_res : in  STD_LOGIC_VECTOR (15 downto 0);
			  in_key_interrupt : in  STD_LOGIC;
           clk : in  STD_LOGIC);
end center_controllor;

architecture Behavioral of center_controllor is

begin


end Behavioral;

