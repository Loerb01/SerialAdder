-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : serial_adder.vhd
--
-- Entity    : serial_adder
-- Architecture    : struct
--
-- Description    : 4 bit serial adder
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity serial_adder is
  port (
    in_a     : in    std_logic_vector(3 downto 0);
    in_b     : in    std_logic_vector(3 downto 0);
    control  : in    std_logic_vector(1 downto 0);
    clk      : in    std_logic;
    clear_dp : in    std_logic;
    sum      : out   std_logic_vector(3 downto 0);
    carry    : out   std_logic
  );
end entity serial_adder;

architecture struct of serial_adder is

  component dm74ls194a is
    port (
      a     : in    std_logic;
      b     : in    std_logic;
      c     : in    std_logic;
      d     : in    std_logic;
      s0    : in    std_logic;
      s1    : in    std_logic;
      sr    : in    std_logic;
      sl    : in    std_logic;
      clk   : in    std_logic;
      clear : in    std_logic;
      qa    : out   std_logic;
      qb    : out   std_logic;
      qc    : out   std_logic;
      qd    : out   std_logic
    );
  end component dm74ls194a;

  component and2 is
    port (
      a : in    std_logic;
      b : in    std_logic;
      y : out   std_logic
    );
  end component and2;

  component inv is
    port (
      a : in    std_logic;
      y : out   std_logic
    );
  end component inv;

  component fulladder is
    port (
      a    : in    std_logic;
      b    : in    std_logic;
      c    : in    std_logic;
      sum  : out   std_logic;
      cout : out   std_logic
    );
  end component fulladder;

  component dff is
    port (
      d   : in    std_logic;
      clk : in    std_logic;
      rst : in    std_logic;
      en  : in    std_logic;
      q   : out   std_logic
    );
  end component dff;

  signal aqa : std_logic;
  signal aqb : std_logic;
  signal aqc : std_logic;
  signal aqd : std_logic;

  signal bqd : std_logic;

  signal fa_sum : std_logic := '0';
  signal fa_cout : std_logic := '0';

  signal dff_q : std_logic := '0';
  signal dff_en : std_logic := '0';

  signal not_ctrl1 : std_logic;

begin

  sum   <= aqa & aqb & aqc & aqd;
  carry <= dff_q;

  -- Number one, and output store
  reg_a : dm74ls194a
    port map (
      a     => in_a(3),
      b     => in_a(2),
      c     => in_a(1),
      d     => in_a(0),
      s0    => control(0),
      s1    => control(1),
      sr    => fa_sum,
      sl    => '0',
      clk   => clk,
      clear => clear_dp,
      qa    => aqa,
      qb    => aqb,
      qc    => aqc,
      qd    => aqd
    );

  -- Number two
  reg_b : dm74ls194a
    port map (
      a     => in_b(3),
      b     => in_b(2),
      c     => in_b(1),
      d     => in_b(0),
      s0    => control(0),
      s1    => control(1),
      sr    => '0',
      sl    => '0',
      clk   => clk,
      clear => clear_dp,
      qd    => bqd
    );

  -- Adder that does work
  fa : fulladder
    port map (
      a    => aqd,
      b    => bqd,
      c    => dff_q,
      sum  => fa_sum,
      cout => fa_cout
    );

  -- Carry D-Flip Flop
  ff : dff
    port map (
      d   => fa_cout,
      q   => dff_q,
      clk => clk,
      en  => dff_en,
      rst => clear_dp
    );

  -- Logic for flip flop enable
  ctrl_inv : inv
    port map (
      a => control(1),
      y => not_ctrl1
    );
  en_make : and2
    port map (
      a => control(0),
      b => not_ctrl1,
      y => dff_en
    );

end architecture struct;
