library ieee;
use ieee.std_logic_1164.all;

entity wm8731_tb is
end wm8731_tb;

architecture sim of wm8731_tb is
    signal clk : std_logic := '1';
    signal audio_request : std_logic;
    signal reset_n : std_logic;

    signal aud_adcdat : std_logic;
    signal aud_adclrck : std_logic;

    signal aud_dacdat : std_logic;
    signal aud_daclrck : std_logic;
    signal aud_bclk : std_logic;

    type rom_type is array(0 to 2) of std_logic_vector(15 downto 0);
    signal expected : rom_type := (x"0000", x"10b4", x"2120");
begin 
    WM8731 : entity work.de2_wm8731_audio port map (
        test_mode => '1',
        clk => clk,
        reset_n => reset_n,
        audio_request => audio_request,
        data => x"0000",

        aud_adcdat => aud_adcdat,
        aud_adclrck => aud_adclrck,
        aud_dacdat => aud_dacdat,
        aud_daclrck => aud_daclrck,
        aud_bclk => aud_bclk
    );

    clk <= not clk after 10 ns;

    process
        variable i : integer range -1 to 15;
        variable j : integer range 0 to 3;
        variable data : std_logic_vector(15 downto 0);
    begin
        reset_n <= '0';
        aud_adcdat <= '0';
        wait for 20 ns;
        reset_n <= '1';
        wait for 2560 ns;
        j := 0;
        while j < 3 loop
            i := 15;
            data := expected(j);
            while i > -1 loop
                wait for 160 ns;
                assert aud_dacdat = data(i);
                wait for 160 ns;
                i := i - 1;
            end loop;
            wait for 2560 ns;
            j := j + 1;
        end loop;
        wait;
    end process;
end sim;
