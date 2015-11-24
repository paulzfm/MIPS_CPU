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
           out_mem_rdn : out  STD_LOGIC;
           out_mem_wrn : out  STD_LOGIC;
           out_mem_data : out STD_LOGIC_VECTOR(15 downto 0);
           out_mem_addr : out STD_LOGIC_VECTOR(15 downto 0);
           out_pc : out STD_LOGIC_VECTOR(15 downto 0);
           in_mem_data : in STD_LOGIC_VECTOR(15 downto 0);
           in_instruction_data : in STD_LOGIC_VECTOR(15 downto 0);
           debug : out STD_LOGIC_VECTOR(127 downto 0)
        );
end CPU;

architecture Behavioral of CPU is

-- pc
signal pc_wr, pc_t, pc_t1, pc_t2 : STD_LOGIC;
signal pc_input, pc_output, pc_inc, pc_inc_imm : STD_LOGIC_VECTOR(15 downto 0);
signal pc_s_inc_imm : STD_LOGIC_VECTOR(15 downto 0);
signal pc_no_error, pc_yes_error : STD_LOGIC_VECTOR(15 downto 0);
-- states ifid
signal states_ifid_out_pc, states_ifid_out_pc_inc, states_ifid_out_instruction : STD_LOGIC_VECTOR(15 downto 0);
signal states_ifid_ctl_bubble, states_ifid_ctl_rst, states_ifid_ctl_copy : STD_LOGIC;
-- decode
signal decode_out_ra, decode_out_rb, decode_out_rc : STD_LOGIC_VECTOR(3 downto 0);
signal decode_out_imm : STD_LOGIC_VECTOR(15 downto 0);
signal decode_ctl_write_reg, decode_ctl_write_mem, decode_ctl_read_mem : STD_LOGIC;
signal decode_ctl_alu_op : STD_LOGIC_VECTOR(3 downto 0);
signal decode_out_ctl_imm_extend_type : STD_LOGIC;
signal decode_out_ctl_imm_extend_size : STD_LOGIC_VECTOR(2 downto 0);
signal decode_out_ctl_is_jump, decode_out_ctl_is_b, decode_out_ctl_is_branch_except_b : STD_LOGIC;
signal decode_out_use_imm, decode_out_alumem_alu_res_equal_rc, decode_out_memwb_wb_alu_mem : STD_LOGIC;
-- extend
signal extend_imm : STD_LOGIC_VECTOR(15 downto 0);
-- registers
signal registers_wr : STD_LOGIC;
signal registers_data_a, registers_data_b, registers_data_c : STD_LOGIC_VECTOR(15 downto 0);
-- predict
signal predict_in_predict_res : STD_LOGIC;
signal predict_in_jump_reg, predict_in_idalu_rc, predict_in_alumem_rc, 
    predict_in_memwb_rc : STD_LOGIC_VECTOR(3 downto 0);
signal predict_in_jump_reg_data, predict_in_alu_res, predict_in_alumem_alu_res, 
    predict_in_memwb_alumem_res_equal_rc : STD_LOGIC_VECTOR(15 downto 0);
signal predict_in_idalu_alu_res_equal_rc, predict_in_alumem_alu_res_equal_rc, 
    predict_in_memwb_alumem_res_equal_rc: STD_LOGIC;
signal predict_in_branch_imm : STD_LOGIC_VECTOR(15 downto 0);
signal predict_out_ctl_predict : STD_LOGIC;
-- states idalu
signal states_idalu_out_ra, states_idalu_out_rb, states_idalu_out_rc, states_idalu_out_rd : STD_LOGIC_VECTOR(3 downto 0);
signal states_idalu_out_data_a, states_idalu_out_data_b, states_idalu_out_data_d : STD_LOGIC_VECTOR(15 downto 0);
signal states_idalu_out_alu_op : STD_LOGIC_VECTOR(3 downto 0);
signal states_idalu_out_pc, states_idalu_out_pc_inc : STD_LOGIC_VECTOR(15 downto 0);
signal states_idalu_out_imm : STD_LOGIC_VECTOR(15 downto 0);
signal states_idalu_out_alumem_alu_res_equal_rc, states_idalu_out_memwb_wb_alu_mem, states_idalu_out_is_branch_except_b : STD_LOGIC;
signal states_idalu_ctl_bubble, states_idalu_ctl_copy, states_idalu_ctl_rst : STD_LOGIC;
signal states_idalu_out_wr_reg, states_idalu_out_wr_mem, states_idalu_out_rd_mem, states_idalu_out_use_imm : STD_LOGIC;
-- alu data mux
signal alu_data_mux_a_addr : STD_LOGIC_VECTOR(1 downto 0);
signal alu_data_mux_alu_mem_forward_data, alu_data_mux_mem_wb_forward_data, 
    alu_data_mux_a_output: STD_LOGIC_VECTOR(15 downto 0);
