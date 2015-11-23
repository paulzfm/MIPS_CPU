----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:15:26 11/17/2015 
-- Design Name: 
-- Module Name:    states_memwb - Behavioral 
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

entity states_memwb is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           ctl_bubble : in  STD_LOGIC;
           ctl_copy : in  STD_LOGIC;
           ctl_rst : in  STD_LOGIC;
           in_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_alu_res : in  STD_LOGIC_VECTOR (15 downto 0);
           in_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           in_wr_reg : in  STD_LOGIC;
           in_mem_res : in  STD_LOGIC_VECTOR (15 downto 0);
           in_memwb_memalu_res_equal_rz : STD_LOGIC;
           in_memwb_wb_alu_mem : STD_LOGIC;
           out_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_alu_res : out  STD_LOGIC_VECTOR (15 downto 0);
           out_rc : out  STD_LOGIC_VECTOR (3 downto 0);
           out_wr_reg : out  STD_LOGIC;
           out_mem_res : out  STD_LOGIC_VECTOR (15 downto 0);
           out_memwb_wb_alu_mem : out STD_LOGIC;
           out_memwb_memalu_res_equal_rz : out STD_LOGIC);
end states_memwb;

architecture Behavioral of states_memwb is

begin
--process
process(clk,rst,ctl_bubble)
begin
	--clk up work
	if(clk'event and clk='1') then
		if(rst = '1') then
			out_pc <= (others=> '0');
			out_alu_res <= (others=> '0');
			out_rc <= (others=> '0');
			out_wr_reg <= '0';
			out_mem_res <= '0';
		elsif(ctl_bubble = '0') then
			out_pc <= in_pc;
			out_alu_res <= in_alu_res;
			out_rc <= in_rc;
			out_wr_reg <= in_wr_reg;
			out_mem_res <= in_mem_res;
		end if;
	end if;
	
	
end process;


end Behavioral;

