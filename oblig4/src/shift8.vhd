library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift8 is
  port (
    rst_n : in std_logic;
    mclk  : in std_logic;
    din   : in std_logic;
    dout  : out std_logic_vector(7 downto 0);
    dout_serial : out std_logic
  );
end shift8;

architecture shift8_dff of shift8 is
  component dff is 
    port ( 
      rst_n     : in  std_logic;
      mclk      : in  std_logic;
      din       : in  std_logic;
      dout      : out std_logic
    );      
  end component;
begin

  D7: dff port map(rst_n => rst_n, mclk => mclk, din => din,     dout => dout(7));
  D6: dff port map(rst_n => rst_n, mclk => mclk, din => dout(7), dout => dout(6));
  D5: dff port map(rst_n => rst_n, mclk => mclk, din => dout(6), dout => dout(5));
  D4: dff port map(rst_n => rst_n, mclk => mclk, din => dout(5), dout => dout(4));
  D3: dff port map(rst_n => rst_n, mclk => mclk, din => dout(4), dout => dout(3));
  D2: dff port map(rst_n => rst_n, mclk => mclk, din => dout(3), dout => dout(2));
  D1: dff port map(rst_n => rst_n, mclk => mclk, din => dout(2), dout => dout(1));
  D0: dff port map(rst_n => rst_n, mclk => mclk, din => dout(1), dout => dout(0));

  SHIFT: process(all)
  begin 
    if rst_n = '0' then
      dout <= x"00";
    elsif rising_edge(mclk) then
      dout(6 downto 0) <= dout(7 downto 1);
      dout(7) <= din;
    end if;
  end process SHIFT;

  -- Is this what the assignment meant with both parallel and serial output?
  -- I'm a bit unsure. (A *bit* unsure, geddit? ... Sorry.) Seems superfluous.
  dout_serial <= dout(0);

end shift8_dff;
