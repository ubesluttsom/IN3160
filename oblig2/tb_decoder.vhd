library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_decoder is
end tb_decoder;

architecture tb of tb_decoder is

  component CASE_DECODER
    port (
      sw : in  std_logic_vector(1 downto 0);
      ld : out std_logic_vector(3 downto 0)
    );
  end component;

  signal tb_sw : std_logic_vector(1 downto 0) := "00";
  signal tb_ld : std_logic_vector(3 downto 0) := "0000";

begin

  U1: entity work.decoder(CASE_DECODER) port map(
    sw => tb_sw,
    ld => tb_ld
  );

  process begin
    tb_sw <= "00";
    for i in 0 to 3 loop
      wait for 10 ns;
      report "tb_sw = " & to_string(tb_sw) & ", " &
             "tb_ld = " & to_string(tb_ld);
      tb_sw <= std_logic_vector(unsigned(tb_sw) + 1);
    end loop;
    std.env.stop(0);
  end process;

end tb;
