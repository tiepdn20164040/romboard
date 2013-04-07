library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity note_decoder_tb is
end note_decoder_tb;

architecture sim of note_decoder_tb is
    signal clk : std_logic := '1';
    signal note_switches : std_logic_vector(12 downto 0);
    signal octave : unsigned(1 downto 0);

    signal hex0 : std_logic_vector(6 downto 0);
    signal hex1 : std_logic_vector(6 downto 0);
    signal hex2 : std_logic_vector(6 downto 0);
    signal hex3 : std_logic_vector(6 downto 0);

    signal note0 : unsigned(19 downto 0);
    signal note1 : unsigned(19 downto 0);
    signal note2 : unsigned(19 downto 0);
    signal note3 : unsigned(19 downto 0);
begin
    ND : entity work.note_decoder port map (
        clk => clk,
        note_switches => note_switches,
        octave => octave,

        hex0 => hex0,
        hex1 => hex1,
        hex2 => hex2,
        hex3 => hex3,

        note0 => note0,
        note1 => note1,
        note2 => note2,
        note3 => note3
    );

    clk <= not clk after 10 ns;

    process
    begin
        note_switches <= "1000100100001";
        octave <= "00";

        wait for 260 ns;

        assert note3 = x"5d4fc";
        assert note2 = x"4a101";
        assert note1 = x"3e47e";
        assert note0 = x"2ea8c";
    end process;
end sim;
