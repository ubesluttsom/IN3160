library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity tb_seg7ctrl is
end tb_seg7ctrl;

architecture tb of tb_seg7ctrl is

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

  component seg7model is 
    port(
      c         : in  std_logic;
      abcdefg   : in  std_logic_vector(6 downto 0);
      disp1     : out std_logic_vector(3 downto 0);
      disp0     : out std_logic_vector(3 downto 0)
    );
  end component seg7model;

  signal tb_mclk    : std_logic := '0';
  signal tb_reset   : std_logic := '0';
  signal tb_d0      : std_logic_vector(3 downto 0);
  signal tb_d1      : std_logic_vector(3 downto 0);
  signal tb_abcdefg : std_logic_vector(6 downto 0);
  signal tb_c       : std_logic;

  -- 100 MHz clock frequency
  constant PERIOD      : time := 1 sec / 100E6;
  constant HALF_PERIOD : time := 0.5 sec / 100E6;
  
----------------------
BEGIN -- STATEMENTS --
----------------------

UUT: entity work.seg7ctrl(seg7ctrl)
  port map (
    mclk    => tb_mclk,
    reset   => tb_reset,
    d0      => tb_d0,
    d1      => tb_d1,
    abcdefg => tb_abcdefg,
    c       => tb_c
  );    

S7M: entity work.seg7model
  port map (
    c       => tb_c,
    abcdefg => tb_abcdefg
  );

-- Generating the clock signal
tb_mclk <= not tb_mclk after HALF_PERIOD;

process begin

  -- Test entire range 0–F on both displays. This will run for a loooong
  -- time, so interrupt it if you're impatient.
  for i in 0 to 15 loop
    tb_d0 <= std_logic_vector(to_unsigned(i, tb_d0'length));
    for j in 0 to 15 loop
      tb_d1 <= std_logic_vector(to_unsigned(j, tb_d1'length));
      wait for 40 ms;
    end loop;
  end loop;

  std.env.stop(0);

end process;

end architecture tb;
