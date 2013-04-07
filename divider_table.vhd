library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity divider_table is
    port (index : in unsigned(3 downto 0);
          octave : in unsigned(1 downto 0);
          divider : out unsigned(19 downto 0));
end divider_table;


architecture rtl of divider_table is
    type lut_type is array(12 downto 0) of unsigned(19 downto 0);
    constant divider_lut : lut_type := (
        x"5d4fc", x"5812e", x"5321a", x"4e78b", x"4a101", x"45e80", 
        x"41fbe", x"3e47e", x"3ac8a", x"377c8", x"345f6", x"316ee", x"2ea8c"
    );
    signal raw_divider : unsigned(19 downto 0);
begin
    raw_divider <= divider_lut(to_integer(index));
    
    RS : entity work.rshift port map (
        number => raw_divider,
        shiftby => "0000" & octave,
        shifted => divider
    );
end rtl;
