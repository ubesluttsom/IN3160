library IEEE;
use IEEE.std_logic_1164.all;

entity TEST_FIRST is
-- Empty entity of the testbench
end TEST_FIRST;

architecture TESTBENCH of TEST_FIRST is
  -- Area for declarations

  -- Component declaration
  component FIRST
    port
    (
        clk       : in  std_logic;      -- Clock signal from push button
        reset     : in  std_logic;      -- Global asynchronous reset
        load      : in  std_logic;      -- Synchronous reset
        inp       : in  std_logic_vector(3 downto 0);  -- Start value
        count     : out std_logic_vector(3 downto 0);  -- Count value
        max_count : out std_logic;      -- Indicates maximum count value
        min_count : out std_logic;      -- XXX: Indicates minimum count value
        up        : in  std_logic       -- XXX: Count direction (up/down)
    );
  end component;

  signal tb_clk       : std_logic := '0';
  signal tb_reset     : std_logic := '0';
  signal tb_load      : std_logic := '0';
  signal tb_inp       : std_logic_vector(3 downto 0) := "0000";
  signal tb_count     : std_logic_vector(3 downto 0);
  signal tb_max_count : std_logic;
  signal tb_min_count : std_logic;          -- XXX
  signal tb_up        : std_logic := '1';   -- XXX

  -- 50 MHz clock frequency
  constant HALF_PERIOD : time := 10 ns;
  constant PERIOD      : time := 20 ns;   -- XXX
  
begin
  -- Concurrent statements

  -- Instantiating the unit under test
  UUT : FIRST
    port map
    (
      clk       => tb_clk,
      reset     => tb_reset,
      load      => tb_load,
      inp       => tb_inp,
      count     => tb_count,
      max_count => tb_max_count,
      min_count => tb_min_count,   -- XXX
      up        => tb_up           -- XXX
    );

  -- Generating the clock signal
  tb_clk <= not tb_clk after HALF_PERIOD;

  STIMULI :
  process
  begin
    tb_reset <= '1', '0' after PERIOD;

    -- Count to 20. This should trigger an overflow, and make `max_count`
    -- pulse once:
    wait for PERIOD*20;

    -- Reset to 0 again:
    tb_reset <= '1', '0' after PERIOD;

    -- Count to 10, then set 7 as input and load:
    wait for PERIOD*10;
    tb_inp <= "0111", "0000" after PERIOD;
    tb_load <= '1', '0' after PERIOD;

    -- Count 3, then reverse counting:
    wait for PERIOD*3;
    tb_up  <= '0';

    -- Wait until one overflow (underflow?) is triggered:
    wait for PERIOD*16;

    -- Stop.
    std.env.stop(0);
  end process;
  
end TESTBENCH;
