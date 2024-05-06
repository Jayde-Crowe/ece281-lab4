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

    process(i_data)
    
    begin
        case i_data is
            when "0001" | "0010" | "0100" | "0101" |"0110" | "0111" | "1000" | "1001" | "0011" => 
                o_tens <= "0000";       
            when "1010" | "1011" | "1100" | "1101" | "1110" | "1111" | "0000" =>
                o_tens <= "0001";     
            when others =>
                o_tens <= "0000";
            end case;
            
         case i_data is
            when "0001" | "0010" | "0100" | "0101" |"0110" | "0111" | "1000" | "1001" | "0011" => 
                o_ones <= i_data;
             when "1010" =>
                o_ones <= "0000";
            when "1011" =>
                o_ones <= "0001";
             when "1100" =>
                 o_ones <= "0010";
             when "1101" =>
                 o_ones <= "0011";
             when "1110" =>
                 o_ones <= "0100";
             when "1111" =>
                 o_ones <= "0101";
             when "0000" =>
                 o_ones <= "0110"; 
             when others => 
                o_ones <= "0000";
          end case; 
            
          
          
          
    
            
     end process;
             




end Behavioral;

