----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2024 10:15:53 AM
-- Design Name: 
-- Module Name: myBinary - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity myBinary is 
    Port( i_data : in std_logic_vector (3 downto 0);
      o_tens        : out STD_LOGIC_vector (3 downto 0);
      o_ones        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
      );  
end myBinary;

architecture Behavioral of myBinary is

begin

		
        o_tens <= "0001" when i_data = "0000" or -- floor 16
               i_data = "1010" or -- floor 10
               i_data = "1011" or -- floor 11
               i_data = "1100" or -- floor 12
               i_data = "1101" or -- floor 13
               i_data = "1110" or -- floor 14
               i_data = "1111" else "0000" ; -- floor 15
               
     o_ones <= "0001" when i_data = "0001" or i_data = "1011" else
               "0010" when i_data = "0010" or i_data = "1100" else
               "0011" when i_data = "0011" or i_data = "1101" else
               "0100" when i_data = "0100" or i_data = "1110" else
               "0101" when i_data = "0101" or i_data = "1111" else
               "0110" when i_data = "0110" or i_data = "0000" else
               "0111" when i_data = "0111" else
               "1000" when i_data = "1000" else
               "1001" when i_data = "1001" else "0000";
               


end Behavioral;

