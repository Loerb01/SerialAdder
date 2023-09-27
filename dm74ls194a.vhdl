-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : dm74ls194a.vhd
--
-- Entity    : dm74ls194a
-- Architecture    : behv
--
-- Description    : Universal Shift Register
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity dm74ls194a is
  port (
    -- a-d are paralell inputs
    a     : in    std_logic;
    b     : in    std_logic;
    c     : in    std_logic;
    d     : in    std_logic;
    -- s0, s1 are control bit
    s0    : in    std_logic;
    s1    : in    std_logic;
    -- sr, sl are shift inputs
    sr    : in    std_logic;
    sl    : in    std_logic;
    clk   : in    std_logic;
    clear : in    std_logic;
    -- qa-qd are the outputs
    qa    : out   std_logic;
    qb    : out   std_logic;
    qc    : out   std_logic;
    qd    : out   std_logic
  );
end entity dm74ls194a;

architecture behv of dm74ls194a is

  -- The current state of the register
  signal state : std_logic_vector(3 downto 0);

  signal control_bits : std_logic_vector(1 downto 0);

begin

  -- Group s1 and s0 for ease of use
  control_bits <= s1 & s0;

  proc : process is
  begin

    if (clear = '0') then

      state <= "0000";

      wait for 22 ns;

      qa <= state(3);
      qb <= state(2);
      qc <= state(1);
      qd <= state(0);

    elsif (rising_edge(clk)) then

        case control_bits is

          -- Paralell load
          when "11" =>

            state <= a & b & c & d;

          -- Shift right
          when "01" =>

            state <= sr & state(3 downto 1);

          -- Shift left
          when "10" =>

            state <= state(2 downto 0) & sl;

          -- Hold state
          when others =>

            state <= state;

        end case;

        wait for 22 ns;

        qa <= state(3);
        qb <= state(2);
        qc <= state(1);
        qd <= state(0);

    end if;

    wait on clk, clear;

  end process proc;

end architecture behv;
