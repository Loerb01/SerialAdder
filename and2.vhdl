-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : and2.vhd
--
-- Entity    : and2
-- Architecture    : behv
--
-- Description    : 2 input and gate
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity and2 is
  port (
    a : in    std_logic;
    b : in    std_logic;
    y : out   std_logic
  );
end entity and2;

architecture behv of and2 is

begin
    y <= a and b after 4 ns;
end architecture behv;
