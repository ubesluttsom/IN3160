library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
library work;
 use work.bin2ssd.all;

entity tb_bin2ssd is
end tb_bin2ssd;

architecture tb of tb_bin2ssd is

-------------------------------------
-- COMPONENT & SIGNAL DECLERATIONS --
-------------------------------------

  component seg7model is 
    port(
      c         : in  std_logic;
      abcdefg   : in  std_logic_vector(6 downto 0);
      disp1     : out std_logic_vector(3 downto 0);
      disp0     : out std_logic_vector(3 downto 0)
    );
  end component seg7model;

  signal tb_bin     : std_logic_vector(3 downto 0);

  signal tb_c       : std_logic;
  signal tb_abcdefg : std_logic_vector(6 downto 0);
  signal tb_disp1   : std_logic_vector(3 downto 0);
  signal tb_disp0   : std_logic_vector(3 downto 0);
  
----------------------
BEGIN -- STATEMENTS --
----------------------

S7M: entity work.seg7model
  port map (
    c       => tb_c,
    abcdefg => tb_abcdefg,
    disp1   => tb_disp1,
    disp0   => tb_disp0
  );


tb_abcdefg <= bin2ssd(tb_bin);

process begin

  -- Test both displays
  for i in std_logic range '0' to '1' loop
    tb_c <= i;
    -- Test entire range 0–F
    for j in 0 to 15 loop
      tb_bin <= std_logic_vector(to_unsigned(j, tb_bin'length));
      wait for 10 ns;
    end loop;
  end loop;

  wait for 10 ns;
  std.env.stop(0);

end process;

end architecture tb;
