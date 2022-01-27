library IEEE;
use IEEE.std_logic_1164.all;

entity DECODER is
  port
  (
      sw : in  std_logic_vector(1 downto 0);
      ld : out std_logic_vector(3 downto 0)
  );
end DECODER;
