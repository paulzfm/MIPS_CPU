--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:35:58 11/18/2015
-- Design Name:   
-- Module Name:   Y:/Documents/code/arch/finalproject/cpu/test/test_mux4.vhd
-- Project Name:  finalproject
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux4
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
 
ENTITY test_mux4 IS
END test_mux4;
 
ARCHITECTURE behavior OF test_mux4 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux4
    PORT(
         input0 : IN  std_logic_vector(15 downto 0);
         input1 : IN  std_logic_vector(15 downto 0);
         input2 : IN  std_logic_vector(15 downto 0);
         input3 : IN  std_logic_vector(15 downto 0);
         addr : IN  std_logic_vector(1 downto 0);
         output : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal input0 : std_logic_vector(15 downto 0) := (others => '0');
   signal input1 : std_logic_vector(15 downto 0) := (others => '0');
   signal input2 : std_logic_vector(15 downto 0) := (others => '0');
   signal input3 : std_logic_vector(15 downto 0) := (others => '0');
   signal addr : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(15 downto 0);
   -- No clocks detected in port list. Replace clock below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
	signal clock : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux4 PORT MAP (
          input0 => input0,
          input1 => input1,
          input2 => input2,
          input3 => input3,
          addr => addr,
          output => output
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
		input0 <= "0000000011111111";
      input1 <= "0001100011111111";
      input2 <= "1111111111111111";
      input3 <= "0101010101010101";
      addr <= "11";
      wait for 5 ns;
      addr <= "10";
      wait for 5 ns;
      addr <= "01";
      wait for 5 ns;
      addr <= "00";
      wait for 5 ns;

      wait;
      
   end process;

END;
