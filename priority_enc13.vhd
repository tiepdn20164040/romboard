library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priority_enc13 is
    port (unencoded : in std_logic_vector(12 downto 0);
          encoded   : out unsigned(3 downto 0));
end priority_enc13;

architecture rtl of priority_enc13 is
begin
    encoded <= x"c" when unencoded(12) = '1' else
               x"b" when unencoded(11) = '1' else
               x"a" when unencoded(10) = '1' else
               x"9" when unencoded(9) = '1' else
               x"8" when unencoded(8)  = '1' else
               x"7" when unencoded(7)  = '1' else
               x"6" when unencoded(6)  = '1' else
               x"5" when unencoded(5)  = '1' else
               x"4" when unencoded(4)  = '1' else
               x"3" when unencoded(3)  = '1' else
               x"2" when unencoded(2)  = '1' else
               x"1" when unencoded(1)  = '1' else
               x"0";
end rtl;
