----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:36:03 10/15/2015 
-- Design Name: 
-- Module Name:    ALU_UNIT - Behavioral 
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

entity ALU_UNIT is
    Port ( CLK : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           SW : in  STD_LOGIC_VECTOR (15 downto 0);
           Fout : in  STD_LOGIC_VECTOR (15 downto 0);
           flag : in  STD_LOGIC);
end ALU_UNIT;

architecture Behavioral of ALU_UNIT is
--SIGNAL FOR PROCESS
SIGNAL state £ºSTD_LOGIC_VECTOR (1 downto 0)£»
--SIGNAL FOR PROCESS

--SIGNAL FOR ALU U0
SIGNAL a £ºSTD_LOGIC_VECTOR (15 downto 0)£»
SIGNAL b £ºSTD_LOGIC_VECTOR (15 downto 0)£»
SIGNAL y £ºSTD_LOGIC_VECTOR (15 downto 0)£»
SIGNAL op £ºSTD_LOGIC_VECTOR (3 downto 0)£»
SIGNAL flag_temp £ºSTD_LOGIC £»
--SIGNAL FOR ALU U0
COMPONENT ALU
    port (
        a, b: in std_logic_vector(15 downto 0);
        op: in std_logic_vector(3 downto 0);
        y: out std_logic_vector(15 downto 0);
		  flag: out std_logic
    );
end COMPONENT;
begin
U0: ALU PORT MAP(a=>a,b=>b,y=>y,op=>op,flag=>flag_temp);
process(CLK,RST)
if(RST = '0') then
	state<="00";
	flag<='0';
else
	if(CLK'evnet and CLK='1') then
		if(state = "00") then
			a <= SW;
			state <= state +"01";
		else if(state = "01") then
			b <= SW;
			state <= state +"01";
		else if(state = "10") then
			op <= SW;
			Fout <= y;
			state <= state +"01";
		else if(state = "11") then
			flag <= flag_temp;
			state <= state +"01";
		end if;
	end if;
end if;
end process;

end Behavioral;

