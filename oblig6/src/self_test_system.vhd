library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity self_test_system is
  port (
    mclk      : in  std_logic; -- 100MHz, positive flank
    reset     : in  std_logic; -- Asynchronous reset, active high
    c         : out std_logic;
    abcdefg_n : out std_logic_vector(6 downto 0)
  );
end self_test_system;

architecture self_test_system of self_test_system is

-------------------------------------
-- COMPONENT & SIGNAL DECLARATIONS --
-------------------------------------

  component seg7ctrl is
    port (
      mclk    : in  std_logic; -- 100MHz, positive flank
      reset   : in  std_logic; -- Asynchronous reset, active high
      d0      : in  std_logic_vector(3 downto 0);
      d1      : in  std_logic_vector(3 downto 0);
      abcdefg : out std_logic_vector(6 downto 0);
      c       : out std_logic
    );
  end component seg7ctrl;

  component self_test_unit is
    port (
      mclk  : in  std_logic; -- 100MHz, positive flank
      reset : in  std_logic; -- Asynchronous reset, active high
      d0    : out std_logic_vector(3 downto 0);
      d1    : out std_logic_vector(3 downto 0)
    );
  end component self_test_unit;

  signal sts_d0 : std_logic_vector(3 downto 0);
  signal sts_d1 : std_logic_vector(3 downto 0);

----------------------
BEGIN -- STATEMENTS --
----------------------

STU: entity work.self_test_unit(self_test_unit)
  port map (
    mclk    => mclk,
    reset   => reset,
    d0      => sts_d0,
    d1      => sts_d1
  );

S7C: entity work.seg7ctrl(seg7ctrl_arch)
  port map (
    mclk    => mclk,
    reset   => reset,
    d0      => sts_d0,
    d1      => sts_d1,
    abcdefg => abcdefg_n,
    c       => c
  );

end architecture self_test_system;
