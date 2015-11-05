----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:09:20 11/05/2015 
-- Design Name: 
-- Module Name:    receiver - Behavioral 
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

entity receiver2 is
    Port ( clk : in STD_LOGIC;
		     rst :¡¡in STD_LOGIC;
			  rdn : out  STD_LOGIC;
           data_ready : in  STD_LOGIC;
           data : inout  STD_LOGIC_VECTOR (7 downto 0)
			  rev_data_ready : out STD_LOGIC, 
			  rev_next_epoch : in STD_LOGIC);
end receiver;

architecture Behavioral of receiver2 is
signal status : integer(0 to 10);

begin

	process(clk, rst)
	begin
		if (rst = '0')
		then
			status = 0;
		else
			if (clk`event and clk = 1)
			then
				if (rev_next_epoch = '1')
				then
					status = 0;
				end if;
				
				case status is
					when 0 => -- init status
						data_read <= '0';
						status <= '1';
					when 1 => -- start read
						rdn <= '1';
						data_read <= '0';
						status <= status + 1;
						data <= (others => 'Z');
					when 2 => -- check data_ready
						if (data_ready = '1')
						then
							status <= status + 1;
							rdn <= '0';
						else
							
						end if;
					when 3 => -- read successful
						status <= status + 1;
						data_read <= '1';
					when 4 =>
						status <= 4;
					when others =>
						status <= 0;
				end case;
			end if;
		end if;
	end process;
	
	
	
end Behavioral;

