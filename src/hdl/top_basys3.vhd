--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2018 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : top_basys3.vhd
--| AUTHOR(S)     : Capt Phillip Warner
--| CREATED       : 3/9/2018  MOdified by Capt Dan Johnson (3/30/2020)
--| DESCRIPTION   : This file implements the top level module for a BASYS 3 to 
--|					drive the Lab 4 Design Project (Advanced Elevator Controller).
--|
--|					Inputs: clk       --> 100 MHz clock from FPGA
--|							btnL      --> Rst Clk
--|							btnR      --> Rst FSM
--|							btnU      --> Rst Master
--|							btnC      --> GO (request floor)
--|							sw(15:12) --> Passenger location (floor select bits)
--| 						sw(3:0)   --> Desired location (floor select bits)
--| 						 - Minumum FUNCTIONALITY ONLY: sw(1) --> up_down, sw(0) --> stop
--|							 
--|					Outputs: led --> indicates elevator movement with sweeping pattern (additional functionality)
--|							   - led(10) --> led(15) = MOVING UP
--|							   - led(5)  --> led(0)  = MOVING DOWN
--|							   - ALL OFF		     = NOT MOVING
--|							 an(3:0)    --> seven-segment display anode active-low enable (AN3 ... AN0)
--|							 seg(6:0)	--> seven-segment display cathodes (CG ... CA.  DP unused)
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std
--|    Files     : MooreElevatorController.vhd, clock_divider.vhd, sevenSegDecoder.vhd
--|				   thunderbird_fsm.vhd, sevenSegDecoder, TDM4.vhd, OTHERS???
--|
--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


-- Lab 4
entity top_basys3 is
    port(
        -- inputs
        clk     :   in std_logic; -- native 100MHz FPGA clock
        sw      :   in std_logic_vector(15 downto 0);
        btnU    :   in std_logic; -- master_reset
        btnL    :   in std_logic; -- clk_reset
        btnR    :   in std_logic; -- fsm_reset
        
        -- outputs
        led :   out std_logic_vector(15 downto 0);
        -- 7-segment display segments (active-low cathodes)
        seg :   out std_logic_vector(6 downto 0);
        -- 7-segment display active-low enables (anodes)
        an  :   out std_logic_vector(3 downto 0)
    );
end top_basys3;

architecture top_basys3_arch of top_basys3 is 
  
component sevenSegDecoder is
port(
	  i_D : in std_logic_vector (3 downto 0);
	  o_S : out std_logic_vector (6 downto 0)
);
end component sevenSegDecoder;

component clock_divider is 
    generic ( constant k_DIV : natural := 2);
    port( i_clk : in std_logic;
        i_reset : in std_logic;
        o_clk : out std_logic
      );
end component clock_divider;

component elevator_controller_fsm is
    port(i_clk : in std_logic;
        i_reset : in std_logic;
        i_stop : in std_logic;
        i_up_down : in std_logic;
        o_floor : out std_logic_vector (3 downto 0)
       );
end component elevator_controller_fsm;

component TDM4 is
    generic ( constant k_WIDTH : natural  := 4);
    Port( i_clk		: in  STD_LOGIC;
          i_reset        : in  STD_LOGIC; -- asynchronous
          i_D3         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
          i_D2         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
          i_D1         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
          i_D0         : in  STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
          o_data        : out STD_LOGIC_VECTOR (k_WIDTH - 1 downto 0);
          o_sel        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
   );
end component TDM4;

component myBinary is 
port( i_data : in std_logic_vector (3 downto 0);
      o_tens        : out STD_LOGIC_vector (3 downto 0);
      o_ones        : out STD_LOGIC_VECTOR (3 downto 0)    -- selected data line (one-cold)
      );  
end component myBinary;
    


signal w_clk : std_logic;
signal w_r_clk : std_logic;
signal w_r_fsm: std_logic;
signal w_floor: std_logic_vector (3 downto 0);
signal w_tens: std_logic_vector (3 downto 0);
signal w_ones: std_logic_vector (3 downto 0);
signal w_data: std_logic_vector (3 downto 0);


	   

  
begin
	-- PORT MAPS ----------------------------------------

    sevenSegDecoder_inst : sevenSegDecoder
    port map (
    i_D => w_floor,
    o_S => seg
);

    clkdiv_inst : clock_divider
    generic map (k_DIV => 25000000)
    port map( i_clk => clk,
    i_reset => w_r_clk,
    o_clk => w_clk
);

    elevator_controller_isnt : elevator_controller_fsm
    port map( i_clk => w_clk,
    i_reset => w_r_fsm,
    i_stop => sw(1),
    i_up_down => sw(0),
    o_floor => w_floor
);
 
    TDM4_inst : TDM4
      generic map(K_WIDTH => 4)
      port map( i_clk => clk,
      i_reset => w_r_clk,
      i_D3 => w_tens,
      i_D2 => w_ones,
      i_D1 => "0000",
      i_D0 => "0000",
      o_data => w_data,
      o_sel => an
 );
 
 
    myBinary_inst : myBinary
    port map(
            i_data => w_floor,
            o_tens => w_ones,
            o_ones => w_tens
);
 	
	
	-- CONCURRENT STATEMENTS ----------------------------
	
		
        w_tens <= "0001" when w_floor = "0000" or -- floor 16
               w_floor = "1010" or -- floor 10
               w_floor = "1011" or -- floor 11
               w_floor = "1100" or -- floor 12
               w_floor = "1101" or -- floor 13
               w_floor = "1110" or -- floor 14
               w_floor = "1111" else "1111" ; -- floor 15
               
     w_ones <= "0001" when w_floor = "0001" or w_floor = "1011" else
               "0010" when w_floor = "0010" or w_floor = "1100" else
               "0011" when w_floor = "0011" or w_floor = "1101" else
               "0100" when w_floor = "0100" or w_floor = "1110" else
               "0101" when w_floor = "0101" or w_floor = "1111" else
               "0110" when w_floor = "0110" or w_floor = "0000" else
               "0111" when w_floor = "0111" else
               "1000" when w_floor = "1000" else
               "1001" when w_floor = "1001" else "0000";
               
	w_r_clk <= btnL or btnU;
	w_r_fsm <= btnR or btnU;
	
	
	-- LED 15 gets the FSM slow clock signal. The rest are grounded.
	led(15) <= w_clk;
	led(14) <= '0';
	led(13) <= '0';
	led(12) <= '0';
	led(11) <= '0';
	led(10) <= '0';
	led(9) <= '0';
	led(8) <= '0';
	led(7) <= '0';
	led(6) <= '0';
	led(5) <= '0';
	led(4) <= '0';
	led(3) <= '0';
	led(2) <= '0';
	led(1) <= '0';
	led(0) <= '0';
	

	-- leave unused switches UNCONNECTED. Ignore any warnings this causes.
	
	-- wire up active-low 7SD anodes (an) as required
	-- Tie any unused anodes to power ('1') to keep them off

	

	an(2) <= '1';
	an(3) <= '1';


	

	
end top_basys3_arch;
