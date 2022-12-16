library ieee;
use ieee.std_logic_1164.ALL;

entity DECODER is
    GENERIC (DISPLAYS : positive; -- Numero total de displays que hay
             SEGMENTOS : positive -- Segmentos que tiene cada display
    );
    PORT (
        CLK : in std_logic;
        ESTADO_ACTUAL : in integer;
        DISPLAYS_ENCENDIDOS : out std_logic_vector(DISPLAYS - 1 downto 0);
        SEGMENTOS_ENCENDIDOS : out std_logic_vector(SEGMENTOS - 1 downto 0)
    );
end entity DECODER;

architecture dataflow of DECODER is
    signal reloj_auxiliar : std_logic := '0';
begin
    process(CLK)
        subtype ciclos is integer range 0 to 10**8;
        variable contaje : ciclos;
    begin
        if rising_edge(CLK) then
            contaje := contaje + 1;
            if contaje = 10**5 - 1 then
                contaje := 0;
                reloj_auxiliar <= not reloj_auxiliar;
            end if;
        end if;
    end process;
   
    process(reloj_auxiliar) -- DETERMINAMOS QUE DISPLAY QUEREMOS ENCENDER EN CADA MOMENTO
        variable display : integer := 0;
        variable euros, centimos_1, centimos_2 : std_logic_vector(SEGMENTOS - 1 downto 0);
    begin
        if rising_edge(reloj_auxiliar) then
            case ESTADO_ACTUAL is
                when 0 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10000001"; -- 0
                    centimos_2 := "10000001"; -- 0
                when 1 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "11001111"; -- 1
                    centimos_2 := "10000001"; -- 0
                when 2 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10010010"; -- 2
                    centimos_2 := "10000001"; -- 0
                when 3 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10000110"; -- 3
                    centimos_2 := "10000001"; -- 0
                when 4 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "11001100"; -- 4
                    centimos_2 := "10000001"; -- 0
                when 5 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10100100"; -- 5
                    centimos_2 := "10000001"; -- 0
                when 6 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10100000"; -- 6
                    centimos_2 := "10000001"; -- 0
                when 7 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10001111"; -- 7
                    centimos_2 := "10000001"; -- 0
                when 8 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10000000"; -- 8
                    centimos_2 := "10000001"; -- 0
                when 9 =>
                    euros :=      "00000001"; -- 0
                    centimos_1 := "10000100"; -- 9
                    centimos_2 := "10000001"; -- 0
                when 10 =>
                    euros :=      "01001111"; -- 1
                    centimos_1 := "10000001"; -- 0
                    centimos_2 := "10000001"; -- 0
                when others =>
                    euros :=      "11111110"; -- -
                    centimos_1 := "11111110"; -- -
                    centimos_2 := "11111110"; -- -
            end case;
            
            display := (display + 1) mod 3; -- modificamos el display que vamos a representar
            case display is
                when 0 =>
                    DISPLAYS_ENCENDIDOS <= "11111011";                                     
                    SEGMENTOS_ENCENDIDOS <= euros;
                when 1 =>
                    DISPLAYS_ENCENDIDOS <= "11111101";
                    SEGMENTOS_ENCENDIDOS <= centimos_1;
                when others =>
                    DISPLAYS_ENCENDIDOS <= "11111110";
                    SEGMENTOS_ENCENDIDOS <= centimos_2;
            end case;
        end if;
    end process;
end architecture dataflow;