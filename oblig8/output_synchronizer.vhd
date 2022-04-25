
library ieee;
  use ieee.std_logic_1164.all;

entity output_synchronizer is 
  port (
    reset     : in  std_logic;
    mclk      : in  std_logic;
    en        : in  std_logic;
    dir       : in  std_logic;
    en_synch  : out std_logic;
    dir_synch : out std_logic
  );  
end output_synchronizer;

architecture implementation of output_synchronizer is 
  signal en_flipflop  : std_logic;
  signal dir_flipflop : std_logic;
begin  
  process (reset, mclk) is    
  begin
    if reset then       
      en_flipflop  <= '0';
      dir_flipflop <= '0';
    elsif rising_edge(mclk) then
      en_flipflop  <= en;
      dir_flipflop <= dir;
    end if;
  end process;
  en_synch  <= en_flipflop;
  dir_synch <= dir_flipflop;
end implementation;
