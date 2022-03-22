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

  -- Reuse component from a) to convert binary input
  component bin2ssd is
    port(
      bin : in  std_logic_vector(3 downto 0);
      ssd : out std_logic_vector(6 downto 0)
    );
  end component bin2ssd;

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

CONVERTER: entity work.bin2ssd
  port map (
    bin => di,   
    ssd => abcdefg
  );    

end architecture;
