
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
  signal en1, en2   : std_logic;
  signal dir1, dir2 : std_logic;
begin  
  process (reset, mclk) is    
  begin
    if reset then       
      en1  <= '0';
      en2  <= '0';
      dir1 <= '0';
      dir2 <= '0';
    elsif rising_edge(mclk) then
      en1  <= en;
      en2  <= en1;
      dir1 <= dir;
      dir2 <= dir1;
    end if;
  end process;
  en_synch  <= en2;
  dir_synch <= dir2;
end implementation;
