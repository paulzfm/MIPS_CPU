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
           debug : out STD_LOGIC_VECTOR(15 downto 0);
           debug_control_ins : in STD_LOGIC_VECTOR(15 downto 0);
           in_brk_come : in STD_LOGIC
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
signal registers_debug_in : STD_LOGIC_VECTOR(3 downto 0);
signal registers_debug_out : STD_LOGIC_VECTOR(15 downto 0);
-- predict
signal predict_in_predict_res : STD_LOGIC;
signal predict_in_jump_reg, predict_in_idalu_rc, predict_in_alumem_rc,
    predict_in_memwb_rc : STD_LOGIC_VECTOR(3 downto 0);
signal predict_in_jump_reg_data, predict_in_alu_res, predict_in_alumem_alu_res,
    predict_in_memwb_alumem_res : STD_LOGIC_VECTOR(15 downto 0);
signal predict_in_idalu_alu_res_equal_rc, predict_in_alumem_alu_res_equal_rc,
    predict_in_memwb_alumem_res_equal_rc: STD_LOGIC;
signal predict_in_branch_imm, predict_out_branch_imm,
    predict_out_jump_reg_data: STD_LOGIC_VECTOR(15 downto 0);
signal predict_out_ctl_predict : STD_LOGIC_VECTOR(1 downto 0);
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
signal alu_out_alu_res, alu_out_alu_final_res, alu_add_out_alu_res, alu_equal_out_alu_res : STD_LOGIC_VECTOR(15 downto 0);
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
signal states_memwb_ctl_bubble, states_memwb_ctl_rst, states_memwb_ctl_copy :
    STD_LOGIC;
-- center controllor
signal center_controllor_out_predict_err : STD_LOGIC;
signal center_controllor_out_branch_alu_pc_imm : STD_LOGIC;
signal out_is_alumem_lwsw_instruction : STD_LOGIC;
signal out_is_alu_lw : STD_LOGIC;
signal center_controllor_out_idalu_alu_res_addr : STD_LOGIC_VECTOR(1 downto 0);
signal center_controllor_debug_predict_pc_addr0, center_controllor_debug_predict_pc_addr1, center_controllor_debug_predict_pc_addr2
: STD_LOGIC_VECTOR(15 downto 0);
signal center_controllor_debug_predict_res : STD_LOGIC_VECTOR(16 downto 0);
-- brk
signal center_controllor_out_brk_jump_pc : STD_LOGIC_VECTOR(15 downto 0);
signal center_controllor_out_brk_jump : STD_LOGIC;
signal pc_s_inc_imm_or_brk_jump_pc : STD_LOGIC_VECTOR(15 downto 0);
signal decode_out_brk_return : STD_LOGIC;



