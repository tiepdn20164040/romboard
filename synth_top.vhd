library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity synth_top is
    port (clk : in std_logic;
          volume : in std_logic_vector(14 downto 0);
          aud_data : out std_logic_vector(15 downto 0);
          hex0 : out std_logic_vector(6 downto 0);
          hex1 : out std_logic_vector(6 downto 0);
          hex2 : out std_logic_vector(6 downto 0);
          hex3 : out std_logic_vector(6 downto 0);
          note_switches : in std_logic_vector(12 downto 0);
          octave : in unsigned(1 downto 0);
          push_buttons : in std_logic_vector(3 downto 0));
end synth_top;

architecture rtl of synth_top is
    type note_reg_type is array(0 to 3) of unsigned(19 downto 0);
    signal note_reg : note_reg_type;
    signal key : unsigned(1 downto 0);
    signal pressed : std_logic;
    signal clkbank : std_logic_vector(3 downto 0);
    signal divclk : std_logic;
    signal highlvl : std_logic_vector(15 downto 0);
    signal lowlvl : std_logic_vector(15 downto 0);
begin
    PE : entity work.priority_enc4 port map (
        unencoded => push_buttons,
        encoded => key,
        triggered => pressed
    );

    DECODE : entity work.note_decoder port map (
        clk => clk,
        note_switches => note_switches,
        octave => octave,
        
        note0 => note_reg(0),
        note1 => note_reg(1),
        note2 => note_reg(2),
        note3 => note_reg(3),

        hex0 => hex0,
        hex1 => hex1,
        hex2 => hex2,
        hex3 => hex3
    );

    BANK_GEN : for i in 0 to 3 generate
        FREQ_DIV : entity work.freq_divider port map (
            clk => clk,
            divider => note_reg(i),
            clk_out => clkbank(i)
        );
    end generate BANK_GEN;

    divclk <= clkbank(to_integer(key));
    highlvl <= '0' & volume;
    lowlvl <= '1' & (not volume);

    aud_data <= x"0000" when pressed = '0' else
                highlvl when divclk = '1' else
                lowlvl  when divclk = '0';
end rtl;
