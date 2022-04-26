library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift32 is
  port (
    rst_n : in std_logic;
    mclk  : in std_logic;
    din   : in std_logic;
    dout  : out std_logic_vector(31 downto 0);
    dout_serial : out std_logic
  );
end shift32;

architecture shift32_dff of shift32 is
  component dff is 
    port ( 
      rst_n     : in  std_logic;
      mclk      : in  std_logic;
      din       : in  std_logic;
      dout      : out std_logic
    );      
  end component;
begin
  DFF_INSTANCES: for i in 30 to 0 generate
    DFF_INSTANCE: dff port map (
      rst_n => rst_n,
      mclk  => mclk,
      din   => dout(i+1),
      dout  => dout(i)
    );
  end generate;
  DFF_FIRST: dff port map (
      rst_n => rst_n,
      mclk  => mclk,
      din   => din,
      dout  => dout(31)
  );

  SHIFT: process(all)
  begin 
    if rst_n = '0' then
      dout <= (others => '0');
    elsif rising_edge(mclk) then
      dout(30 downto 0) <= dout(31 downto 1);
      dout(31) <= din;
    end if;
  end process SHIFT;

  -- Is this what the assignment meant with both parallel and serial output?
  -- I'm a bit unsure. Seems superfluous.
  dout_serial <= dout(0);

end shift32_dff;
