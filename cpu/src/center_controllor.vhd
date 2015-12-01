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
use work.constants.ALL;
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
           out_forward_alu_d : out  STD_LOGIC_VECTOR (1 downto 0);
           out_predict_err : out  STD_LOGIC;
           out_predict_res : out  STD_LOGIC;
           out_branch_alu_pc_imm : out  STD_LOGIC;
           out_pc_wr : out STD_LOGIC;
           -- debug
           out_is_alumem_lwsw_instruction : out STD_LOGIC;
           out_is_alu_lw : out STD_LOGIC;
           out_idalu_alu_res_addr : out STD_LOGIC_VECTOR(1 downto 0);
           in_decode_ra  : in  STD_LOGIC_VECTOR (3 downto 0);
           in_decode_rb  : in  STD_LOGIC_VECTOR (3 downto 0);
           in_decode_is_jump : in STD_LOGIC;
           in_decode_is_branch_except_b : in STD_LOGIC;
           in_decode_is_b : in STD_LOGIC;

           in_idalu_rd_mem : in STD_LOGIC;
           in_idalu_wr_mem : in STD_LOGIC;
           in_idalu_ra : in  STD_LOGIC_VECTOR (3 downto 0);
           in_idalu_rb : in  STD_LOGIC_VECTOR (3 downto 0);
           in_idalu_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           in_idalu_rd : in  STD_LOGIC_VECTOR (3 downto 0);
           in_idalu_use_imm_ry : STD_LOGIC;
           in_idalu_alu_op : STD_LOGIC_VECTOR(3 downto 0);
           in_alu_add_res : in  STD_LOGIC_VECTOR (15 downto 0);
           in_alu_equal_res : in  STD_LOGIC_VECTOR (15 downto 0);
           in_idalu_is_branch_except_b : in STD_LOGIC;
           in_alumem_alu_res : in STD_LOGIC_VECTOR(15 downto 0);
           in_alumem_rc : in  STD_LOGIC_VECTOR (3 downto 0);
           in_alumem_wr_mem : in STD_LOGIC;
           in_alumem_rd_mem : in STD_LOGIC;
           in_alumem_alu_res_equal_rc : in STD_LOGIC;
           in_memwb_rc : in STD_LOGIC_VECTOR(3 downto 0);
           in_memwb_wr_reg : in STD_LOGIC;
           in_key_interrupt : in  STD_LOGIC;
           
           --brk port
           in_brk_come : in STD_LOGIC; -- key FIFO send to me   1 = come    0 = none
           in_ifid_pc : in STD_LOGIC_VECTOR(15 downto 0);
           in_idalu_pc : in STD_LOGIC_VECTOR(15 downto 0);


           clk : in  STD_LOGIC;
           rst : in STD_LOGIC);
end center_controllor;

architecture Behavioral of center_controllor is

signal pipeline_stop_time : integer range 0 to 15;
-- predict_res is data that whether next B is true or false
signal predict_res : STD_LOGIC;

-- predict_error means the predict_res is not equal to the alu result,
-- will output to out_predict_error as a control signal.
signal predict_error : STD_LOGIC;

-- is_alu_lw means that decode contains a instruction that will use register
-- and idalu contains a lw instruction with same register.
-- is_alu_lw also contains this situation that the idalu contains a lwsw and
-- decode is a branch instruction.
signal is_alu_lw : STD_LOGIC;
-- is_alumem_lwsw_instruction means alumem has lwsw instruction, so
-- we will ignore next pc.
signal is_alumem_lwsw_instruction : STD_LOGIC;
-- is_alumem_swlw_instruction will return weather alumem contain a
-- sw to instruction memory
-- signal is_alumem_swlw_instruction : STD_LOGIC;

     --brk signal
     signal is_doing_brk : STD_LOGIC;
     signal brk_pc_wr : STD_LOGIC;
     signal brk_rst : STD_LOGIC;
     signal brk_jump : STD_LOGIC;
     signal brk_state : STD_LOGIC_VECTOR(2 downto 0);
     signal brk_return_addr : STD_LOGIC_VECTOR(15 downto 0);
     --end

