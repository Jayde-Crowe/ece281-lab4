----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2024 02:04:01 PM
-- Design Name: 
-- Module Name: sevenSegDecoder_tb - Behavioral
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

entity sevenSegDecoder_tb is
end sevenSegDecoder_tb;

architecture Behavioral of sevenSegDecoder_tb is

component sevenSegDecoder is
port(
    i_D : in std_logic_vector (3 downto 0);
    o_S: out std_logic_vector (6 downto 0)
);
end component sevenSegDecoder;

signal w_sw : std_logic_vector (3 downto 0);
signal w_seg : std_logic_vector (6 downto 0); 
begin

sevenSegDecoder_inst : sevenSegDecoder
port map
(
    i_D => w_sw,
    o_S => w_seg
);

test_process : process
begin
 w_sw <= x"0"; wait for 10 ns;
    assert w_seg = "1000000" report "error on x0" severity failure;
w_sw <= x"1"; wait for 10 ns;
    assert w_seg = "1111001" report "error on x1" severity failure;
w_sw <= x"2"; wait for 10 ns;
    assert w_seg = "0100100" report "error on x2" severity failure;
w_sw <= x"3"; wait for 10 ns;
    assert w_seg = "0110000" report "error on x3" severity failure;
w_sw <= x"4"; wait for 10 ns; 
    assert w_seg = "0011001" report "error on x4" severity failure;
w_sw <= x"5"; wait for 10 ns;
    assert w_seg = "0010010" report "error on x5" severity failure;
w_sw <= x"6"; wait for 10 ns;
    assert w_seg = "0000010" report "error on x6" severity failure;
w_sw <= x"7"; wait for 10 ns;
    assert w_seg = "1111000" report "error on x7" severity failure;
w_sw <= x"8"; wait for 10 ns;
    assert w_seg = "0000000" report "error on x8" severity failure;
w_sw <= x"9"; wait for 10 ns;
    assert w_seg = "0011000" report "error on x9" severity failure;
w_sw <= x"A"; wait for 10 ns;
    assert w_seg = "0001000" report "error on xA" severity failure;
w_sw <= x"B"; wait for 10 ns;
    assert w_seg = "0000011" report "error on xB" severity failure;
w_sw <= x"C"; wait for 10 ns;
    assert w_seg = "0100111" report "error on xC" severity failure;
w_sw <= x"D"; wait for 10 ns;
    assert w_seg = "0100001" report "error on xD" severity failure;
w_sw <= x"E"; wait for 10 ns;
    assert w_seg = "0000110" report "error on xE" severity failure;
w_sw <= x"F"; wait for 10 ns;
    assert w_seg = "0001110" report "error on xF" severity failure;
    
    wait;
    end process;
    



end Behavioral;
