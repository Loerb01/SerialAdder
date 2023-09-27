-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : fulladder.vhd
--
-- Entity    : fulladder
-- Architecture    : behv
--
-- Description    : Simple full adder
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity fulladder is
  port (
    a    : in    std_logic;
    b    : in    std_logic;
    c    : in    std_logic;
    sum  : out   std_logic;
    cout : out   std_logic
  );
end entity fulladder;

architecture behv of fulladder is

begin
    sum <= a xor b xor c after 8 ns;
    cout <= (a and b) or (a and c) or (b and c) after 8 ns;
end architecture behv;
