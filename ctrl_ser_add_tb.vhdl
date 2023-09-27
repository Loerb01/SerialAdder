-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : ctrl_ser_add_tb.vhd
--
-- Entity    : ctrl_ser_add_tb
-- Architecture    : bench
--
-- Description    : Test bench for controlled serial adder
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ctrl_ser_add_tb is
end entity ctrl_ser_add_tb;

architecture bench of ctrl_ser_add_tb is

  function vec2str(vec: std_logic_vector) return string is
      variable stmp: string(vec'high+1 downto 1);
      variable counter : integer := 1;
  begin
      for i in vec'reverse_range loop
          stmp(counter) := std_logic'image(vec(i))(2); -- image returns '1' (with quotes)
          counter := counter + 1;
      end loop;
      return stmp;
  end vec2str;

  constant clock_period : time := 100 ns;

  -- Setup record datatype for storing test cases
  type test_record is record
    ina : std_logic_vector(3 downto 0);
    inb : std_logic_vector(3 downto 0);
    sum : std_logic_vector(3 downto 0);
    cry : std_logic;
  end record test_record;

  type test_record_array is array (natural range <>) of test_record;

  -- Some test cases
  constant tests : test_record_array := (
    (X"0", X"4", X"4", '0'),
    (X"C", X"E", X"A", '1'),
    (X"8", X"A", X"2", '1'),
    (X"F", X"F", X"E", '1'),
    (X"F", X"1", X"0", '1'),
    (X"A", X"5", X"2", '0'), -- Intentionally fails
    (X"8", X"7", X"F", '0')
  );

  component ctrl_ser_add is
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
  end component ctrl_ser_add;

  signal in_a     : std_logic_vector(3 downto 0);
  signal in_b     : std_logic_vector(3 downto 0);
  signal clk      : std_logic := '1';
  signal clear_sm : std_logic := '1';
  signal sum      : std_logic_vector(3 downto 0);
  signal carry    : std_logic;
  signal start    : std_logic;
  signal ready    : std_logic;

begin

  clk <= not clk after clock_period/2;

  uut : component ctrl_ser_add
    port map (
      start    => start,
      ready    => ready,
      ina      => in_a,
      inb      => in_b,
      clk      => clk,
      clear_sm => clear_sm,
      sum      => sum,
      cout     => carry
    );

  stimulus : process is
  begin

    wait for 50 ns;

    for i in tests'range loop
      -- Set inputs
      in_a <= tests(i).ina;
      in_b <= tests(i).inb;
      -- Start the operation
      start <= '1';
      -- Unset the start signal, so that it doesn't keep going
      wait for clock_period;
      start <= '0';
      -- Assert result when the circuit is ready
      wait until (ready = '1');
      assert (sum = tests(i).sum and carry = tests(i).cry)
        report "Failed test " & integer'image(i) & ". Added: " & vec2str(tests(i).ina) & " + " & vec2str(tests(i).inb) &
          ". Expeceted: " & vec2str(tests(i).sum) & " with carry " & std_logic'image(tests(i).cry) & ". Got: " & vec2str(sum) &
          " with carry " & std_logic'image(carry) & "."
          severity error;
	  report "Test " & integer'image(i) & " Finished";
	end loop;

	report "Simulation Finished!" severity error;

  wait;
  end process stimulus;

end architecture bench;
