-------------------------------------------------
-- Heavily based on slides from lecture on FSM --
-------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.math_real.all; -- For the `ceil` and `log2` functions.

entity pulse_width_modulator is
  generic(
    CLK_FREQ : integer := 100000000;
    PWM_FREQ : integer := 2000
  );
  port(
    mclk       : in std_logic; -- Assumed to be 100MHz.
    reset      : in std_logic;
    duty_cycle : in std_logic_vector(7 downto 0);
    dir        : out std_logic;
    en         : out std_logic
  );
end pulse_width_modulator;

architecture implementation of pulse_width_modulator is

-------------------
--  DECLARATIONS --
-------------------

  type state is (
    S_FORWARD_IDLE,
    S_REVERSE_IDLE,
    S_FORWARD,
    S_REVERSE
  );
  signal current_state : state;
  signal next_state    : state;

  -- Calculate the appropriate amount of bits needed for a counter.
  constant FREQ : integer := CLK_FREQ/PWM_FREQ;
  signal counter : unsigned(integer(ceil(log2(real(FREQ))))-1 downto 0)
      := (others => '0');

  signal PWM : std_logic := '0';

----------------------
BEGIN -- STATEMENTS --
----------------------

-- TODO: Fix me!
PWM <= '1' when unsigned(duty_cycle) < unsigned(counter) else '0';

COUNTER_LOGIC:
process (mclk, reset)
begin
  if (reset = '1') then
    counter <= (others => '0');
  elsif rising_edge(mclk) then
    counter <= (others => '0') when counter = FREQ - 1 else counter + 1;
  end if;
end process;

current_state <=
    S_REVERSE_IDLE when reset else
    next_state     when rising_edge(mclk);

NEXT_STATE_LOGIC:
process(duty_cycle, current_state) is
begin
  case current_state is
    when S_FORWARD_IDLE =>
      next_state <= S_FORWARD when unsigned(duty_cycle) > 0
          else S_REVERSE_IDLE;
    when S_REVERSE_IDLE =>
      next_state <= S_REVERSE when unsigned(duty_cycle) < 0
          else S_REVERSE_IDLE;
    when S_FORWARD =>
      next_state <= S_FORWARD when unsigned(duty_cycle) > 0
          else S_FORWARD_IDLE;
    when S_REVERSE =>
      next_state <= S_REVERSE when unsigned(duty_cycle) < 0
          else S_REVERSE_IDLE;
  end case;
end process next_state_logic;

OUTPUT_LOGIC:
process(all) is
begin
  -- Default values:
  en  <= '0';
  dir <= '0';
  -- State assignments:
  case current_state is
    when S_FORWARD_IDLE => en  <= '0';   dir <= '1';
    when S_REVERSE_IDLE => en  <= '0';   dir <= '0';
    when S_FORWARD =>      en  <= PWM; dir <= '1';
    when S_REVERSE =>      en  <= PWM; dir <= '0';
  end case;
end process output_logic;

end architecture implementation;
