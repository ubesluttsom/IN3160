library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

architecture rtl of compute_pipelined is
  -- Initialize intermediary signals. I.e first block of registers.
  signal addresult_i  : unsigned(17 downto 0);
  signal e_i          : unsigned(15 downto 0);
  signal dvalid_i     : std_logic;
begin
 
  process (rst, clk) is
    -- `multresult_i` is still a variable, since it's not stored in a
    -- register, just immediately passed along next logic block. But
    -- `addresult_i` is now a signal.
    variable multresult_i : unsigned(33 downto 0);
  begin
    if rst = '1' then
      result <= (others => '0');
      max    <= '0';
      rvalid <= '0';
      addresult_i  <= (others => '0'); -- New reset targets here.
      e_i          <= (others => '0'); -- XXX
      dvalid_i     <= '0';             -- XXX
    elsif rising_edge(clk) then
      if (dvalid = '1') then -- Check `dvalid` for addr. logic
        addresult_i  <= (unsigned("00" & a) + unsigned("00" & b)) +
                        (unsigned("00" & c) + unsigned("00" & d));
        e_i      <= unsigned(e); -- Propagate next `e`
      end if;
      if (dvalid_i = '1') then -- Check `dvalid_i` for mult. logic
        multresult_i := addresult_i * e_i; -- Use propagated `e`
        if (multresult_i(33 downto 32) = "00") then
          result <= std_logic_vector(multresult_i(31 downto 0));
          max    <= '0';
        else
          result <= (others => '1');
          max    <= '1';
        end if;
      else
        result <= (others => '0');
        max    <= '0';
      end if;
      dvalid_i <= dvalid;   -- Propagate `dvalid`
      rvalid   <= dvalid_i; -- Propagate `dvalid_i`
    end if;
  end process;

end architecture rtl;
