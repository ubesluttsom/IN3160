library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity tb_output is
end tb_output;

architecture tb of tb_output is

-------------------
--  DECLARATIONS --
-------------------

  -- Using a lower frequency for a lighter simulation load. The code should
  -- automatically adjust to the correct period, regardless.

  constant FREQ        : integer := 100000000;
  constant PWM_FREQ    : integer := 2000;
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
      duty_cycle : out std_logic_vector(7 downto 0)
    );
  end component self_test_module;

  component pulse_width_modulator is
    generic(
      CLK_FREQ : integer;
      PWM_FREQ : integer
    );
    port(
      mclk       : in std_logic;
      reset      : in std_logic;
      duty_cycle : in std_logic_vector(7 downto 0);
      dir        : out std_logic;
      en         : out std_logic
    );
  end component pulse_width_modulator;

  component output_synchronizer is 
    port (
      reset     : in  std_logic;
      mclk      : in  std_logic;
      en        : in  std_logic;
      dir       : in  std_logic;
      en_synch  : out std_logic;
      dir_synch : out std_logic
    );  
  end component output_synchronizer;

  signal tb_mclk       : std_logic := '1';
  signal tb_reset      : std_logic := '0';
  signal tb_duty_cycle : std_logic_vector(7 downto 0);
  signal tb_dir        : std_logic;
  signal tb_en         : std_logic;
  signal tb_dir_synch  : std_logic;
  signal tb_en_synch   : std_logic;

----------------------
BEGIN -- STATEMENTS --
----------------------

STM: entity work.self_test_module(self_test_module)
  generic map(
    FREQ    => FREQ,
    N_TIMES => 3
  )
  port map (
    mclk  => tb_mclk,
    reset => tb_reset,
    duty_cycle => tb_duty_cycle
  );

PWM: entity work.pulse_width_modulator
  generic map(
    CLK_FREQ => FREQ,
    PWM_FREQ => PWM_FREQ
  )
  port map(
    mclk       => tb_mclk,
    reset      => tb_reset,
    duty_cycle => tb_duty_cycle,
    dir        => tb_dir,
    en         => tb_en
  );

UUT: entity work.output_synchronizer
  port map(
    reset     => tb_reset,
    mclk      => tb_mclk,
    en        => tb_en,
    dir       => tb_dir,
    en_synch  => tb_en_synch,
    dir_synch => tb_dir_synch
  );

tb_mclk <= not tb_mclk after HALF_PERIOD;

end architecture tb;
