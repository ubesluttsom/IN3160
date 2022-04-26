library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity tb_self_test_module is
end tb_self_test_module;

architecture tb of tb_self_test_module is

-------------------
--  DECLARATIONS --
-------------------

  -- 100 Hz clock frequency. Using lower frequency here, for a lighter
  -- simulation load. The code should automatically adjust to the correct
  -- period, regardless.

  constant FREQ        : integer := 100;
  constant PERIOD      : time    := 1 sec / FREQ;
  constant HALF_PERIOD : time    := PERIOD / 2;

  component self_test_module is
    generic(
      FREQ    : integer;
      N_TIMES : integer
    );
    port (
      mclk       : in  std_logic;
      reset      : in  std_logic;
      duty_cycle : out std_logic_vector(6 downto 0)
    );
  end component self_test_module;

  signal mclk  : std_logic := '1';
  signal reset : std_logic := '0';

----------------------
BEGIN -- STATEMENTS --
----------------------

UUT: entity work.self_test_module(self_test_module)
  generic map(
    FREQ    => FREQ,
    N_TIMES => 3
  )
  port map (
    mclk  => mclk,
    reset => reset
  );

mclk <= not mclk after HALF_PERIOD;

end architecture tb;
