-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : inv.vhd
--
-- Entity    : inv
-- Architecture    : behv
--
-- Description    : Single Inverter
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;

entity inv is
  port (
    a : in    std_logic;
    y : out   std_logic
  );
end entity inv;

architecture behv of inv is

begin
    y <= not a after 2 ns;
end architecture behv;
