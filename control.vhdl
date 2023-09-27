-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : control.vhd
--
-- Entity    : control
-- Architecture    : behav
--
-- Description    : serial adder control unit
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity control is
  port (
    start          : in    std_logic;
	  clk            : in    std_logic;
	  clear_sm       : in    std_logic;
	  control_output : out   std_logic_vector(3 downto 0)
  );
end entity control;

architecture behav of control is

  type state_type is (idle, reset, load, s1, s2, s3, s4, hold, clr);

  signal next_state : state_type;
  signal curr_state : state_type;

begin

  curr_state_proc : process (clk, clear_sm)
  begin

    -- State to clear the whole circuit
    if (clear_sm = '0') then
	    curr_state <= clr;

    -- Go to the next state
	  elsif(rising_edge(clk)) then
	    curr_state <= next_state after 10 ns;

	end if;

  end process curr_state_proc;

  next_state_proc : process (clk)
  begin

      -- Changing on the rising edge causes problems
      if (falling_edge(clk)) then

  	    case curr_state is

  	      -- Only move out of the idle state when start is HIGH
  	      when idle =>
  	  	    if (start = '1') then
  		      next_state <= reset;
  		    else
  		      next_state <= idle;
  		    end if;

  	      when reset =>
  		      next_state <= load;

  	      when load =>
  		      next_state <= s1;

  	      when s1 =>
  		      next_state <= s2;

  	      when s2 =>
  		      next_state <= s3;

  	      when s3 =>
  		      next_state <= s4;

  	      when s4 =>
  		      next_state <= hold;

  		    -- hold and clr should both go to idle
  	      when others =>
  		      next_state <= idle;

  	    end case;

	  end if;

  end process next_state_proc;

  out_proc : process (curr_state)
  begin

    case curr_state is

      -- Have registers keep values and don't operate flip flop, set ready
     when idle =>
 	    control_output <= "1100";

      -- Set registers and flip flop to clear value
	    when reset | clr =>
		    control_output <= "0000";

      -- Set registers to take serial input, don't operate flip flop
	    when load =>
		    control_output <= "0111";

      -- Have registers keep values, don't operate flip flop, not ready
	    when hold =>
        control_output <= "0100";

      -- All other states are waiting for clock cycles, operate flip flop, registers shift
		  when others =>
		    control_output <= "0101";

	  end case;

  end process out_proc;

end architecture behav;
