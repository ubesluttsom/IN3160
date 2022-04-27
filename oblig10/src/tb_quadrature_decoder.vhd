library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity tb_quadrature_decoder is
end tb_quadrature_decoder;

architecture tb of tb_quadrature_decoder is

-------------------
--  DECLARATIONS --
-------------------

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

signal tb_reset    : std_logic := '1';
signal tb_mclk     : std_logic := '0';
signal tb_SA       : std_logic := '0';
signal tb_SB       : std_logic := '0';
signal tb_SA_synch : std_logic := '0';
signal tb_SB_synch : std_logic := '0';
signal tb_pos_inc  : std_logic := '0';
signal tb_pos_dec  : std_logic := '0';
signal tb_velocity : signed(7 downto 0)           := (others => '0');
signal tb_d0       : std_logic_vector(3 downto 0) := (others => '0');
signal tb_d1       : std_logic_vector(3 downto 0) := (others => '0');
signal tb_abcdefg  : std_logic_vector(6 downto 0) := (others => '0');
signal tb_c        : std_logic := '0';

signal tb_velocity_unsigned : unsigned(7 downto 0) := (others => '0');

constant FREQ        : integer := 100000000;
constant PERIOD      : time    := 1 sec / FREQ;
constant HALF_PERIOD : time    := PERIOD / 2;

----------------------
BEGIN -- STATEMENTS --
----------------------

NSYNC: entity work.input_synchronizer
  port map(
    reset    => tb_reset,
    mclk     => tb_mclk,
    SA       => tb_SA,
    SB       => tb_SB,
    SA_synch => tb_SA_synch,
    SB_synch => tb_SB_synch
  );

QUADE: entity work.quadrature_decoder
  port map(
    reset   => tb_reset,
    mclk    => tb_mclk,
    SA      => tb_SA_synch,
    SB      => tb_SB_synch,
    pos_inc => tb_pos_inc,
    pos_dec => tb_pos_dec
  );

VELOR: entity work.velocity_reader
  port map(
    reset    => tb_reset,
    mclk     => tb_mclk,
    pos_inc  => tb_pos_inc,
    pos_dec  => tb_pos_dec,
    velocity => tb_velocity
  );

SEG7C: entity work.seg7ctrl
  port map(
    mclk    => tb_mclk,
    reset   => tb_reset,
    d0      => tb_d0,
    d1      => tb_d1,
    abcdefg => tb_abcdefg,
    c       => tb_c
  );

tb_mclk <= not tb_mclk after HALF_PERIOD;

tb_velocity_unsigned <= unsigned(abs(tb_velocity));
tb_d0 <= std_logic_vector(tb_velocity_unsigned(7 downto 4));
tb_d1 <= std_logic_vector(tb_velocity_unsigned(3 downto 0));

STIMU: process is
begin
  wait for PERIOD * 30000; tb_reset <= '0';
  for i in 1 to 100 loop
    wait for PERIOD * 4000; tb_SA <= '1';
    wait for PERIOD * 4000; tb_SB <= '1';
    wait for PERIOD * 4000; tb_SA <= '0';
    wait for PERIOD * 4000; tb_SB <= '0';
  end loop;
  wait for PERIOD * 30000;
  -- Reverse
  for i in 1 to 100 loop
    wait for PERIOD * 4000; tb_SB <= '1';
    wait for PERIOD * 4000; tb_SA <= '1';
    wait for PERIOD * 4000; tb_SB <= '0';
    wait for PERIOD * 4000; tb_SA <= '0';
  end loop;
  wait for PERIOD * 30000;
  std.env.stop; 
end process;

end architecture tb;
