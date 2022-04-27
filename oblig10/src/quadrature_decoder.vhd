-------------------------------------------------
-- Heavily based on slides from lecture on FSM --
-------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.math_real.all; -- For the `ceil` and `log2` functions.

entity quadrature_decoder is
  port(
    mclk    : in  std_logic;
    reset   : in  std_logic;
    SA      : in  std_logic;
    SB      : in  std_logic;
    pos_inc : out std_logic;
    pos_dec : out std_logic
  );
end quadrature_decoder;

architecture implementation of quadrature_decoder is

-------------------
--  DECLARATIONS --
-------------------

  type state is (
    S_RESET,
    S_INIT,
    S_0,
    S_1,
    S_2,
    S_3
  );
  signal current_state : state;
  signal next_state    : state;
  signal err : std_logic;
--  signal ab : std_logic_vector(1 downto 0);

----------------------
BEGIN -- STATEMENTS --
----------------------

current_state <=
    S_RESET    when reset else
    next_state when rising_edge(mclk);

-- ab <= (SA | SB)

NEXT_STATE_LOGIC:
process(SA, SB) is
begin
  case current_state is
    when S_RESET => next_state <= S_INIT;
    when S_INIT  =>
      next_state <=
        S_0 when not SA and not SB else
        S_1 when not SA and     SB else
        S_2 when     SA and     SB else
        S_3 when     SA and not SB else
        S_RESET; -- Should not happen.
    when S_0     => 
      next_state <=
        S_0     when not SA and not SB else
        S_1     when not SA and     SB else
        S_RESET when     SA and     SB else
        S_3     when     SA and not SB else
        S_RESET; -- Should not happen.
    when S_1     =>
      next_state <=
        S_0     when not SA and not SB else
        S_1     when not SA and     SB else
        S_2     when     SA and     SB else
        S_RESET when     SA and not SB else
        S_RESET; -- Should not happen.
    when S_2     =>
      next_state <=
        S_RESET when not SA and not SB else
        S_1     when not SA and     SB else
        S_2     when     SA and     SB else
        S_3     when     SA and not SB else
        S_RESET; -- Should not happen.
    when S_3     =>
      next_state <=
        S_0     when not SA and not SB else
        S_RESET when not SA and     SB else
        S_2     when     SA and     SB else
        S_3     when     SA and not SB else
        S_RESET; -- Should not happen.
  end case;
end process next_state_logic;

OUTPUT_LOGIC:
process(SA, SB, mclk) is
begin
  if not (next_state = current_state) then
    case current_state is
      when S_0 =>
        pos_inc <= '1' when not SA and     SB;
        pos_dec <= '1' when     SA and not SB;
        err     <= '1' when     SA and     SB;
      when S_1 =>
        pos_inc <= '1' when     SA and     SB;
        pos_dec <= '1' when not SA and not SB;
        err     <= '1' when     SA and not SB;
      when S_2 =>
        pos_inc <= '1' when     SA and not SB;
        pos_dec <= '1' when not SA and     SB;
        err     <= '1' when not SA and not SB;
      when S_3 =>
        pos_inc <= '1' when not SA and not SB;
        pos_dec <= '1' when     SA and     SB;
        err     <= '1' when not SA and     SB;
      when others => 
        pos_inc <= '0';
        pos_dec <= '0';
        err     <= '0';
    end case;
  elsif rising_edge(mclk) then
    pos_inc <= '0';
    pos_dec <= '0';
  end if;
end process output_logic;

end architecture implementation;
