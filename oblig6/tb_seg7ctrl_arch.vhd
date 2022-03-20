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
  constant FREQ : integer := 100000000;
  constant PERIOD      : time := 1 sec / FREQ;
  constant HALF_PERIOD : time := PERIOD / 2;

  -- The tick counter needs to store log(100E6) bits. Rounded up, this is
  -- 27. The `rom_pos` stores the current position in the ROM arrays.
  signal second_tick : std_logic := '0';
  signal counter     : unsigned(26 downto 0) := (others => '0');
  signal rom_pos     : unsigned(3  downto 0) := (others => '0');
  type rom is array(0 to 15) of std_logic_vector(3 downto 0);
  constant D1_ROM : rom := (
    0  => x"1",
    1  => x"3",
    2  => x"4",
    3  => x"0",
    4  => x"5",
    5  => x"7",
    6  => x"0",
    7  => x"8",
    8  => x"9",
    9  => x"0",
    10 => x"A",
    11 => x"3",
    12 => x"0",
    13 => x"C",
    14 => x"6",
    15 => x"0"
  );
  constant D0_ROM : rom := (
    0  => x"2",
    1  => x"4",
    2  => x"0",
    3  => x"0",
    4  => x"6",
    5  => x"3",
    6  => x"0",
    7  => x"6",
    8  => x"0",
    9  => x"0",
    10 => x"B",
    11 => x"0",
    12 => x"0",
    13 => x"6",
    14 => x"5",
    15 => x"0"
  );
  
----------------------
BEGIN -- STATEMENTS --
----------------------

UUT: entity work.seg7ctrl
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

-- Generating `second_tick` and increment `rom_pos`
process (tb_mclk)
begin
  if rising_edge(tb_mclk) then
    if counter = FREQ - 1 /* NOTE: use smaller value for testing */ then
      second_tick <= '1';
      counter <= (others => '0');
      rom_pos <= rom_pos + 1;
      tb_d0 <= D0_ROM(to_integer(rom_pos));
      tb_d1 <= D1_ROM(to_integer(rom_pos));
    else
      second_tick <= '0';
      counter <= counter + 1;
      tb_d0 <= (others => '0');
      tb_d1 <= (others => '0');
    end if;
  end if;
end process;

end architecture tb;
