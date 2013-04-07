library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity note_decoder is
    port (clk : in std_logic;
          note_switches : in std_logic_vector(12 downto 0);
          octave : in unsigned(1 downto 0);

          hex0 : out std_logic_vector(6 downto 0);
          hex1 : out std_logic_vector(6 downto 0);
          hex2 : out std_logic_vector(6 downto 0);
          hex3 : out std_logic_vector(6 downto 0);
          
          note0 : out unsigned(19 downto 0);
          note1 : out unsigned(19 downto 0);
          note2 : out unsigned(19 downto 0);
          note3 : out unsigned(19 downto 0));
end note_decoder;


architecture rtl of note_decoder is
    signal sweep_index : unsigned(3 downto 0) := x"c";
    signal note_index : signed(2 downto 0) := "011";
    signal cur_switch : std_logic;
    type divider_mapping_type is array(0 to 3) of unsigned(19 downto 0);
    signal divider_mapping : divider_mapping_type;
    type index_mapping_type is array(0 to 3) of unsigned(3 downto 0);
    signal index_mapping : index_mapping_type;
    type hex_bank_type is array(0 to 3) of std_logic_vector(6 downto 0);
    signal hex_bank : hex_bank_type;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            note0 <= divider_mapping(0);
            note1 <= divider_mapping(1);
            note2 <= divider_mapping(2);
            note3 <= divider_mapping(3);
        end if;
    end process;

    hex0 <= hex_bank(0);
    hex1 <= hex_bank(1);
    hex2 <= hex_bank(2);
    hex3 <= hex_bank(3);

    cur_switch <= note_switches(to_integer(sweep_index));

    process (clk)
    begin
        if rising_edge(clk) then
            if sweep_index = x"0" then
                note_index <= "011";
                sweep_index  <= x"c";
            else
                sweep_index <= sweep_index - x"1";
            end if;
            
            if cur_switch = '1' and note_index(2) = '0' then
                index_mapping(to_integer(note_index)) <= sweep_index;
                note_index <= note_index - "001";
            end if;
        end if;
    end process;

    GEN_MAPPINGS : for i in 0 to 3 generate
        DIV_TAB : entity work.divider_table port map (
            index => index_mapping(i),
            octave => octave,
            divider => divider_mapping(i)
        );

        SSD : entity work.sevenseg port map (
            number => index_mapping(i),
            display => hex_bank(i)
        );
    end generate GEN_MAPPINGS;
end rtl;
