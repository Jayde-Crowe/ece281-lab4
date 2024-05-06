----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/02/2024 09:45:37 PM
-- Design Name: 
-- Module Name: myBinary_tb - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity myBinary_tb is
--  Port ( );
end myBinary_tb;

architecture Behavioral of myBinary_tb is

component myBinary is 
port( i_data : in std_logic_vector (3 downto 0);
      o_tens        : out STD_LOGIC_vector (3 downto 0);
      o_ones        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
);  
end component myBinary;

signal w_floor : std_logic_vector (3 downto 0);
signal w_tens : std_logic_vector (3 downto 0);
signal w_ones : std_logic_vector (3 downto 0);
begin

myBinary_inst : myBinary
port map(
         i_data => w_floor,
         o_tens => w_tens,
         o_ones => w_ones
);

test_process : process

begin 

    w_floor <= "0001"; wait for 10 ns;
        assert w_ones = w_floor report "error on 0001 with ones" severity failure;
        assert w_tens = "0000" report "error on 0001 with tens" severity failure;
    w_floor <= "0010"; wait for 10 ns;
        assert w_ones = w_floor report "error on 0010 with ones" severity failure;
        assert w_tens = "0000" report "error on 0010 with tens" severity failure;
    w_floor <= "0011"; wait for 10 ns;
        assert w_ones = w_floor report "error on 0011 with ones" severity failure;
        assert w_tens = "0000" report "error on 0011 with tens" severity failure;
    w_floor <= "0100"; wait for 10 ns;
        assert w_ones = w_floor report "error on 0100 with ones" severity failure;
        assert w_tens = "0000" report "error on 0100 with tens" severity failure;
    w_floor <= "0101"; wait for 10 ns;
        assert w_ones = w_floor report "error on 0101 with ones" severity failure;
        assert w_tens = "0000" report "error on 0101 with tens" severity failure;
    w_floor <= "0110"; wait for 10 ns;
        assert w_ones = w_floor report "error on 0110 with ones" severity failure;
        assert w_tens = "0000" report "error on 0110 with tens" severity failure;
    w_floor <= "0111"; wait for 10 ns;
        assert w_ones = w_floor report "error on 0111 with ones" severity failure;
        assert w_tens = "0000" report "error on 0111 with tens" severity failure;
    w_floor <= "1000"; wait for 10 ns;
        assert w_ones = w_floor report "error on 1000 with ones" severity failure;
        assert w_tens = "0000" report "error on 1000 with tens" severity failure;
    w_floor <= "1001"; wait for 10 ns;
        assert w_ones = w_floor report "error on 1001 with ones" severity failure;
        assert w_tens = "0000" report "error on 1001 with tens" severity failure;
    w_floor <= "1010"; wait for 10 ns;
        assert w_ones = "0000" report "error on 1010 with ones" severity failure;
        assert w_tens = "0001" report "error on 1010 with tens" severity failure;
    w_floor <= "1011"; wait for 10 ns;
        assert w_ones = "0001" report "error on 1011 with ones" severity failure; 
        assert w_tens = "0001" report "error on 1011 with tens" severity failure;
    w_floor <= "1100"; wait for 10 ns;
        assert w_ones = "0010" report "error on 1100 with ones" severity failure;
        assert w_tens = "0001" report "error on 1100 with tens" severity failure;
    w_floor <= "1101"; wait for 10 ns;
        assert w_ones = "0011" report "error on 1101 with ones" severity failure;
        assert w_tens = "0001" report "error on 1101 with tens" severity failure;
    w_floor <= "1110"; wait for 10 ns;
        assert w_ones = "0100" report "error on 1110 with ones" severity failure;
        assert w_tens = "0001" report "error on 1110 with tens" severity failure;
    w_floor <= "1111"; wait for 10 ns;
        assert w_ones = "0101" report "error on 1111 with ones" severity failure;
        assert w_tens = "0001" report "error on 1111 with tens" severity failure;
    w_floor <= "0000"; wait for 10 ns;
        assert w_ones = "0110" report "error on 0000 with ones" severity failure;
        assert w_tens = "0001" report "error on 0000 with tens" severity failure;
        
        
        wait;
        end process;

end Behavioral;
