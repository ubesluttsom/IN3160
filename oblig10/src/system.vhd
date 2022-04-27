library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity system is
  generic (
    FREQ     : integer := 100000000;
    PWM_FREQ : integer := 2000
  );
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
    abcdefg   : out std_logic_vector(6 downto 0);
    -- PS-SYSTEM
    gpio      : out std_logic_vector(7 downto 0);
    gpio2     : out std_logic_vector(7 downto 0)
  );
end system;

architecture implementation of system is

-------------------
--  DECLARATIONS --
-------------------

-- MOTOR

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

  signal sys_duty_cycle : std_logic_vector(7 downto 0);
  signal sys_dir        : std_logic;
  signal sys_en         : std_logic;

-- VELOCITY DISPLAY

component input_synchronizer is 
  port (
    reset    : in  std_logic;
    mclk     : in  std_logic;
    SA       : in  std_logic;
    SB       : in  std_logic;
    SA_synch : out std_logic;
    SB_synch : out std_logic
  );  
end component input_synchronizer;

component quadrature_decoder is
  port(
    reset   : in  std_logic;
    mclk    : in  std_logic;
    SA      : in  std_logic;
    SB      : in  std_logic;
    pos_inc : out std_logic;
    pos_dec : out std_logic
  );
end component quadrature_decoder;

component velocity_reader is
  port(
    reset    : in std_logic;
    mclk     : in std_logic;
    pos_inc  : in std_logic;
    pos_dec  : in std_logic;
    velocity : out signed(7 downto 0)
  );
end component velocity_reader;

component seg7ctrl is
  port (
    mclk    : in  std_logic;
    reset   : in  std_logic;
    d0      : in  std_logic_vector(3 downto 0);
    d1      : in  std_logic_vector(3 downto 0);
    abcdefg : out std_logic_vector(6 downto 0);
    c       : out std_logic
  );
end component seg7ctrl;

signal sys_SA_synch : std_logic;
signal sys_SB_synch : std_logic;
signal sys_pos_inc  : std_logic;
signal sys_pos_dec  : std_logic;
signal sys_velocity : signed(7 downto 0);
signal sys_d0       : std_logic_vector(3 downto 0);
signal sys_d1       : std_logic_vector(3 downto 0);

signal sys_velocity_unsigned : unsigned(7 downto 0);

----------------------
BEGIN -- STATEMENTS --
----------------------

-- MOTOR

SETEM: entity work.self_test_module(self_test_module)
  generic map(
    FREQ    => FREQ,
    N_TIMES => 3
  )
  port map (
    mclk       => mclk,
    reset      => reset,
    duty_cycle => sys_duty_cycle
  );

PWMMO: entity work.pulse_width_modulator
  generic map(
    CLK_FREQ => FREQ,
    PWM_FREQ => PWM_FREQ
  )
  port map(
    mclk       => mclk,
    reset      => reset,
    duty_cycle => sys_duty_cycle,
    dir        => sys_dir,
    en         => sys_en
  );

OUTSY: entity work.output_synchronizer
  port map(
    reset     => reset,
    mclk      => mclk,
    en        => sys_en,
    dir       => sys_dir,
    en_synch  => en_synch,
    dir_synch => dir_synch
  );

-- VELOCITY DISPLAY

NSYNC: entity work.input_synchronizer
  port map(
    reset    => reset,
    mclk     => mclk,
    SA       => SA,
    SB       => SB,
    SA_synch => sys_SA_synch,
    SB_synch => sys_SB_synch
  );

QUADE: entity work.quadrature_decoder
  port map(
    reset   => reset,
    mclk    => mclk,
    SA      => sys_SA_synch,
    SB      => sys_SB_synch,
    pos_inc => sys_pos_inc,
    pos_dec => sys_pos_dec
  );

VELOR: entity work.velocity_reader
  port map(
    reset    => reset,
    mclk     => mclk,
    pos_inc  => sys_pos_inc,
    pos_dec  => sys_pos_dec,
    velocity => sys_velocity
  );

SEG7C: entity work.seg7ctrl
  port map(
    mclk    => mclk,
    reset   => reset,
    d0      => sys_d0,
    d1      => sys_d1,
    abcdefg => abcdefg,
    c       => c
  );

-- PS-SYSTEM
gpio  <= sys_duty_cycle;
gpio2 <= sys_velocity;

sys_velocity_unsigned <= unsigned(abs(sys_velocity));
sys_d0 <= std_logic_vector(sys_velocity_unsigned(7 downto 4));
sys_d1 <= std_logic_vector(sys_velocity_unsigned(3 downto 0));

end architecture implementation;
