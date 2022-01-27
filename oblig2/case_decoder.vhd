library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

architecture CASE_DECODER of DECODER is

  -- component CASE_DECODER
  --   port (
  --     sw : in  std_logic_vector(1 downto 0);
  --     ld : out std_logic_vector(3 downto 0)
  --   );
  -- end component;
 
begin
  
  DECODE :
  process(all)
  begin
    case sw is
      when "00" => ld <= "1110";
      when "01" => ld <= "1101";
      when "10" => ld <= "1011";
      when "11" => ld <= "0111";
      when others => ld <= "0000";
    end case;
  end process DECODE;

end CASE_DECODER;
