library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity chameleon is
    port (addr : in unsigned(3 downto 0);

          note3 : out unsigned(3 downto 0);
          note2 : out unsigned(3 downto 0);
          note1 : out unsigned(3 downto 0);
          note0 : out unsigned(3 downto 0);

          octaves : out std_logic_vector(3 downto 0));
end chameleon;

architecture rtl of chameleon is
    type note_rom_type is array(12 downto 9, 3 downto 0)
            of unsigned(3 downto 0);
    type octave_rom_type is array(12 downto 9) 
            of std_logic_vector(3 downto 0);
    constant note_rom : note_rom_type := (
        (x"2", x"c", x"9", x"0"),
        (x"5", x"2", x"0", x"0"),
        (x"9", x"7", x"0", x"0"),
        (x"c", x"9", x"7", x"5")
    );

    constant octave_rom : octave_rom_type := (
        "0111", "0000", "1111", "1111"
    );
begin
    note3 <= note_rom(to_integer(addr), 3);
    note2 <= note_rom(to_integer(addr), 2);
    note1 <= note_rom(to_integer(addr), 1);
    note0 <= note_rom(to_integer(addr), 0);

    octaves <= octave_rom(to_integer(addr));
end rtl;
