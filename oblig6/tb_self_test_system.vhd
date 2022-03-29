library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity tb_self_test_system is
end tb_self_test_system;

architecture tb of tb_self_test_system is

-------------------------------------
-- COMPONENT & SIGNAL DECLARATIONS --
-------------------------------------

  component self_test_system is
    port (
      mclk      : in  std_logic; -- 100MHz, positive flank
      reset     : in  std_logic; -- Asynchronous reset, active high
      c         : out std_logic;
      abcdefg_n : out std_logic_vector(6 downto 0)
    );
  end component self_test_system;

  -- 100 MHz clock frequency
  constant FREQ : integer := 100000000;
  constant PERIOD      : time := 1 sec / FREQ;
  constant HALF_PERIOD : time := PERIOD / 2;

  signal mclk  : std_logic := '0';
  signal reset : std_logic := '0';

----------------------
BEGIN -- STATEMENTS --
----------------------

UUT: entity work.self_test_system(self_test_system)
  port map (
    mclk  => mclk,
    reset => reset
  );

mclk <= not mclk after HALF_PERIOD;

end architecture tb;
