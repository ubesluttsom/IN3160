library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.math_real.all; -- For the `ceil` and `log2` functions.
  use STD.textio.all;

entity self_test_module is
  generic(
    -- Defaults to 100 MHz clock frequency. Change every 3 seconds.
    FREQ       : integer := 100000000;
    N_TIMES    : integer := 3;
    ROM_LINES  : integer := 20;
    ADDR_WIDTH : integer := 5;
    DATA_WIDTH : integer := 8
  );
  port (
    mclk       : in  std_logic; -- 100MHz, positive flank
    reset      : in  std_logic;
    duty_cycle : out std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end self_test_module;

architecture self_test_module of self_test_module is

------------------
-- DECLARATIONS --
------------------

  -- The tick counter needs to store log(N_TIMES*FREQ) bits, I round up.
  signal second_tick : std_logic := '0';
  signal counter : unsigned(integer(ceil(log2(real(N_TIMES*FREQ))))-1 downto 0)
      := (others => '0');

  -- Initializing ROM
  component ROM is
    generic(
      data_lines : natural;
      data_width : natural;
      addr_width : natural;
      filename   : string);
    port(
      address: in std_logic_vector(addr_width-1 downto 0);
      data:   out std_logic_vector(data_width-1 downto 0));
  end component;
  signal rom_addr : unsigned(ADDR_WIDTH-1 downto 0) := (others => '0');
  signal rom_data : std_logic_vector(DATA_WIDTH-1 downto 0) := (others => '0');
  
----------------------
BEGIN -- STATEMENTS --
----------------------

TEST_VALUES: ROM
  generic map(
    data_lines => ROM_LINES,
    data_width => DATA_WIDTH,
    addr_width => ADDR_WIDTH,
    filename   => "rom_data.txt")
  port map(
    address => std_logic_vector(rom_addr),
    data => rom_data);

-- Generating `second_tick`.
process (mclk, reset)
begin
  if (reset = '1') then
    -- Asynchronous reset
    counter <= (others => '0');
  elsif rising_edge(mclk) then
    if counter = N_TIMES * FREQ - 1 then
      second_tick <= '1';
      counter     <= (others => '0');
    else
      second_tick <= '0';
      counter     <= counter + 1;
    end if;
  end if;
end process;

-- Increment `rom_addr` on each `second_tick`.
process (mclk, reset)
begin
  if (reset = '1') then
    rom_addr <= (others => '0'); -- Asynchronous reset
  elsif rising_edge(mclk) then
    if (second_tick = '1') and (rom_addr < ROM_LINES) then
      rom_addr <= rom_addr + 1;
    end if;
  end if;
end process;

-- Set `duty_cycle`.
duty_cycle <= (others => '0') when (reset = '1') else rom_data;

end architecture self_test_module;
