--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:01:37 11/25/2015
-- Design Name:   
-- Module Name:   D:/CPU/top/testifid.vhd
-- Project Name:  top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: states_ifid
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
 
ENTITY testifid IS
END testifid;
 
ARCHITECTURE behavior OF testifid IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT states_ifid
    PORT(
         in_pc : IN  std_logic_vector(15 downto 0);
         in_pc_inc : IN  std_logic_vector(15 downto 0);
         in_instruction : IN  std_logic_vector(15 downto 0);
         out_pc : OUT  std_logic_vector(15 downto 0);
         out_pc_inc : OUT  std_logic_vector(15 downto 0);
         out_instruction : OUT  std_logic_vector(15 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         ctl_bubble : IN  std_logic;
         ctl_copy : IN  std_logic;
         ctl_rst : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal in_pc : std_logic_vector(15 downto 0) := (others => '0');
   signal in_pc_inc : std_logic_vector(15 downto 0) := (others => '0');
   signal in_instruction : std_logic_vector(15 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ctl_bubble : std_logic := '0';
   signal ctl_copy : std_logic := '0';
   signal ctl_rst : std_logic := '0';

 	--Outputs
   signal out_pc : std_logic_vector(15 downto 0);
   signal out_pc_inc : std_logic_vector(15 downto 0);
   signal out_instruction : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: states_ifid PORT MAP (
          in_pc => in_pc,
          in_pc_inc => in_pc_inc,
          in_instruction => in_instruction,
          out_pc => out_pc,
          out_pc_inc => out_pc_inc,
          out_instruction => out_instruction,
          clk => clk,
          rst => rst,
          ctl_bubble => ctl_bubble,
          ctl_copy => ctl_copy,
          ctl_rst => ctl_rst
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;
		ctl_bubble <= '0';
      ctl_copy <= '0';
      ctl_rst <= '0';
      in_instruction <= "1111010110101010";
		
		-- insert stimulus here 

      wait;
   end process;

END;
