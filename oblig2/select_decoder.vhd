library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture SELECT_DECODER of DECODER is
begin
  
  with sw select
    ld <= "1110" when "00",
          "1101" when "01",
          "1011" when "10",
          "0111" when "11",
          "0000" when others;

end SELECT_DECODER;
