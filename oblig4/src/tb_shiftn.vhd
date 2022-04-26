library ieee;
use ieee.std_logic_1164.all;

entity tb_shiftn is
end tb_shiftn;

architecture tb of tb_shiftn is
  component shiftn is
    generic (BITS: integer);
    port (
      rst_n : in std_logic;
      mclk  : in std_logic;
      din   : in std_logic;
      dout  : out std_logic_vector(BITS-1 downto 0)
    );
  end component;

  signal tb_rst_n : std_logic := '1';
  signal tb_mclk  : std_logic := '0';
  signal tb_din   : std_logic := '0';
  signal tb_dout  : std_logic_vector(63 downto 0) := (others => '0');

  -- 50 MHz clock frequency
  constant HALF_PERIOD : time := 10 ns;
  constant PERIOD      : time := 20 ns;

begin

  UUT: entity work.shiftn(shiftn_dff) 
  generic map (
    BITS => 64
  )
  port map(
    rst_n => tb_rst_n,
    mclk  => tb_mclk,
    din   => tb_din,
    dout  => tb_dout
  );

  -- Generate clock signal
  tb_mclk <= not tb_mclk after HALF_PERIOD;
  
  process
  begin

    report "--- TESTING `shiftn` WITH 64 BITS ---";

    report "--- `din` IS `1` ---";
    tb_din <= '1';
    for i in 0 to 12 loop
      wait for PERIOD;
      report "tb_dout = " & to_string(tb_dout);
    end loop;

    report "--- CHANGING `din` TO `0` ---";
    tb_din <= '0';
    for i in 0 to 4 loop
      wait for PERIOD;
      report "tb_dout = " & to_string(tb_dout);
    end loop;

    report "--- CHANGING `din` TO `1` ---";
    tb_din <= '1';
    for i in 0 to 4 loop
      wait for PERIOD;
      report "tb_dout = " & to_string(tb_dout);
    end loop;

    report "--- CHANGING `rst_n` TO `0` ---";
    tb_rst_n <= '0';
    wait for 3*PERIOD;
    report "tb_dout = " & to_string(tb_dout);

    std.env.stop(0);
  end process;
end tb;
