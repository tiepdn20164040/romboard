library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity priority_enc is
    port (unencoded : in std_logic_vector(3 downto 0);
          encoded   : out unsigned(1 downto 0);
          triggered : out std_logic);
end priority_enc;

architecture rtl of priority_enc is
begin
    encoded <= "11" when unencoded(3) = '1' else
               "10" when unencoded(2) = '1' else
               "01" when unencoded(1) = '1' else
               "00";
    triggered <= '0' when unencoded = "0000" else '1';
end rtl;