signal alu_data_mux_b_addr, alu_data_mux_d_addr : STD_LOGIC_VECTOR(1 downto 0);
signal alu_data_mux_b_output, alu_data_mux_d_output: STD_LOGIC_VECTOR(15 downto 0);
-- alu
signal alu_out_alu_res : STD_LOGIC_VECTOR(15 downto 0);
-- states alumem
signal states_alumem_ctl_bubble, states_alumem_ctl_rst, states_alumem_ctl_copy : STD_LOGIC;
signal states_alumem_out_pc, states_alumem_out_pc_inc, states_alumem_out_alu_res : STD_LOGIC_VECTOR(15 downto 0);
signal states_alumem_out_rc : STD_LOGIC_VECTOR(3 downto 0);
signal states_alumem_out_wr_reg, states_alumem_out_wr_mem, states_alumem_out_rd_mem,
    states_alumem_out_alumem_alu_res_equal_rc, states_alumem_out_memwb_wb_alu_mem : STD_LOGIC;
signal states_alumem_out_data_rd : STD_LOGIC_VECTOR(15 downto 0);
signal states_alumem_out_rd : STD_LOGIC_VECTOR(3 downto 0);
-- states memwb
signal states_memwb_out_alu_res : STD_LOGIC_VECTOR(15 downto 0);
signal states_memwb_out_rc : STD_LOGIC_VECTOR(3 downto 0);
signal states_memwb_out_mem_res : STD_LOGIC_VECTOR(15 downto 0);
signal states_memwb_out_memwb_wb_alu_mem : STD_LOGIC;

