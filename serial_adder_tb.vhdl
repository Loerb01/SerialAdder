-- Company    : RIT
-- Author    : lcb4007
-- Created    : 2023-04-28
--
-- Project Name    : Lab12
-- File        : serial_adder_tb.vhd
--
-- Entity    : serial_adder_tb
-- Architecture    : bench
--
-- Description    : Serial Adder Test Bench
--
-- Notes    : None

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity serial_adder_tb is
end entity serial_adder_tb;

architecture bench of serial_adder_tb is

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

  -- Test record datatype
  type test_record is record
    ina : std_logic_vector(3 downto 0);
    inb : std_logic_vector(3 downto 0);
    sum : std_logic_vector(3 downto 0);
    cry : std_logic;
  end record test_record;

  type test_record_array is array (natural range <>) of test_record;

  constant tests : test_record_array := (
    (X"0", X"4", X"4", '0'),
    (X"C", X"E", X"A", '1'),
    (X"8", X"A", X"2", '1'),
    (X"F", X"F", X"E", '1'),
    (X"F", X"1", X"0", '1'),
    (X"A", X"5", X"2", '0'), -- Intentionally fails
    (X"8", X"7", X"F", '0')
  );

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
  end component;

  signal in_a     : std_logic_vector(3 downto 0);
  signal in_b     : std_logic_vector(3 downto 0);
  signal control  : std_logic_vector(1 downto 0) := "11";
  signal clk      : std_logic := '1';
  signal clear_dp : std_logic;
  signal sum      : std_logic_vector(3 downto 0);
  signal carry    : std_logic;

begin

  clk <= not clk after clock_period/2;

  uut : component serial_adder
    port map (
      in_a     => in_a,
      in_b     => in_b,
      control  => control,
      clk      => clk,
      clear_dp => clear_dp,
      sum      => sum,
      carry    => carry
    );

  stimulus : process is
  begin

    wait for 50 ns;

    for i in tests'range loop
      --Set paralell load, and clear current values
      control <= "11";
      clear_dp <= '0';
      wait for clock_period/2;
      clear_dp <= '1';
      wait for clock_period/2;
      -- Load Calculation
      in_a <= tests(i).ina;
      in_b <= tests(i).inb;
      wait for clock_period;
      -- Set to operate
      control <= "01";
      -- Wait for opreation to finish and assert results
      wait for clock_period*4;
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
