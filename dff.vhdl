-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : dff.vhd
--
-- Entity    : dff
-- Architecture    : behv
--
-- Description    : Simple rising edge D-Flip Flop
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity dff is
  port (
    d   : in    std_logic;
    clk : in    std_logic;
    rst : in    std_logic;
    en  : in    std_logic;
    q   : out   std_logic
  );
end entity dff;

architecture behv of dff is

begin

  q_proc : process is

  begin

    wait on clk, rst;

    -- rst clears the output
    if (rst = '0') then
      q <= '0';

    elsif (rising_edge(clk) and en = '1') then
      q <= d after 6 ns;
    end if;

  end process q_proc;

end architecture behv;
