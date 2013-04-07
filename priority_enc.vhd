library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- an inverted priority encoder
-- 0XXX gives 11
-- 00XX gives 10
-- 000X gives 01
-- anything else gives 00
-- triggered is high if at least one of the inputs is low

entity priority_enc is
    port (unencoded : in std_logic_vector(3 downto 0);
          encoded   : out unsigned(1 downto 0);
          triggered : out std_logic);
end priority_enc;

architecture rtl of priority_enc is
begin
    encoded <= "11" when unencoded(3) = '0' else
               "10" when unencoded(2) = '0' else
               "01" when unencoded(1) = '0' else
               "00";
    triggered <= '0' when unencoded = "1111" else '1';
end rtl;
