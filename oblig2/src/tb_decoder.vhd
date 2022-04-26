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

  component SELECT_DECODER
    port (
      sw : in  std_logic_vector(1 downto 0);
      ld : out std_logic_vector(3 downto 0)
    );
  end component;

  signal tb_sw_case : std_logic_vector(1 downto 0) := "00";
  signal tb_ld_case : std_logic_vector(3 downto 0) := "0000";
  signal tb_sw_select : std_logic_vector(1 downto 0) := "00";
  signal tb_ld_select : std_logic_vector(3 downto 0) := "0000";

begin

  -- Connect the decoder implementations:
  U1: entity work.decoder(CASE_DECODER) port map(
    sw => tb_sw_case,
    ld => tb_ld_case
  );
  U2: entity work.decoder(SELECT_DECODER) port map(
    sw => tb_sw_select,
    ld => tb_ld_select
  );

  -- Test all valid `sw` data inputs:
  process begin
    tb_sw_case   <= "00";
    tb_sw_select <= "00";
    for i in 0 to 3 loop
      wait for 10 ns;
      -- Check `case` implementation:
      report "tb_sw_case   = " & to_string(tb_sw_case) & ", " &
             "tb_ld_case   = " & to_string(tb_ld_case);
      -- Check `select` implementation:
      report "tb_sw_select = " & to_string(tb_sw_select) & ", " &
             "tb_ld_select = " & to_string(tb_ld_select);
      -- Increment `sw` signals:
      tb_sw_case   <= std_logic_vector(unsigned(tb_sw_case) + 1);
      tb_sw_select <= std_logic_vector(unsigned(tb_sw_select) + 1);
    end loop;
    std.env.stop(0);
  end process;

end tb;