begin
    
    out_pc <= pc_output;
    pc_instance : entity work.pc port map(
        clk => clk,
        wr => pc_wr,
        input => pc_input,
        output => pc_output,
        rst => rst
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
        in_data_b => predict_out_branch_imm,
        out_output => pc_inc_imm,
        out_t => pc_t1
    );
    -- input pc_s + 1
    -- output pc_s + 1 + extend_Imm
    pc_inc_imm_branch_add16_instance : entity work.add16 port map(
        in_data_a => states_idalu_out_pc_inc,
        in_data_b => states_idalu_out_imm,
        out_output => pc_s_inc_imm,
        out_t => pc_t2
    );
    -- mux4 input pc+1 pc+1+imm jr_reg
    pc_no_error_mux4_instance : entity work.mux4 port map(
        input0 => pc_inc,
        input1 => pc_inc_imm,
        input2 => predict_out_jump_reg_data,
        input3 => ZERO_16,
        addr => predict_out_ctl_predict,
        output => pc_no_error
    );
    -- mux2 input pc_s+1 pc_s+1+imm
    pc_yes_brk_mux2_instance : entity work.mux2 port map(
        input0 => pc_s_inc_imm,
        input1 => center_controllor_out_brk_jump_pc,
        addr => center_controllor_out_brk_jump,
        output => pc_s_inc_imm_or_brk_jump_pc
	 );
    -- mux2 input pc_s+1 pc_s+1+imm
    pc_yes_error_mux2_instance : entity work.mux2 port map(
        input0 => states_idalu_out_pc_inc,
        input1 => pc_s_inc_imm_or_brk_jump_pc,
        addr => center_controllor_out_branch_alu_pc_imm,
        output => pc_yes_error
	 );
     -- mux2 input no_error yes_error
     pc_error_yes_or_no_mux2_instance : entity work.mux2 port map(
        input0 => pc_no_error,
        input1 => pc_yes_error,
        addr => center_controllor_out_predict_err,
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
        out_memwb_wb_alu_mem => decode_out_memwb_wb_alu_mem,
        
        out_brk_return => decode_out_brk_return
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
        data_c => registers_data_c,
		  debug_in => registers_debug_in,
		  debug_out => registers_debug_out
    );


    predict_in_jump_reg <= decode_out_ra;
    predict_in_jump_reg_data <= registers_data_a;
    predict_in_idalu_alu_res_equal_rc <= states_idalu_out_alumem_alu_res_equal_rc;
    predict_in_idalu_rc <= states_idalu_out_rc;
    predict_in_alu_res <= alu_out_alu_final_res;
    predict_in_alumem_rc <= states_alumem_out_rc;
    predict_in_alumem_alu_res_equal_rc <= states_alumem_out_alumem_alu_res_equal_rc;
    predict_in_alumem_alu_res <= states_alumem_out_alu_res;
    predict_in_memwb_rc <= states_memwb_out_rc;
    predict_in_memwb_alumem_res_equal_rc <= registers_wr;
    predict_in_memwb_alumem_res <= registers_data_c;
    predict_in_branch_imm <= extend_imm;
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
    alu_data_mux_alu_mem_forward_data <= states_alumem_out_alu_res;
    alu_data_mux_mem_wb_forward_data <= registers_data_c;
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
    alu_add_instance : entity work.alu_adds port map(
        in_data_a => alu_data_mux_a_output,
        in_data_b => alu_data_mux_b_output,
        in_op => states_idalu_out_alu_op,
        out_alu_res => alu_add_out_alu_res
    );
    alu_equal_instance : entity work.alu_equal port map(
        in_data_a => alu_data_mux_a_output,
        in_data_b => alu_data_mux_b_output,
        in_op => states_idalu_out_alu_op,
        out_alu_res => alu_equal_out_alu_res
    );
    alu_data_res_mux : entity work.mux4 port map(
        input0 => alu_add_out_alu_res,
        input1 => alu_equal_out_alu_res,
        input2 => alu_out_alu_res,
        input3 => ZERO_16,
        addr => center_controllor_out_idalu_alu_res_addr,
        output => alu_out_alu_final_res
    );

    states_alumem_instance : entity work.states_alumem port map(
        clk => clk,
        rst => rst,
        ctl_bubble => states_alumem_ctl_bubble,
        ctl_copy => states_alumem_ctl_copy,
        ctl_rst => states_alumem_ctl_rst,
        in_pc => states_idalu_out_pc,
        in_pc_inc => states_idalu_out_pc_inc,
        in_alu_res => alu_out_alu_final_res,
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

     center_controllor_instance : entity work.center_controllor port map(
        out_bubble_ifid => states_ifid_ctl_bubble,
        out_bubble_idalu => states_idalu_ctl_bubble,
        out_bubble_alumem => states_alumem_ctl_bubble,
        out_bubble_memwb => states_memwb_ctl_bubble,
        out_rst_ifid => states_ifid_ctl_rst,
        out_rst_idalu => states_idalu_ctl_rst,
        out_rst_alumem => states_alumem_ctl_rst,
        out_rst_memwb => states_memwb_ctl_rst,
        out_forward_alu_a => alu_data_mux_a_addr,
        out_forward_alu_b => alu_data_mux_b_addr,
        out_forward_alu_d => alu_data_mux_d_addr,
        out_predict_err => center_controllor_out_predict_err,
        out_predict_res => predict_in_predict_res,
        out_branch_alu_pc_imm => center_controllor_out_branch_alu_pc_imm,
        out_idalu_alu_res_addr => center_controllor_out_idalu_alu_res_addr,
        -- out_idalu_pc_inc => ,
        out_pc_wr => pc_wr,

        out_is_alumem_lwsw_instruction => out_is_alumem_lwsw_instruction,
        out_is_alu_lw => out_is_alu_lw,

        in_decode_ra  => decode_out_ra,
        in_decode_rb  => decode_out_rb,
        in_decode_is_branch_except_b => decode_out_ctl_is_branch_except_b,
        in_decode_is_b => decode_out_ctl_is_b,
        in_decode_is_jump => decode_out_ctl_is_jump,

        in_idalu_rd_mem => states_idalu_out_rd_mem,
        in_idalu_wr_mem => states_idalu_out_wr_mem,
        in_idalu_ra => states_idalu_out_ra,
        in_idalu_rb => states_idalu_out_rb,
        in_idalu_rc => states_idalu_out_rc,
        in_idalu_rd => states_idalu_out_rd,
        in_idalu_use_imm_ry => states_idalu_out_use_imm,
        in_idalu_alu_op => states_idalu_out_alu_op,

        -- in_idalu_pc_inc : in STD_LOGIC_VECTOR(15 downto 0);
        in_alu_add_res => alu_add_out_alu_res,
        in_alu_equal_res => alu_equal_out_alu_res,
        in_idalu_is_branch_except_b => states_idalu_out_is_branch_except_b,
        in_alumem_alu_res => states_alumem_out_alu_res,
        in_alumem_rc => states_alumem_out_rc,
        in_alumem_wr_mem => states_alumem_out_wr_mem,
        in_alumem_rd_mem => states_alumem_out_rd_mem,
        in_alumem_alu_res_equal_rc => states_alumem_out_alumem_alu_res_equal_rc,
        in_memwb_rc => states_memwb_out_rc,
        in_memwb_wr_reg => registers_wr,
        in_key_interrupt => '0',
        
        --brk port
        in_brk_come => in_brk_come,
        in_ifid_pc => states_ifid_out_pc,
        in_idalu_pc => states_idalu_out_pc,
        in_brk_return => decode_out_brk_return,
        out_brk_jump_pc => center_controllor_out_brk_jump_pc,
        out_brk_jump => center_controllor_out_brk_jump,

        debug_predict_pc_addr0 => center_controllor_debug_predict_pc_addr0,
        debug_predict_pc_addr1 => center_controllor_debug_predict_pc_addr1,
        debug_predict_pc_addr2 => center_controllor_debug_predict_pc_addr2,
        debug_predict_res => center_controllor_debug_predict_res,

        clk => clk,
        rst => rst
     );


    process ( debug_control_ins, registers_debug_out)
    begin

        case debug_control_ins(15 downto 8) is
            when "00000000" =>
                debug <= pc_output;
            when "00000001" =>
                -- fetch register
                registers_debug_in <= debug_control_ins(7 downto 4);
                debug <= registers_debug_out;
            when "00000010" =>
                debug <= in_instruction_data;
            when "00000011" =>
                debug <= in_mem_data;
            when "00000100" =>
                debug <= states_ifid_out_instruction;
            when "00000101" =>
                debug <= states_ifid_out_pc_inc;
            when "00000110" =>
                debug <= ZERO_12 & decode_out_ra;
            when "00000111" =>
                debug <= ZERO_12 & decode_out_rb;
            when "00001000" =>
                debug <= ZERO_12 & decode_out_rc;
            when "00001001" =>
                debug <= decode_out_imm;
            when "00001010" =>
                debug <= ZERO_15 & decode_out_ctl_is_b;
            when "00001011" =>
                debug <= ZERO_15 & decode_out_ctl_is_branch_except_b;
            when "00001100" =>
                debug <= ZERO_15 & decode_out_ctl_is_jump;
            when "00001101" =>
                debug <= ZERO_15 & decode_out_memwb_wb_alu_mem;
            when "00001110" =>
                debug <= ZERO_15 & decode_out_use_imm;
            when "00001111" =>
                debug <= ZERO_15 & decode_out_ctl_imm_extend_type;
            when "00010000" =>
                debug <= ZERO_13 & decode_out_ctl_imm_extend_size;
            when "00010001" =>
                debug <= ZERO_15 & decode_out_alumem_alu_res_equal_rc;
            when "00010010" =>
                debug <= ZERO_12 & decode_ctl_alu_op;
            when "00010011" =>
                debug <= ZERO_15 & center_controllor_out_predict_err;
            when "00010100" =>
                debug <= ZERO_14 & predict_out_ctl_predict;
            when "00010101" =>
                debug <= ZERO_15 & predict_in_predict_res;
            when "00010110" =>
                debug <= ZERO_15 & states_idalu_out_is_branch_except_b;
            when "00010111" =>
                debug <= alu_out_alu_res;
            when "00011000" =>
                debug <= ZERO_12 & decode_out_ra;
            when "00011001" =>
                debug <= ZERO_12 & decode_out_rb;
            when "00011010" =>
                debug <= ZERO_12 & decode_out_rc;
            when "00011011" =>
                debug <= ZERO_15 & center_controllor_out_branch_alu_pc_imm;
            when "00011100" =>
                debug <= ZERO_15 & decode_out_use_imm;
            when "00011101" =>
                debug <= ZERO_15 & decode_ctl_read_mem;
            when "00011110" =>
                debug <= ZERO_15 & decode_ctl_write_mem;
            when "00011111" =>
                debug <= ZERO_15 & decode_ctl_write_reg;
            when "00100000" =>
				debug <= pc_input;
            when "00100001" =>
                debug <= ZERO_15 & states_alumem_out_rd_mem;
            when "00100010" =>
                debug <= ZERO_15 & states_alumem_out_wr_mem;
            when "00100011" =>
                debug <= ZERO_15 & states_idalu_ctl_bubble;
            when "00100100" =>
                debug <= ZERO_15 & states_alumem_ctl_bubble;
            when "00100101" =>
                debug <= ZERO_15 & states_memwb_ctl_bubble;
            when "00100110" =>
                debug <= ZERO_15 & states_idalu_ctl_rst;
            when "00100111" =>
                debug <= ZERO_15 & states_alumem_ctl_rst;
            when "00101000" =>
                debug <= ZERO_15 & states_memwb_ctl_rst;
            when "00101001" =>
                debug <= pc_no_error;
            when "00101010" =>
                debug <= pc_yes_error;
            when "00101011" =>
                debug <= extend_imm;
            when "00101100" =>
                debug <= decode_out_imm;
            when "00101101" =>
                debug <= predict_out_branch_imm;
            when "00101110" =>
                debug <= alu_data_mux_a_output;
            when "00101111" =>
                debug <= alu_data_mux_b_output;
            when "00110000" =>
                debug <= ZERO_12 & states_idalu_out_alu_op;
            when "00110001" =>
                debug <= ZERO_12 & decode_ctl_alu_op;
            when "00110010" =>
                debug <= ZERO_14 & alu_data_mux_a_addr;
            when "00110011" =>
                debug <= ZERO_14 & alu_data_mux_b_addr;
            when "00110100" =>
                debug <= ZERO_12 & states_alumem_out_rc;
            when "00110101" =>
                debug <= ZERO_15 & states_alumem_out_alumem_alu_res_equal_rc;
            when "00110110" =>
                debug <= states_alumem_out_alu_res;
            when "00110111" =>
                debug <= ZERO_12 & states_memwb_out_rc;
            when "00111000" =>
                debug <= ZERO_15 & registers_wr;
            when "00111001" =>
                debug <= registers_data_c;
            when "00111010" =>
                debug <= ZERO_15 & pc_wr;
            when "00111011" =>
                debug <= states_idalu_out_data_d;
            when "00111100" =>
                debug <= ZERO_14 & states_alumem_out_rd_mem & states_alumem_out_wr_mem;
            when "00111101" =>
                debug <= ZERO_15 & out_is_alumem_lwsw_instruction;
            when "00111110" =>
                debug <= ZERO_15 & out_is_alu_lw;
            when "00111111" =>
                debug <= ZERO_14 & alu_data_mux_d_addr;
            when "01000000" =>
                debug <= states_alumem_out_data_rd;
            when "01000001" =>
                debug <= states_memwb_out_mem_res;
            when "01000010" =>
                debug <= states_memwb_out_alu_res;
            when "01000011" =>
                debug <= ZERO_15 & states_memwb_out_memwb_wb_alu_mem;
            when "01000100" =>
                debug <= ZERO_13 & states_ifid_ctl_rst & states_ifid_ctl_copy & states_ifid_ctl_bubble;
            when "01000101" =>
                debug <= center_controllor_debug_predict_pc_addr0;
            when "01000110" =>
                debug <= center_controllor_debug_predict_pc_addr1;
            when "01000111" =>
                debug <= center_controllor_debug_predict_pc_addr2;
            when "01001000" =>
                debug <= center_controllor_debug_predict_res(15 downto 0);
            when "01001001" =>
                debug <= ZERO_15 & center_controllor_debug_predict_res(16);
            when others =>
                null;
        end case;
    end process;
end Behavioral;
