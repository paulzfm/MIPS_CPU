--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:01:59 11/19/2015
-- Design Name:   
-- Module Name:   Y:/Documents/code/arch/finalproject/cpu/test/test_add16.vhd
-- Project Name:  finalproject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: add16
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
 
ENTITY test_add16 IS
END test_add16;
 
ARCHITECTURE behavior OF test_add16 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT add16
    PORT(
         in_data_a : IN  std_logic_vector(15 downto 0);
         in_data_b : IN  std_logic_vector(15 downto 0);
         out_output : OUT  std_logic_vector(15 downto 0);
         out_t : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal in_data_a : std_logic_vector(15 downto 0) := (others => '0');
   signal in_data_b : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal out_output : std_logic_vector(15 downto 0);
   signal out_t, clock : std_logic;
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: add16 PORT MAP (
          in_data_a => in_data_a,
          in_data_b => in_data_b,
          out_output => out_output,
          out_t => out_t
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
      in_data_a <= "1010000000000000";
      in_data_b <= "0000111111111111";
      wait for 5 ns;
      in_data_a <= "1010000000000000";
      in_data_b <= "1000111111111111";
      wait;
   end process;

END;
