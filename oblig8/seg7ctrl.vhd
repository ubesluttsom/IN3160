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

architecture seg7ctrl of seg7ctrl is

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
  abcdefg <= "1111110" when X"0",
             "0110000" when X"1",
             "1101101" when X"2",
             "1111001" when X"3",
             "0110011" when X"4",
             "1011011" when X"5",
             "1011111" when X"6",
             "1110000" when X"7",
             "1111111" when X"8",
             "1110011" when X"9",
             "1110111" when X"A",
             "0011111" when X"B",
             "1001110" when X"C",
             "0111101" when X"D",
             "1001111" when X"E",
             "1000111" when X"F",
             "XXXXXXX" when others;

end architecture;