begin
    out_pc <= pc_output;
    pc_instance : entity work.pc port map(
        clk => clk,
        wr => pc_wr,
        input => pc_input,
        output => pc_output
    );
    -- input pc_output
    -- output pc_output + 1
    pc_inc_add16_instance : entity work.add16 port map(
        in_data_a => pc_output,
        in_data_b => SIGNAL_ONE,
        out_output => pc_inc,
        out_t => pc_t
    );
    -- input pc + 1
    -- output pc + 1 + extend_Imm
    pc_inc_imm_add16_instance : entity work.add16 port map(
        in_data_a => pc_inc,
        in_data_b => extend_imm,
        out_output => pc_inc_imm,
        out_t => pc_t1
    );
    -- input pc_s + 1
    -- output pc_s + 1 + extend_Imm
    pc_inc_imm_add16_instance : entity work.add16 port map(
        in_data_a => states_idalu_out_pc_inc,
        in_data_b => predict_out_branch_imm,
        out_output => pc_s_inc_imm,
        out_t => pc_t2
    );
    -- mux4 input pc+1 pc+1+imm jr_reg
    pc_no_error_mux4_instance : entity work.mux4 port map(
        input0 => pc_inc,
        input1 => pc_inc_imm,
        input2 => registers_data_a,
        input3 => ZERO_16,
        addr => null,
        output => pc_no_error
    );
    -- mux2 input pc_s+1 pc_s+1+imm
    pc_yes_error_mux2_instance : entity work.mux2 port map(
        input0 => states_idalu_out_pc_inc,
        input1 => pc_s_inc_imm,
        addr => null,
        output => pc_yes_error
	 );
     -- mux2 input no_error yes_error
     pc_error_yes_or_no_mux2_instance : entity work.mux2 port map(
        input0 => pc_no_error,
        input1 => pc_yes_error,
        addr => null,
        output => pc_input
	 );

    states_ifid_instance : entity work.states_ifid port map(
        in_pc => pc_output,
        in_pc_inc => pc_inc,
        in_instruction => in_instruction_data,
        out_pc => states_ifid_out_pc,
        out_pc_inc => states_ifid_out_pc_inc,
        out_instruction => states_ifid_out_instruction,
        clk => clk,  
        rst => rst, 
        ctl_bubble => states_ifid_ctl_bubble,
        ctl_copy => states_ifid_ctl_copy,
        ctl_rst => states_ifid_ctl_rst
    );

    decode_instance : entity work.decode port map(
        in_instruction => states_ifid_out_instruction,
        in_pc_inc => states_ifid_out_pc_inc,
        out_ra => decode_out_ra,
        out_rb => decode_out_rb,
        out_rc => decode_out_rc,
        out_imm => decode_out_imm,
        out_ctl_write_reg => decode_ctl_write_reg,
        out_ctl_write_mem => decode_ctl_write_mem,
        out_ctl_read_mem => decode_ctl_read_mem,
        out_ctl_alu_op => decode_ctl_alu_op,
        out_ctl_imm_extend_size => decode_out_ctl_imm_extend_size,
        out_ctl_imm_extend_type => decode_out_ctl_imm_extend_type,
        out_ctl_is_jump => decode_out_ctl_is_jump,
        out_ctl_is_b => decode_out_ctl_is_b,
        out_ctl_is_branch_except_b => decode_out_ctl_is_branch_except_b,
        out_use_imm => decode_out_use_imm,
        out_alumem_alu_res_equal_rc => decode_out_alumem_alu_res_equal_rc,
        out_memwb_wb_alu_mem => decode_out_memwb_wb_alu_mem
    );

    extend_instance : entity work.extend port map(
        ctl_size => decode_out_ctl_imm_extend_size,
        ctl_type => decode_out_ctl_imm_extend_type,
        input => decode_out_imm,
        output => extend_imm
    );

    registers_instance : entity work.registers port map(
        clk => clk, 
        rst => rst,
        wr => registers_wr,
        addr_a => decode_out_ra,
        addr_b => decode_out_rb,
        addr_c => states_memwb_out_rc,
        data_a => registers_data_a,
        data_b => registers_data_b,
        data_c => registers_data_c
    );


    predict_in_jump_reg <= decode_out_ra;
    predict_in_jump_reg_data <= registers_data_a;
    -- todo
    predict_instance : entity work.predict port map(
        rst => rst,
        in_is_jump => decode_out_ctl_is_jump,
        in_is_b => decode_out_ctl_is_b,
        in_is_branch_except_b => decode_out_ctl_is_branch_except_b,
        in_predict_res => predict_in_predict_res,
        in_jump_reg => predict_in_jump_reg,
        in_jump_reg_data => predict_in_jump_reg_data, 

        in_idalu_alu_res_equal_rc => predict_in_idalu_alu_res_equal_rc,
        in_idalu_rc => predict_in_idalu_rc,
        in_alu_res => predict_in_alu_res,

        in_alumem_rc => predict_in_alumem_rc,
        in_alumem_alu_res_equal_rc => predict_in_alumem_alu_res_equal_rc,
        in_alumem_alu_res => predict_in_alumem_alu_res, 

        in_memwb_rc => predict_in_memwb_rc, 
        in_memwb_alumem_res_equal_rc => predict_in_memwb_alumem_res_equal_rc,
        in_memwb_alumem_res => predict_in_memwb_alumem_res,

        in_branch_imm => predict_in_branch_imm,
        out_jump_reg_data => predict_out_jump_reg_data,
        out_branch_imm => predict_out_branch_imm,
        out_ctl_predict => predict_out_ctl_predict
    );
    
    states_idalu_instance : entity work.states_idalu port map(
        in_ra => decode_out_ra,
        in_rb => decode_out_rb,
        in_rc => decode_out_rc,
        in_data_a => registers_data_a,
        in_data_b => registers_data_b,
        in_alu_op => decode_ctl_alu_op,
        in_pc => states_ifid_out_pc,
        in_pc_inc => states_ifid_out_pc_inc,
        in_imm => extend_imm,
        in_wr_reg => decode_ctl_write_reg,
        in_wr_mem => decode_ctl_write_mem,
        in_rd_mem => decode_ctl_read_mem,
        in_use_imm => decode_out_use_imm,
        in_alumem_alu_res_equal_rc => decode_out_alumem_alu_res_equal_rc,
        in_memwb_wb_alu_mem => decode_out_memwb_wb_alu_mem,
        in_is_branch_except_b => decode_out_ctl_is_branch_except_b,
        out_ra => states_idalu_out_ra,
        out_rb => states_idalu_out_rb,
        out_rc => states_idalu_out_rc,
        out_rd => states_idalu_out_rd,
        out_data_a => states_idalu_out_data_a,
        out_data_b => states_idalu_out_data_b,
        out_data_d => states_idalu_out_data_d,
        out_alu_op => states_idalu_out_alu_op,
        out_pc => states_idalu_out_pc,
        out_pc_inc => states_idalu_out_pc_inc,
        out_imm => states_idalu_out_imm,
        out_alumem_alu_res_equal_rc => states_idalu_out_alumem_alu_res_equal_rc,
        out_memwb_wb_alu_mem => states_idalu_out_memwb_wb_alu_mem,
        out_is_branch_except_b => states_idalu_out_is_branch_except_b,
        ctl_bubble => states_idalu_ctl_bubble,
        ctl_copy => states_idalu_ctl_copy,
        ctl_rst => states_idalu_ctl_rst,
        clk => clk,
        rst => rst,
        out_wr_reg => states_idalu_out_wr_reg,
        out_wr_mem => states_idalu_out_wr_mem,
        out_rd_mem => states_idalu_out_rd_mem,
        out_use_imm => states_idalu_out_use_imm
    );

    alu_data_mux_a_instance : entity work.mux4 port map(
        input0 => states_idalu_out_data_a,
        input1 => alu_data_mux_alu_mem_forward_data,
        input2 => alu_data_mux_mem_wb_forward_data,
        input3 => ZERO_16,
        addr => alu_data_mux_a_addr,
        output => alu_data_mux_a_output
    );

    alu_data_mux_b_instance : entity work.mux4 port map(
        input0 => states_idalu_out_data_b,
        input1 => alu_data_mux_alu_mem_forward_data,
        input2 => alu_data_mux_mem_wb_forward_data,
        input3 => states_idalu_out_imm,
        addr => alu_data_mux_b_addr,
        output => alu_data_mux_b_output
    );

    alu_data_mux_d_instance : entity work.mux4 port map(
        input0 => states_idalu_out_data_d,
        input1 => alu_data_mux_alu_mem_forward_data,
        input2 => alu_data_mux_mem_wb_forward_data,
        input3 => ZERO_16,
        addr => alu_data_mux_d_addr,
        output => alu_data_mux_d_output
    );

    alu_instance : entity work.ALU port map(
        in_data_a => alu_data_mux_a_output,
        in_data_b => alu_data_mux_b_output,
        in_op => states_idalu_out_alu_op,
        out_alu_res => alu_out_alu_res
    );

    states_alumem_instance : entity work.states_alumem port map(
        clk => clk,
        rst => rst,
        ctl_bubble => states_alumem_ctl_bubble,
        ctl_copy => states_alumem_ctl_copy,
        ctl_rst => states_alumem_ctl_rst,
        in_pc => states_idalu_out_pc,
        in_pc_inc => states_idalu_out_pc_inc,
        in_alu_res => alu_out_alu_res,
        in_rc => states_idalu_out_rc,
        in_rd => states_idalu_out_rd,
        in_data_rd => alu_data_mux_d_output,
        in_wr_reg => states_idalu_out_wr_reg,
        in_wr_mem => states_idalu_out_wr_mem,
        in_rd_mem => states_idalu_out_rd_mem,
        in_alumem_alu_res_equal_rc => states_idalu_out_alumem_alu_res_equal_rc,
        in_memwb_wb_alu_mem => states_idalu_out_memwb_wb_alu_mem,
        out_pc => states_alumem_out_pc,
        out_pc_inc => states_alumem_out_pc_inc,
        out_alu_res => states_alumem_out_alu_res, 
        out_rc => states_alumem_out_rc,
        out_rd => states_alumem_out_rd,
        out_data_rd => states_alumem_out_data_rd,
        out_wr_reg => states_alumem_out_wr_reg,
        out_wr_mem => states_alumem_out_wr_mem,
        out_rd_mem => states_alumem_out_rd_mem,
        out_alumem_alu_res_equal_rc => states_alumem_out_alumem_alu_res_equal_rc,
        out_memwb_wb_alu_mem => states_alumem_out_memwb_wb_alu_mem
    );
	 out_mem_wrn <= states_alumem_out_wr_mem;
     out_mem_rdn <= states_alumem_out_rd_mem;
     out_mem_addr <= states_alumem_out_alu_res;
     out_mem_data <= states_alumem_out_data_rd;
     
	 states_memwb_instance : entity work.states_memwb port map(
        clk => clk,
        rst => rst,
        ctl_bubble => states_memwb_ctl_bubble,
        ctl_copy => states_memwb_ctl_copy,
        ctl_rst => states_memwb_ctl_rst,
        in_alu_res => states_alumem_out_alu_res,
        in_rc => states_alumem_out_rc,
        in_wr_reg => states_alumem_out_wr_reg,
        in_mem_res => in_mem_data,
        in_memwb_wb_alu_mem => states_alumem_out_memwb_wb_alu_mem,
        out_alu_res => states_memwb_out_alu_res,
        out_rc => states_memwb_out_rc,
        out_wr_reg => registers_wr,
        out_mem_res => states_memwb_out_mem_res,
        out_memwb_wb_alu_mem => states_memwb_out_memwb_wb_alu_mem
    );
	 
	 wb_mux2_mem_or_alu_res_instance : entity work.mux2 port map(
        input0 => states_memwb_out_alu_res,
        input1 => states_memwb_out_mem_res,
        addr => states_memwb_out_memwb_wb_alu_mem,
        output => registers_data_c
	 );
end Behavioral;

