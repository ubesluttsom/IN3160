library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity self_test_unit is
  port (
    mclk  : in  std_logic; -- 100MHz, positive flank
    reset : in  std_logic; -- Asynchronous reset, active high
    d0    : out std_logic_vector(3 downto 0);
    d1    : out std_logic_vector(3 downto 0)
  );
end self_test_unit;

architecture self_test_unit of self_test_unit is

-------------------------------------
-- COMPONENT & SIGNAL DECLARATIONS --
-------------------------------------

  signal abcdefg : std_logic_vector(6 downto 0);
  signal c       : std_logic;

  -- 100 MHz clock frequency
  constant FREQ : integer := 100000000;

  -- The tick counter needs to store log(100E6) bits. Rounded up, this is
  -- 27. The `rom_pos` stores the current position in the ROM arrays.
  signal second_tick : std_logic := '0';
  signal counter     : unsigned(26 downto 0) := (others => '0');
  
  -- Initializing ROM
  signal rom_pos     : unsigned(3  downto 0) := (others => '0');
  type rom is array(0 to 15) of std_logic_vector(3 downto 0);
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
  
----------------------
BEGIN -- STATEMENTS --
----------------------

-- Generating `second_tick`.
process (mclk, reset)
begin
  if (reset = '1') then
    -- Asynchronous reset
    counter <= (others => '0');
  elsif rising_edge(mclk) then
    if counter = FREQ - 1 then
      second_tick <= '1';
      counter     <= (others => '0');
    else
      second_tick <= '0';
      counter     <= counter + 1;
    end if;
  end if;
end process;

-- Display hidden message and increment `rom_pos` on each `second_tick`.
process (second_tick, reset)
begin
  if (reset = '1') then
    -- Asynchronous reset
    d0 <= (others => '0');
    d1 <= (others => '0');
    rom_pos <= (others => '0');
  elsif rising_edge(second_tick) then
      d0 <= D0_ROM(to_integer(rom_pos));
      d1 <= D1_ROM(to_integer(rom_pos));
      rom_pos <= rom_pos + 1;
  end if;
end process;

end architecture self_test_unit;