begin
    out_predict_res <= predict_res;
    out_predict_err <= predict_error;

    --debug
    out_is_alumem_lwsw_instruction <= is_alumem_lwsw_instruction;
    out_is_alu_lw <= is_alu_lw;

    --calc_is_alumem_swlw_instruction:
    --process (rst, in_alumem_wr_mem, in_alumem_alu_res, in_alumem_rd_mem)
    --begin
    --    if (rst = '1')
    --    then
    --        is_alumem_swlw_instruction <= '0';
    --    else
    --        if ((in_alumem_wr_mem = '1' or in_alumem_rd_mem = '0') and in_alumem_alu_res(15) = '0')
    --        then
    --            is_alumem_swlw_instruction <= '1';
    --        else
    --            is_alumem_swlw_instruction <= '0';
    --        end if;
    --    end if;
    --end process;

    calc_predict_error:
    process (in_alu_equal_res, predict_res, in_idalu_is_branch_except_b)
    begin
        
            if (predict_res /= in_alu_equal_res(0) and in_idalu_is_branch_except_b = '1')
            then
                predict_error <= '1';
            else
                predict_error <= '0';
            end if;
        
    end process;

    calc_predict_res:
    process (clk, in_idalu_is_branch_except_b)
    begin
        
            if (rising_edge(clk))
            then
                if (in_idalu_is_branch_except_b = '1')
                then
                    predict_res <= in_alu_equal_res(0);
                end if;
            end if;
        
    end process;

    calc_out_pc_wr:
    process (is_alumem_lwsw_instruction, is_alu_lw)
    begin
        
            if (is_alu_lw = '1' or is_alumem_lwsw_instruction = '1')
            then
                out_pc_wr <= '0';
            else
                out_pc_wr <= '1';
            end if;
        
    end process;

    calc_is_alu_lw:
    process (in_idalu_rc, in_decode_ra, in_decode_rb,
        in_idalu_rd_mem, in_idalu_wr_mem, in_alu_add_res, in_decode_is_branch_except_b)
    variable reg_same : STD_LOGIC;
    begin
      
            reg_same := '0';
            if (in_idalu_rc = in_decode_ra or in_idalu_rc = in_decode_rb)
            then
                reg_same := '1';
            end if;

            if ((in_idalu_rd_mem = '1' and reg_same = '1') or
                ((in_idalu_rd_mem = '1' or in_idalu_wr_mem = '1') and in_alu_add_res(15) = '0' and in_decode_is_branch_except_b = '1') )
            then
                is_alu_lw <= '1';
            else
                is_alu_lw <= '0';
            end if;

        
    end process;
    calc_is_alumem_lwsw_instruction:
    process (in_alumem_wr_mem, in_alumem_rd_mem, in_alumem_alu_res)
    begin
        
            if ((in_alumem_wr_mem = '1' or in_alumem_rd_mem = '1') and in_alumem_alu_res(15) = '0')
            then
                is_alumem_lwsw_instruction <= '1';
            else
                is_alumem_lwsw_instruction <= '0';
            end if;
        
    end process;

    calc_out_forward_alu_a:
    process (in_alumem_rc, in_idalu_ra,
        in_alumem_alu_res_equal_rc, in_memwb_wr_reg, in_memwb_rc )
    begin
        -- 00 select origin A
        -- 01 select alu/memory data
        -- 10 select memory/wb data

        
            if (in_alumem_rc = in_idalu_ra and in_alumem_alu_res_equal_rc = '1')
            then
                out_forward_alu_a <= "01";
            elsif ((in_memwb_rc = in_idalu_ra and in_memwb_wr_reg = '1'))
            then
                out_forward_alu_a <= "10";
            else
                out_forward_alu_a <= "00";
            end if;
        
    end process;


    calc_out_forward_alu_b:
    process ( in_alumem_rc, in_idalu_rb, in_idalu_use_imm_ry,
        in_memwb_wr_reg, in_alumem_alu_res_equal_rc, in_memwb_rc)
    begin
        -- 00 select origin A
        -- 01 select alu/memory data
        -- 10 select memory/wb data
        -- 11 select imm
        
            if (in_idalu_use_imm_ry = '1')
            then
                out_forward_alu_b <= "11";
            elsif (in_alumem_rc = in_idalu_rb and in_alumem_alu_res_equal_rc = '1')
            then
                out_forward_alu_b <= "01";
            elsif (in_memwb_rc = in_idalu_rb and in_memwb_wr_reg = '1')
            then
                out_forward_alu_b <= "10";
            else
                out_forward_alu_b <= "00";
            end if;
        
    end process;

    calc_out_forward_alu_d:
    process (in_alumem_rc, in_idalu_rd,
        in_alumem_alu_res_equal_rc, in_memwb_wr_reg, in_memwb_rc)
    begin
        -- 00 select origin A
        -- 01 select alu/memory data
        -- 10 select memory/wb data

        
            if (in_alumem_rc = in_idalu_rd and in_alumem_alu_res_equal_rc = '1')
            then
                out_forward_alu_d <= "01";
            elsif ((in_memwb_rc = in_idalu_rd and in_memwb_wr_reg = '1'))
            then
                out_forward_alu_d <= "10";
            else
                out_forward_alu_d <= "00";
            end if;
        
    end process;

    calc_out_bubble_ifid:
    process (is_alu_lw, in_decode_is_b, is_alumem_lwsw_instruction, in_decode_is_branch_except_b, in_decode_is_jump)
    begin
        
            out_bubble_ifid <= is_alu_lw or ((in_decode_is_b or in_decode_is_branch_except_b or in_decode_is_jump) and is_alumem_lwsw_instruction);
        
    end process;

    calc_out_bubble_idalu:
    process (rst)
    begin
        
            out_bubble_idalu <= '0';
        
    end process;

    calc_out_bubble_alu_mem:
    process (rst)
    begin
        --if (rst = '1')
        --then
        --    out_bubble_alumem <= '0';
        --else
            out_bubble_alumem <= '0';
        --end if;
    end process;

    calc_out_bubble_mem_wb:
    process (rst)
    begin
        --if (rst = '1')
        --then
        --    out_bubble_memwb <= '0';
        --else
            out_bubble_memwb <= '0';
        --end if;
    end process;


    calc_out_rst_ifid:
    process (is_alumem_lwsw_instruction, in_decode_is_b, in_decode_is_branch_except_b, in_decode_is_jump)
    begin
        
            if (in_decode_is_b = '0' and in_decode_is_branch_except_b = '0' and in_decode_is_jump = '0')
            then
                out_rst_ifid <= is_alumem_lwsw_instruction;
            else
                -- in_decode_is_b = '1'
                -- change to bubble
                out_rst_ifid <= '0';
            end if;
        
    end process;

    calc_out_rst_idalu:
    process (predict_error, is_alu_lw, in_decode_is_b, 
        is_alumem_lwsw_instruction, in_decode_is_branch_except_b, in_decode_is_jump)
    begin
        
            out_rst_idalu <= predict_error or is_alu_lw or ((in_decode_is_b or in_decode_is_branch_except_b or in_decode_is_jump) and is_alumem_lwsw_instruction);
        
    end process;

    calc_out_rst_alu_mem:
    process (rst)
    begin
        
            out_rst_alumem <= '0';
        
    end process;

    calc_out_rst_memwb:
    process (rst)
    begin
        
            out_rst_memwb <= '0';
        
    end process;

    calc_out_branch_alu_pc_imm:
    process (in_alu_equal_res)
    begin
        
            out_branch_alu_pc_imm <= in_alu_equal_res(0);
        
    end process;

    process (in_idalu_alu_op)
    begin
        
            case in_idalu_alu_op is
                when ALU_ADD =>
                    out_idalu_alu_res_addr <= "00";
                when ALU_EQUAL_ZERO =>
                    out_idalu_alu_res_addr <= "01";
                when ALU_NOT_EQUAL_ZERO =>
                    out_idalu_alu_res_addr <= "01";
                when others =>
                    out_idalu_alu_res_addr <= "10";  
            end case;
        
    end process;
	 
	 --brk process
	 process(rst,clk, is_doing_brk)
     variable count : INTEGER RANGE 0 TO 127;
	 begin
        if (rst = '1') then
            is_doing_brk <= '0';
        elsif (clk'event and clk = '1')then
            if (count = 0) then
                if (in_brk_come = '1') then
                    count := 127;
                    is_doing_brk <= '1';
                else
                    is_doing_brk <= '0';
                end if;
            else
                count := count - 1;
            end if;
        end if;
	 end process;
     
     --brk_pc_wr 
     --brk_rst
     
     process(rst,clk, is_doing_brk)
	 begin
        if (rst = '1') then
            brk_state <= "000";
            brk_pc_wr <= '1';
            brk_rst <= '0';
            brk_jump <= '0';
        elsif (clk'event and clk = '1')then
            case brk_state is
                when "000" => --init state
                    if (is_doing_brk = '1') then
                        brk_state <= "001";
                        brk_pc_wr <= '0';
                        brk_pc_rst <= '1';
                        if (in_idalu_pc = "0000000000000000") then
                            brk_return_addr <= in_ifid_pc;
                        else
                            brk_return_addr <= in_idalu_pc;
                        end if;
                    end if;
                when "001" => --1 step state
                    brk_state <= "010";
                when "010" => --2 step state   --this time, the step registers are empty
                    brk_state <= "011";
                    brk_pc_wr <= '1';
                    brk_rst <= '0';
                    brk_jump <= '1';
                when "011" => --loop state
                    brk_jump <= '0';
                    if (is_doing_brk = '0') then
                        brk_state <= "000";
                    end if;
                when others =>
                    brk_state <= "000";
            end case;
        end if;
	 end process;

end Behavioral;
