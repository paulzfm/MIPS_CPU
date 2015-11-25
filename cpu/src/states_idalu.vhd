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
           in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           in_alu_op : in  STD_LOGIC_VECTOR (3 downto 0);
           in_pc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_pc_inc : in  STD_LOGIC_VECTOR (15 downto 0);
           in_imm : in  STD_LOGIC_VECTOR (15 downto 0);
           in_wr_reg : in  STD_LOGIC;
           in_wr_mem : in  STD_LOGIC;
           in_rd_mem : in  STD_LOGIC;
           in_use_imm : in  STD_LOGIC;
           in_alumem_alu_res_equal_rc : in STD_LOGIC;
           in_memwb_wb_alu_mem : in STD_LOGIC;
           in_is_branch_except_b : in STD_LOGIC;
           out_ra : out  STD_LOGIC_VECTOR (3 downto 0);
           out_rb : out  STD_LOGIC_VECTOR (3 downto 0);
           out_rc : out  STD_LOGIC_VECTOR (3 downto 0);
           out_rd : out  STD_LOGIC_VECTOR (3 downto 0);
           out_data_a : out  STD_LOGIC_VECTOR (15 downto 0);
           out_data_b : out  STD_LOGIC_VECTOR (15 downto 0);
           out_data_d : out STD_LOGIC_VECTOR(15 downto 0);

           out_alu_op : out  STD_LOGIC_VECTOR (3 downto 0);
           out_pc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_pc_inc : out  STD_LOGIC_VECTOR (15 downto 0);
           out_imm : out  STD_LOGIC_VECTOR (15 downto 0);
           out_alumem_alu_res_equal_rc : out STD_LOGIC;
           out_memwb_wb_alu_mem : out STD_LOGIC;
           out_is_branch_except_b : out STD_LOGIC;
           ctl_bubble : in  STD_LOGIC;
           ctl_copy : in  STD_LOGIC;
           ctl_rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           out_wr_reg : out  STD_LOGIC;
           out_wr_mem : out  STD_LOGIC;
           out_rd_mem : out  STD_LOGIC;
           out_use_imm : out  STD_LOGIC

           );
end states_idalu;

architecture Behavioral of states_idalu is

begin
--process


process(clk,rst,ctl_bubble)
begin
	--rst async
	if(rst='1')then
	      out_ra <= (others=> '0');
			out_rb <= (others=> '0');
			out_rc <= (others=> '0');
            out_rd <= (others=> '0');
			out_data_a <= (others=> '0');
			out_data_b <= (others=> '0');
            out_data_d <= (others=> '0');
			out_alu_op <= (others=> '0');

			out_pc <= (others=> '0');
			out_pc_inc <= (others=> '0');
			out_imm <= (others=> '0');
			out_alumem_alu_res_equal_rc <= '0';
         out_memwb_wb_alu_mem <= '0';
         out_is_branch_except_b <= '0';
			out_wr_reg <= '0';
			out_wr_mem <= '0';
			out_rd_mem <= '0';
			out_use_imm <= '0';
	--clk up work
	elsif(clk'event and clk='1') then
		if(ctl_rst = '1') then
			out_ra <= (others=> '0');
			out_rb <= (others=> '0');
            out_rd <= (others=> '0');
			out_rc <= (others=> '0');
			out_data_a <= (others=> '0');
			out_data_b <= (others=> '0');
            out_data_d <= (others=> '0');
			out_alu_op <= (others=> '0');

			out_pc <= (others=> '0');
			out_pc_inc <= (others=> '0');
			out_imm <= (others=> '0');
			out_alumem_alu_res_equal_rc <= '0';
         out_memwb_wb_alu_mem <= '0';
			out_wr_reg <= '0';
			out_wr_mem <= '0';
			out_rd_mem <= '0';
			out_use_imm <= '0';
            out_is_branch_except_b <= '0';
		elsif(ctl_bubble = '0') then
			out_ra <= in_ra;
			out_rb <= in_rb;
			out_rc <= in_rc;
            out_rd <= in_rb;
			out_data_a <= in_data_a;
			out_data_b <= in_data_b;
            out_data_d <= in_data_b;
			out_alu_op <= in_alu_op;
			out_pc <= in_pc;
			out_pc_inc <= in_pc_inc;
			out_imm <= in_imm;
			out_wr_reg <= in_wr_reg;
			out_wr_mem <= in_wr_mem;
			out_rd_mem <= in_rd_mem;
			out_use_imm <= in_use_imm;
            out_is_branch_except_b <= in_is_branch_except_b;
		end if;
	end if;
	
end process;

end Behavioral;

