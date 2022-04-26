library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity tb_system is
end tb_system;

architecture tb of tb_system is

-------------------
--  DECLARATIONS --
-------------------

  constant FREQ        : integer := 100000000;
  constant PERIOD      : time    := 1 sec / FREQ;
  constant HALF_PERIOD : time    := PERIOD / 2;

  component system is
    port (
      -- MOTOR
      mclk      : in std_logic;
      reset     : in std_logic;
      dir_synch : out std_logic;
      en_synch  : out std_logic; 
      -- VELOCITY DISPLAY
      SA        : in std_logic;
      SB        : in std_logic;
      c         : out std_logic;
      abcdefg   : out std_logic_vector(6 downto 0)
    );
  end component system;

  signal reset : std_logic := '1';
  signal mclk  : std_logic := '1';
  signal SA    : std_logic := '0';
  signal SB    : std_logic := '0';

----------------------
BEGIN -- STATEMENTS --
----------------------

UUT: entity work.system
  port map(
    reset => reset,
    mclk  => mclk,
    SA    => SA,
    SB    => SB
  );

mclk <= not mclk after HALF_PERIOD;

process is
begin
  wait for 5 ns;
  reset <= '0';
  wait for 10 sec;
  std.env.stop;
end process;

end architecture tb;
