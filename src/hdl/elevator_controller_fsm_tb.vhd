--+----------------------------------------------------------------------------
--| 
--| COPYRIGHT 2017 United States Air Force Academy All rights reserved.
--| 
--| United States Air Force Academy     __  _______ ___    _________ 
--| Dept of Electrical &               / / / / ___//   |  / ____/   |
--| Computer Engineering              / / / /\__ \/ /| | / /_  / /| |
--| 2354 Fairchild Drive Ste 2F6     / /_/ /___/ / ___ |/ __/ / ___ |
--| USAF Academy, CO 80840           \____//____/_/  |_/_/   /_/  |_|
--| 
--| ---------------------------------------------------------------------------
--|
--| FILENAME      : MooreElevatorController_tb.vhd (TEST BENCH)
--| AUTHOR(S)     : Capt Phillip Warner, Capt Dan Johnson, **Your Name Here**
--| CREATED       : 03/2017 Last modified on 06/24/2020
--| DESCRIPTION   : This file tests the Moore elevator controller module
--|
--| DOCUMENTATION : None
--|
--+----------------------------------------------------------------------------
--|
--| REQUIRED FILES :
--|
--|    Libraries : ieee
--|    Packages  : std_logic_1164, numeric_std, unisim
--|    Files     : MooreElevatorController.vhd
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
 
entity elevator_controller_fsm_tb is
end elevator_controller_fsm_tb;

architecture test_bench of elevator_controller_fsm_tb is 
	
	component elevator_controller_fsm is
		Port ( i_clk 	 : in  STD_LOGIC;
			   i_reset 	 : in  STD_LOGIC; -- synchronous
			   i_stop 	 : in  STD_LOGIC;
			   i_up_down : in  STD_LOGIC;
			   o_floor 	 : out STD_LOGIC_VECTOR (3 downto 0));
	end component elevator_controller_fsm;
	
	-- test signals
	signal w_clk, w_reset, w_stop, w_up_down : std_logic := '0';
	signal w_floor : std_logic_vector(3 downto 0) := (others => '0');
  
	-- 50 MHz clock
	constant k_clk_period : time := 20 ns;
	
