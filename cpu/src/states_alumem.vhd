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
           ctl_rst : in  STD_LOGIC;
           in_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_pc_inc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_alu_res : in  STD_LOGIC_VECTOR (15 downto 0);
           in_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           in_rd : in  STD_LOGIC_VECTOR (3 downto 0);
           in_data_rd : in  STD_LOGIC_VECTOR (15 downto 0);
           in_wr_reg : in  STD_LOGIC;
           in_wr_mem : in  STD_LOGIC;
           in_rd_mem : in  STD_LOGIC;
           in_alumem_alu_res_equal_rc : in STD_LOGIC;
           in_memwb_wb_alu_mem : in STD_LOGIC;
           out_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_pc_inc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_alu_res : out  STD_LOGIC_VECTOR (15 downto 0);
           out_rc : out  STD_LOGIC_VECTOR (3 downto 0);
           out_wr_reg : out  STD_LOGIC;
           out_wr_mem : out  STD_LOGIC;
           out_rd_mem : out  STD_LOGIC;
           out_rd : out  STD_LOGIC_VECTOR (3 downto 0);
           out_data_rd : out  STD_LOGIC_VECTOR (15 downto 0);
           out_alumem_alu_res_equal_rc : out STD_LOGIC;
           out_memwb_wb_alu_mem : out STD_LOGIC);
end states_alumem;

architecture Behavioral of states_alumem is
--signal s_pc : STD_LOGIC_VECTOR (15 downto 0);
--signal s_alu_res : STD_LOGIC_VECTOR (15 downto 0);
--signal s_rc : STD_LOGIC_VECTOR (3 downto 0);
--signal s_instruction5 : STD_LOGIC_VECTOR (4 downto 0);
--signal s_wr_reg : STD_LOGIC := '0';
--signal s_wr_mem : STD_LOGIC := '0';
--signal s_rd_mem : STD_LOGIC := '0';
begin
--process 
process(clk,rst,ctl_bubble,ctl_rst)
begin
	--rst async
	if(rst='1')then
	      --output all '0'
			out_pc <= (others=> '0');
			out_pc_inc <= (others=> '0');
			out_alu_res <= (others=> '0');
			out_rc <= (others=> '0');
            out_rd <= (others=> '0');
            out_data_rd <= (others=> '0');
			out_wr_reg <= '0';
			out_wr_mem <= '0';
			out_rd_mem <= '0';
			out_alumem_alu_res_equal_rc <= '0';
         out_memwb_wb_alu_mem <= '0';
	--clk up work
	elsif(clk'event and clk='1') then
		if(ctl_rst = '1') then
		--output all '0'
			out_pc <= (others=> '0');
			out_pc_inc <= (others=> '0');
			out_alu_res <= (others=> '0');
			out_rc <= (others=> '0');
            out_rd <= (others=> '0');
            out_data_rd <= (others=> '0');
			out_wr_reg <= '0';
			out_wr_mem <= '0';
			out_rd_mem <= '0';
			out_alumem_alu_res_equal_rc <= '0';
         out_memwb_wb_alu_mem <= '0';
		elsif(ctl_bubble = '0') then
			out_pc <= in_pc;
			out_pc_inc <= in_pc_inc;
			out_alu_res <= in_alu_res;
			out_rc <= in_rc;
            out_rd <= in_rd;
            out_data_rd <= in_data_rd;
			out_wr_reg <= in_wr_reg;
			out_wr_mem <= in_wr_mem;
			out_rd_mem <= in_rd_mem;
			out_alumem_alu_res_equal_rc <= in_alumem_alu_res_equal_rc;
         out_memwb_wb_alu_mem <= in_memwb_wb_alu_mem;
		end if;
	end if;
	
end process;

end Behavioral;

