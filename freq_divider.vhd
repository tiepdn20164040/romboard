library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- clk              : clock in
-- divider          : factor by which to divide the 50MHz clock
-- clk_out          : the divided clock
--
-- Example: inserting 0 or 1 as divider_count is undefined
-- Inserting any other value divides the frequency by twice that value
entity freq_divider is
    port (clk     : in std_logic;
          divider : in unsigned(19 downto 0);
          clk_out : out std_logic);
end freq_divider;

architecture rtl of freq_divider is
    signal divider_old  : unsigned(19 downto 0) := (others => '0');
    signal count        : unsigned(19 downto 0) := x"00001";
    signal clk_intern : std_logic := '0';
begin
    clk_out <= clk_intern;

    process(clk)
    begin
        if rising_edge(clk) then
            -- if divider value changes, reset count
            if divider /= divider_old then
                count <= x"00001";
            -- if count reached, clock high and reset
            elsif count = divider then
                count <= x"00001";
                clk_intern <= not clk_intern;
            -- otherwise, just increment count
            else
                count <= count + 1;
            end if;

            divider_old <= divider;
        end if;
    end process;
end rtl;