begin
	-- PORT MAPS ----------------------------------------

	uut_inst : elevator_controller_fsm port map (
		i_clk     => w_clk,
		i_reset   => w_reset,
		i_stop    => w_stop,
		i_up_down => w_up_down,
		o_floor   => w_floor
	);
	-----------------------------------------------------
	
	-- PROCESSES ----------------------------------------
	
	-- Clock Process ------------------------------------
	clk_process : process
	begin
		w_clk <= '0';
		wait for k_clk_period/2;
		
		w_clk <= '1';
		wait for k_clk_period/2;
	end process clk_process;
	
	
	-- Test Plan Process --------------------------------
	test_process : process 
	begin
        -- i_reset into initial state (o_floor 2)
        w_reset <= '1';  wait for k_clk_period;
            assert w_floor = "0010" report "bad reset" severity failure; 
        -- clear reset
        w_reset <= '0';
		
		-- active UP signal
		w_up_down <= '1'; 
		
		-- stay on each o_floor for 2 cycles and then move up to the next o_floor
        w_stop <= '1';  wait for k_clk_period * 2;
            assert w_floor = "0010" report "bad wait on floor2" severity failure;
        w_stop <= '0';  wait for k_clk_period;
            assert w_floor = "0011" report "bad up from floor2" severity failure;
		-- rest of cases
		w_stop <= '1';  wait for k_clk_period * 2;
		    assert w_floor = "0011" report "bad wait on floor3" severity failure;
		w_stop <= '0'; wait for k_clk_period;
		    assert w_floor = "0100" report "bad up from floor3" severity failure;
		w_stop <= '1'; wait for k_clk_period * 2;
		    assert w_floor = "0100" report "bad wait on floor4" severity failure;
		w_stop <= '0'; wait for k_clk_period;
		    assert w_floor = "0101" report "bad up on floor4" severity failure;
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "0101" report "bad wait on floor5" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "0110" report "bad up on floor5" severity failure;
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "0110" report "bad wait on floor6" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "0111" report "bad up on floor6" severity failure;
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "0111" report "bad wait on floor7" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "1000" report "bad up on floor7" severity failure;	 
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "1000" report "bad wait on floor8" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "1001" report "bad up on floor8" severity failure;   
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "1001" report "bad wait on floor9" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "1010" report "bad up on floor9" severity failure;            
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "1010" report "bad wait on floor10" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "1011" report "bad up on floor10" severity failure;            
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "1011" report "bad wait on floor11" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "1100" report "bad up on floor11" severity failure;
		w_stop <= '1'; wait for k_clk_period * 2;
            assert w_floor = "1100" report "bad wait on floor12" severity failure;
        w_stop <= '0'; wait for k_clk_period;
            assert w_floor = "1101" report "bad up on floor12" severity failure;            
		w_stop <= '1'; wait for k_clk_period * 2;
             assert w_floor = "1101" report "bad wait on floor13" severity failure;
        w_stop <= '0'; wait for k_clk_period;
             assert w_floor = "1110" report "bad up on floor13" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
             assert w_floor = "1110" report "bad wait on floor14" severity failure;
         w_stop <= '0'; wait for k_clk_period;
             assert w_floor = "1111" report "bad up on floor14" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
              assert w_floor = "1111" report "bad wait on floor15" severity failure;
         w_stop <= '0'; wait for k_clk_period;
              assert w_floor = "0000" report "bad up on floor15" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
              assert w_floor = "0000" report "bad wait on floor16" severity failure;
        w_stop <= '0'; wait for k_clk_period;
              assert w_floor = "0000" report "Top floor... can't go any higher" severity failure;                   
                 
        -- go back DOWN
        w_up_down <= '0';
        
        w_stop <= '1'; wait for k_clk_period * 2;
              assert w_floor = "0000" report "bad wait on floor16" severity failure;
         w_stop <= '0'; wait for k_clk_period;
              assert w_floor = "1111" report "bad down on floor16" severity failure;       
        w_stop <= '1'; wait for k_clk_period * 2;
              assert w_floor = "1111" report "bad wait on floor15" severity failure;
        w_stop <= '0'; wait for k_clk_period;
              assert w_floor = "1110" report "bad down from floor15" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
              assert w_floor = "1110" report "bad wait on floor14" severity failure;
         w_stop <= '0'; wait for k_clk_period;
               assert w_floor = "1101" report "bad down from floor14" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
               assert w_floor = "1101" report "bad wait on floor13" severity failure;
         w_stop <= '0'; wait for k_clk_period;
               assert w_floor = "1100" report "bad down from floor13" severity failure;                   
        w_stop <= '1'; wait for k_clk_period * 2;
               assert w_floor = "1110" report "bad wait on floor12" severity failure;
         w_stop <= '0'; wait for k_clk_period;
               assert w_floor = "1101" report "bad down from floor12" severity failure;                    
        w_stop <= '1'; wait for k_clk_period * 2;
                assert w_floor = "1101" report "bad wait on floor11" severity failure;
         w_stop <= '0'; wait for k_clk_period;
                assert w_floor = "1010" report "bad down from floor11" severity failure;                    
        w_stop <= '1'; wait for k_clk_period * 2;
                assert w_floor = "1010" report "bad wait on floor10" severity failure;
        w_stop <= '0'; wait for k_clk_period;
                assert w_floor = "1001" report "bad down from floor10" severity failure;                           
        w_stop <= '1'; wait for k_clk_period * 2;
                assert w_floor = "1001" report "bad wait on floor9" severity failure;
        w_stop <= '0'; wait for k_clk_period;
                assert w_floor = "1000" report "bad down from floor9" severity failure;                          
        w_stop <= '1'; wait for k_clk_period * 2;
                assert w_floor = "1000" report "bad wait on floor8" severity failure;
        w_stop <= '0'; wait for k_clk_period;
                assert w_floor = "0111" report "bad down from floor8" severity failure;                          
        w_stop <= '1'; wait for k_clk_period * 2;
                assert w_floor = "1000" report "bad wait on floor7" severity failure;
        w_stop <= '0'; wait for k_clk_period;
                assert w_floor = "0111" report "bad down from floor7" severity failure;                          
        w_stop <= '1'; wait for k_clk_period * 2;
                assert w_floor = "0110" report "bad wait on floor6" severity failure;
        w_stop <= '0'; wait for k_clk_period;
                assert w_floor = "0101" report "bad down from floor6" severity failure;                         
        w_stop <= '1'; wait for k_clk_period * 2;
                assert w_floor = "0101" report "bad wait on floor5" severity failure;
        w_stop <= '0'; wait for k_clk_period;
                assert w_floor = "0100" report "bad down from floor5" severity failure;                                                                              
        w_stop <= '1'; wait for k_clk_period * 2;
               assert w_floor = "0100" report "bad wait on floor4" severity failure;
        w_stop <= '0'; wait for k_clk_period;
              assert w_floor = "0011" report "bad down from floor4" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
              assert w_floor = "0011" report "bad wait on floor3" severity failure;
        w_stop <= '0'; wait for k_clk_period;
              assert w_floor = "0010" report "bad down from floor3" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
              assert w_floor = "0010" report "bad wait on floor2" severity failure;
        w_stop <= '0'; wait for k_clk_period;
              assert w_floor = "0001" report "bad down from floor2" severity failure;
        w_stop <= '1'; wait for k_clk_period * 2;
             assert w_floor = "0001" report "bad wait on floor1" severity failure;
        w_stop <= '0'; wait for k_clk_period;
             assert w_floor = "0001" report "bottom floor... can't move down" severity failure;      
          
		  	
		wait; -- wait forever
	end process;	
	-----------------------------------------------------	
	
end test_bench;