library IEEE;
  use IEEE.std_logic_1164.all;

package bin2ssd is
  function bin2ssd(bin: std_logic_vector) return std_logic_vector;
end package bin2ssd;

package body bin2ssd is

  function bin2ssd(bin: std_logic_vector) return std_logic_vector is
    variable ssd: std_logic_vector(6 downto 0);
  begin
    with bin select ssd(6 downto 0) :=
      "1111110" when X"0",
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
    return ssd;
  end bin2ssd;

end package body bin2ssd;
