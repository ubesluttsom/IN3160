library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.math_real.all; -- For the `ceil` and `log2` functions.
  use STD.textio.all;

entity self_test_module is
  generic(
    -- Defaults to 100 MHz clock frequency. Change every 3 seconds.
    FREQ    : integer := 100000000;
    N_TIMES : integer := 3
  );
  port (
    mclk       : in  std_logic; -- 100MHz, positive flank
    reset      : in  std_logic;
    duty_cycle : out std_logic_vector(6 downto 0)
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
      data_width: natural;
      addr_width: natural;
      filename:   string);
    port(
      address: in std_logic_vector(addr_width-1 downto 0);
      data:   out std_logic_vector(data_width-1 downto 0));
  end component;
  signal addr: std_logic_vector(5 downto 0) := (others => '0');
  
----------------------
BEGIN -- STATEMENTS --
----------------------

TEST_VALUES: ROM
  generic map(
    data_width => 7,
    addr_width => addr'length,
    filename   => "rom_data.txt")
  port map(
    address => addr,
    data => duty_cycle);

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

-- Increment `addr` on each `second_tick`.
process (second_tick, reset)
begin
  if (reset = '1') then
    -- Asynchronous reset
    -- duty_cycle <= (others => '0');
    addr <= (others => '0');
  elsif rising_edge(second_tick) then
      addr <= std_logic_vector(unsigned(addr) + 1);
  end if;
end process;

end architecture self_test_module;
