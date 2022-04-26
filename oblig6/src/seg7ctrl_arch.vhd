library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

entity seg7ctrl is
  port (
    mclk    : in  std_logic; -- 100MHz, positive flank
    reset   : in  std_logic; -- Asynchronous reset, active high
    d0      : in  std_logic_vector(3 downto 0);
    d1      : in  std_logic_vector(3 downto 0);
    abcdefg : out std_logic_vector(6 downto 0);
    c       : out std_logic := '0'
  );
end entity seg7ctrl;

architecture seg7ctrl_arch of seg7ctrl is

-------------------------------------
-- COMPONENT & SIGNAL DECLERATIONS --
-------------------------------------

  signal counter   : unsigned(19 downto 0) := (others => '0');
  signal di        : std_logic_vector(3 downto 0) := (others => '0');

----------------------
BEGIN -- STATEMENTS --
----------------------

-- CLOCKED LOGIC

process (reset, mclk)
begin
  -- Asynchronous reset
  if (reset = '1') then
    counter <= (others => '0');
  elsif rising_edge(mclk) then
    counter <= counter + 1;
    if counter = 0 then
      c <= not c;
    end if;
  end if;
end process;

-- CONCURRENT LOGIC

with c select 
  di <= d0 when '0',
        d1 when '1',
        "0000" when others;

with di select
  abcdefg <= "0000000" when "0000",
             "0011110" when "0001",
             "0111100" when "0010",
             "1001111" when "0011",
             "0001110" when "0100",
             "0111101" when "0101",
             "0011101" when "0110",
             "0010101" when "0111",
             "0111011" when "1000",
             "0111110" when "1001",
             "1110111" when "1010",
             "0000101" when "1011",
             "1111011" when "1100",
             "0011100" when "1101",
             "0001101" when "1110",
             "1111111" when "1111",
             "0000000" when others;

end architecture seg7ctrl_arch;
