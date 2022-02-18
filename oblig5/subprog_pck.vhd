library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package subprog_pck is
  function method1(indata: std_logic_vector) return std_logic;
  function method2(indata: unsigned) return std_logic;
  procedure count_unsigned(signal clk: in std_logic;
                           signal value: out unsigned);
end package subprog_pck;

package body subprog_pck is

  --Method 1: parity toggle, using for, loop and variables.   
  function method1(indata: std_logic_vector) return std_logic is
    variable toggle: std_logic;
  begin
    toggle := '0';
    for i in indata'range loop
      if indata(i) = '1' then
        toggle := not toggle;
      end if;        
    end loop;
    return toggle;
  end method1;

  -- Method 2: parity using xor function (VHDL 2008)
  function method2(indata: unsigned) return std_logic is
  begin
    return xor(indata);  -- Cascaded XORs 
  end method2;

  -- Set a signal to a new unsigned between `x"0000"` to `x"00FF"` every clock
  -- cycle. NOTE: the assignment text wasn't all that clear to me, I'm
  -- interpreting it as a counter, counting up on every rising edge.
  procedure count_unsigned(signal clk: in std_logic;
                           signal value: out unsigned) is
  begin
    for i in 16#0000# to 16#00FF# loop
      wait until rising_edge(clk);
      value <= to_unsigned(i, value'length);
    end loop;
  end count_unsigned;

end package body subprog_pck;
