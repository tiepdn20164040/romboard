library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rshift is
    port (number : in unsigned(19 downto 0);
          shiftby : in unsigned(5 downto 0);
          shifted : out unsigned(19 downto 0));
end rshift;

architecture rtl of rshift is
    type rss_type is array(0 to 19) of unsigned(19 downto 0);
    signal rss : rss_type;
begin
    rss(0) <= number;
    
    SEL_MUX0 : entity work.multiplexer port map (
        input => rss(0),
        sel => shiftby,
        output => shifted(0)
    );
    
    GEN_MUX : for i in 1 to 19 generate
        rss(i) <= ((i-1) downto 0 => '0') & number(19 downto i);
        SEL_MUX : entity work.multiplexer port map (
                        input => rss(i),
                        sel => shiftby,
                        output => shifted(i));
    end generate GEN_MUX;
end rtl;
