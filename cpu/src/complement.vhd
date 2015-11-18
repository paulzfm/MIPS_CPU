----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:17:55 11/17/2015 
-- Design Name: 
-- Module Name:    alu - Behavioral 
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

entity complement is
    Port ( in_data : in  STD_LOGIC_VECTOR (15 downto 0);
           out_data : out  STD_LOGIC_VECTOR (15 downto 0);
           );
end complement;

architecture Behavioral of complement is

component add16_component is
    Port ( in_data_a : in  STD_LOGIC_VECTOR (15 downto 0);
           in_data_b : in  STD_LOGIC_VECTOR (15 downto 0);
           out_output : out  STD_LOGIC_VECTOR (15 downto 0);
           out_t : out STD_LOGIC);
end component;

signal add16_res, sub16_res : STD_LOGIC_VECTOR(15 downto 0);
signal add16_t, sub16_t : STD_LOGIC;

begin
    

end Behavioral;

