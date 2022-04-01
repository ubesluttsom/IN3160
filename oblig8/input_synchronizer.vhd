
library ieee;
  use ieee.std_logic_1164.all;

entity input_synchronizer is 
  port (
    reset    : in  std_logic;
    mclk     : in  std_logic;
    SA       : in  std_logic;
    SB       : in  std_logic;
    SA_synch : out std_logic;
    SB_synch : out std_logic;
  );  
end input_synchronizer;

architecture implementation of input_synchronizer is 
  signal SA1, SA2 : std_logic;
  signal SB1, SB2 : std_logic;
begin  
  process (reset, mclk) is    
  begin
    if reset then       
      SA1 <= (others => '0');
      SA2 <= (others => '0');
      SB1 <= (others => '0');
      SB2 <= (others => '0');
    elsif rising_edge(mclk) then
      SA1 <= SA;
      SA2 <= SA1;
      SB1 <= SB;
      SB2 <= SB1;
    end if;
  end process;
  SA_synch <= SA2;
  SB_synch <= SB2;
end implementation;
