--------------------------------------------------
-- Code shamelessly stolen from lecture slides! --
--------------------------------------------------

library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use STD.textio.all;

entity ROM is
  generic(
    data_lines: natural := 20;
    data_width: natural := 8;
    addr_width: natural := 2;
    filename:   string  := "rom_data.txt"
  );
  port(
  address: in std_logic_vector(addr_width-1 downto 0);
  data:   out std_logic_vector(data_width-1 downto 0));
end entity ROM;

architecture implementation of ROM is

-------------------
--  DECLARATIONS --
-------------------

  type memory_array is array(data_lines-1 downto 0) of
    std_logic_vector(data_width-1 downto 0);

  impure function initialize_ROM(file_name: string)
    return memory_array is
    file  init_file: text open read_mode is file_name;
    variable current_line: line;
    variable result: memory_array;
  begin
    for i in result'range loop
      readline(init_file, current_line);
      read(current_line, result(i));
    end loop;
    return result;
  end function;

  -- Initializing ROM:
  constant ROM_DATA: memory_array := initialize_ROM(filename);

----------------------
BEGIN -- STATEMENTS --
----------------------

  -- Set `data` to zero when address is out of bounds.
  data <= ROM_DATA(to_integer(unsigned(address)))
          when (unsigned(address) < data_lines)
          else (others => '0');

end implementation;
