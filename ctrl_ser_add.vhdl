-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : ctrl_ser_add.vhd
--
-- Entity    : ctrl_ser_add
-- Architecture    : struct
--
-- Description    : Serial Adder with control unit
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity ctrl_ser_add is
  port (
    clear_sm : in    std_logic;
    start    : in    std_logic;
    clk      : in    std_logic;
    ina      : in    std_logic_vector(3 downto 0);
    inb      : in    std_logic_vector(3 downto 0);
    ready    : out   std_logic;
    cout     : out   std_logic;
    sum      : out   std_logic_vector(3 downto 0)
  );
end entity ctrl_ser_add;

architecture struct of ctrl_ser_add is

  -- Already made serial adder circuit
  component serial_adder is
    port (
      in_a     : in    std_logic_vector(3 downto 0);
      in_b     : in    std_logic_vector(3 downto 0);
      control  : in    std_logic_vector(1 downto 0);
      clk      : in    std_logic;
      clear_dp : in    std_logic;
      sum      : out   std_logic_vector(3 downto 0);
      carry    : out   std_logic
    );
  end component serial_adder;

  -- Already made control circuit
  component control is
    port (
      start          : in    std_logic;
  	  clk            : in    std_logic;
  	  clear_sm       : in    std_logic;
  	  control_output : out   std_logic_vector(3 downto 0)
    );
  end component control;

  -- Map control unit signals to usable wires
  signal ctrl_sig : std_logic_vector(3 downto 0);

begin

  add : serial_adder
  port map (
    in_a => ina,
    in_b => inb,
    control => ctrl_sig(1 downto 0),
    clk => clk,
    clear_dp => ctrl_sig(2),
    sum => sum,
    carry => cout
  );

  ctrl : control
  port map (
    start => start,
    clk => clk,
    clear_sm => clear_sm,
    control_output => ctrl_sig
  );

  ready <= ctrl_sig(3);

end architecture struct;
