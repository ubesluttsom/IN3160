library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FIRST is
  port
  (
      clk       : in  std_logic;        -- Clock signal from push button
      reset     : in  std_logic;        -- Global asynchronous reset
      load      : in  std_logic;        -- Synchronous load signal
      inp       : in  std_logic_vector(3 downto 0);  -- Start value
      count     : out std_logic_vector(3 downto 0);  -- Count value
      max_count : out std_logic;        -- Indicates maximum count value
      min_count : out std_logic;        -- XXX: Indicates minimum count value
      up        : in  std_logic         -- XXX: Count direction (up/down)
  );
end FIRST;

-- The architecture below describes a 4-bit up counter. When the counter
-- reaches its maximum value, the signal MAX_COUNT is activated.

architecture MY_FIRST_ARCH of FIRST is

  --  Area for declarations
  signal count_i : unsigned(3 downto 0);
  
begin
  --  The description starts here
  
  COUNTING :
  process (all)
  begin
    if load = '1' then
      count_i <= unsigned(inp);
    elsif up = '0' then
      count_i <= unsigned(count) - 1;
    elsif up = '1' then
      count_i <= unsigned(count) + 1;
    end if;
  end process COUNTING;

  STORING:
  process (reset, clk)
  begin
    -- Asynchronous reset
    if (reset = '1') then
      count <= "0000";
    elsif rising_edge(clk) then
      count <= std_logic_vector(count_i);
    end if;
  end process STORING;

  MAX_MIN_PULSE:
  process (clk)
  begin
    if rising_edge(clk) then
      if count = "1110" and up = '1' and max_count = '0' then
        max_count <= '1';
      elsif count = "0001" and up = '0' and min_count = '0' then
        min_count <= '1';
      else
        max_count <= '0';
        min_count <= '0';
      end if;
    end if;
  end process MAX_MIN_PULSE;

  -- Concurrent signal assignment
  -- (none)

end MY_FIRST_ARCH;
