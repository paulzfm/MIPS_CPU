--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:00:44 11/19/2015
-- Design Name:   
-- Module Name:   Y:/Documents/code/arch/finalproject/cpu/test/test_alu.vhd
-- Project Name:  finalproject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_alu IS
END test_alu;
 
ARCHITECTURE behavior OF test_alu IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         in_data_a : IN  std_logic_vector(15 downto 0);
         in_data_b : IN  std_logic_vector(15 downto 0);
         in_op : IN  std_logic_vector(3 downto 0);
         out_alu_res : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal in_data_a : std_logic_vector(15 downto 0) := (others => '0');
   signal in_data_b : std_logic_vector(15 downto 0) := (others => '0');
   signal in_op : std_logic_vector(3 downto 0) := (others => '0');
   signal clock : std_logic;
 	--Outputs
   signal out_alu_res : std_logic_vector(15 downto 0);
	signal debug : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          in_data_a => in_data_a,
          in_data_b => in_data_b,
          in_op => in_op,
          out_alu_res => out_alu_res

        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clock_period*10;

      -- insert stimulus here 
      -- add
      in_data_a <= "0000111100001111";
      in_data_b <= "1111000011110001";
      in_op <= "0000";
      wait for 20 ns;
      in_data_a <= "0000111100001111";
      in_data_b <= "1111000011110000";
      in_op <= "0000";
      wait for 20 ns;
      -- sub
      in_data_a <= "0000111100001111";
      in_data_b <= "1111000011110001";
      in_op <= "0001";
      wait for 20 ns;
      in_data_b <= "0000111100001111";
      in_data_b <= "1111000011110000";
      in_op <= "0001";
      -- <<
      wait for 20 ns;
      in_data_a <= "0000111100001111";
      in_data_b <= "0000000000000010";
      in_op <= "0010";
      wait for 20 ns;
      in_data_a <= "0000111100001111";
      in_data_b <= "0000000000000000";
      in_op <= "0010";
      -- >>
      wait for 20 ns;
      in_data_a <= "0000111100001111";
      in_data_b <= "0000000000000010";
      in_op <= "0011";
      wait for 20 ns;
      in_data_a <= "0000111100001111";
      in_data_b <= "0000000000000000";
      in_op <= "0011";
      -- xor
      wait for 20 ns;
      in_data_a <= "0000111100001111";
      in_data_b <= "0000000000000010";
      in_op <= "0100";
      wait for 20 ns;

      -- alu cmp
      in_data_a <= "0000111100001111";
      in_data_b <= "0000000000000000";
      in_op <= "0101";
      wait for 20 ns;
      in_data_a <= "0000000000000010";
      in_data_b <= "0000000000000010";
      in_op <= "0101";
      wait for 20 ns;
      
      -- alu signed cmp
      in_data_a <= "0000111100001111";
      in_data_b <= "1110000000000000";
      in_op <= "0110";
      wait for 20 ns;
      in_data_a <= "0000000000000010";
      in_data_b <= "0000000000000011";
      in_op <= "0110";
      wait for 20 ns;
      in_data_a <= "0000000000000011";
      in_data_b <= "0000000000000010";
      in_op <= "0110";
      wait for 20 ns;
      in_data_a <= "1000000000000010";
      in_data_b <= "1000000000000011";
      in_op <= "0110";
      wait for 20 ns;
      in_data_a <= "1000000000000011";
      in_data_b <= "1000000000000010";
      in_op <= "0110";
      wait for 20 ns;
      in_data_a <= "1000000000000011";
      in_data_b <= "1000000000000011";
      in_op <= "0110";
      wait for 20 ns;

      -- alu unsigned cmp
      in_data_a <= "0000111100001111";
      in_data_b <= "1110000000000000";
      in_op <= "0111";
      wait for 20 ns;
      in_data_a <= "1000000000000010";
      in_data_b <= "1000000000000011";
      in_op <= "0111";
      wait for 20 ns;
      in_data_a <= "1000010000000011";
      in_data_b <= "1000000000000010";
      in_op <= "0111";
      wait for 20 ns;
      in_data_a <= "1000000000000011";
      in_data_b <= "1000000000000011";
      in_op <= "0110";
      wait for 20 ns;
      -- output a
      in_data_a <= "1000010000000011";
      in_data_b <= "1000000000000010";
      in_op <= "1000";
      wait for 20 ns;
      -- output b
      in_data_a <= "1000010000000011";
      in_data_b <= "1000000000000010";
      in_op <= "1001";
      wait for 20 ns;
      wait;
   end process;

END;
