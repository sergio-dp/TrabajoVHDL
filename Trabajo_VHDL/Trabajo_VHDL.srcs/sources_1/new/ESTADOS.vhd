library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ESTADOS is
    GENERIC (WITDH : positive; -- Numero total de tipos de monedas/productos
             DISPLAYS : positive; -- Numero total de displays que hay
             SEGMENTOS : positive -- Segmentos que tiene cada display
    );
    PORT ( CLK : in std_logic; -- Señal de reloj
           RESET : in std_logic; -- Señal de reset
           MONEDA : in std_logic_vector(WITDH - 1 downto 0); -- Entradas de las monedas
           PRODUCTO : in std_logic_vector(WITDH - 1 downto 0); -- Entradas de productos
           LEDS : out std_logic_vector(WITDH downto 0); -- Leds que indican que se ha terminado de introducir la cantidad
           DISPLAYS_ENCENDIDOS : out std_logic_vector(DISPLAYS - 1 downto 0); -- Displays a encender en cada momento
           SEGMENTOS_ENCENDIDOS : out std_logic_vector(SEGMENTOS - 1 downto 0) -- Segmentos a encender en cada momento
    );
end ESTADOS;

architecture Behavioral of ESTADOS is
    -- VARIABLES NECESARIAS PARA EL TEMPORIZADOR
    COMPONENT TEMPORIZADOR is
        port ( 
            clk : in std_logic;
            enable : in integer;
            tiempo : in integer;
            fin : out std_logic
        );
    END COMPONENT;
    signal enable : integer := 0; -- Sirve para saber en que estado me encuentro
    constant tiempo_tempo : integer := 3; -- Tiempo que permanece encendido el LED
    signal fin_temporizacion : std_logic := '0';
    
    -- VARIABLES NECESARIAS PARA EL DISPLAY DE 7 SEGMENTOS
    COMPONENT DECODER is
        generic (displays : positive; -- Numero total de displays que hay
                 segmentos : positive -- Segmentos que tiene cada display
        );
        port (
            clk : in std_logic;
            estado_actual : IN integer;
            displays_encendidos : out std_logic_vector(DISPLAYS - 1 downto 0);
            segmentos_encendidos : out std_logic_vector(SEGMENTOS - 1 downto 0)
        );
    END COMPONENT;
    
    -- VARIABLES NECESARIAS PARA LA MÁQUINA DE ESTADOS
    type state is( S0, S10, S20, S30, S40, S50, S60, S70, S80, S90, S100, S_mas);
    signal estado_actual, siguiente_estado : state := S0;
begin
    Inst_temporizador : TEMPORIZADOR
        port map(
            clk => CLK,
            enable => enable,
            tiempo => tiempo_tempo,
            fin => fin_temporizacion
    );
    Inst_decoder : DECODER
        generic map (DISPLAYS,SEGMENTOS)
        port map(
            clk => CLK,
            estado_actual => enable,
            displays_encendidos => DISPLAYS_ENCENDIDOS,
            segmentos_encendidos => SEGMENTOS_ENCENDIDOS
    );

    -- PROCESO PARA REGISTRO DE ESTADOS
    process(RESET,CLK)
    begin
        if rising_edge(clk) then
            if RESET = '0' then
                estado_actual <= S0;
            else
                estado_actual <= siguiente_estado;
                case estado_actual is
                    when S0 => enable <= 0;
                    when S10 => enable <= 1;
                    when S20 => enable <= 2;
                    when S30 => enable <= 3;
                    when S40 => enable <= 4;
                    when S50 => enable <= 5;
                    when S60 => enable <= 6;
                    when S70 => enable <= 7;
                    when S80 => enable <= 8;
                    when S90 => enable <= 9;
                    when S100 => enable <= 10;
                    when others => enable <= 11;
                end case;
            end if;
        end if;
    end process;
    
    -- PROCESO PARA CAMBIOS DE ESTADOS
    cambios_estado : process(MONEDA, estado_actual, fin_temporizacion)
    begin
        siguiente_estado <= estado_actual;
        if PRODUCTO /= "0000" then -- solo podemos cambiar de estado si hemos elegido producto
            case estado_actual is
                when S0 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S10;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S20;
                    elsif MONEDA(2) = '1' then
                        siguiente_estado <= S50;
                    elsif MONEDA(3) = '1' then
                        siguiente_estado <= S100;
                    end if;
                when S10 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S20;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S30;
                    elsif MONEDA(2) = '1' then
                        siguiente_estado <= S60;
                    elsif MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S20 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S30;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S40;
                    elsif MONEDA(2) = '1' then
                        siguiente_estado <= S70;
                    elsif MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S30 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S40;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S50;
                    elsif MONEDA(2) = '1' then
                        siguiente_estado <= S80;
                    elsif MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S40 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S50;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S60;
                    elsif MONEDA(2) = '1' then
                        siguiente_estado <= S90;
                    elsif MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S50 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S60;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S70;
                    elsif MONEDA(2) = '1' then
                        siguiente_estado <= S100;
                    elsif MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S60 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S70;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S80;
                    elsif MONEDA(2) = '1' or MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S70 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S80;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S90;
                    elsif MONEDA(2) = '1' or MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S80 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S90;
                    elsif MONEDA(1) = '1' then
                        siguiente_estado <= S100;
                    elsif MONEDA(2) = '1' or MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S90 =>
                    if MONEDA(0) = '1' then
                        siguiente_estado <= S100;
                    elsif MONEDA(1) = '1' or MONEDA(2) = '1' or MONEDA(3) = '1' then
                        siguiente_estado <= S_mas;
                    end if;
                when S100 =>
                    if fin_temporizacion = '1' then
                        siguiente_estado <= S0;
                    end if;
                when others =>
                    if fin_temporizacion = '1' then
                        siguiente_estado <= S0;
                    end if;
            end case;
        end if;
    end process;
    
    -- PROCESO PARA SALIDAS EN FUNCION DEL ESTADO
    salidas : process(estado_actual)
    begin
        case estado_actual is
            when S100 =>
                if PRODUCTO = "0001" then
                    LEDS <= "00001";
                elsif PRODUCTO = "0010" then
                    LEDS <= "00010";
                elsif PRODUCTO = "0100" then
                    LEDS <= "00100";
                elsif PRODUCTO = "1000" then
                    LEDS <= "01000";
                end if;
            when S_mas =>
                LEDS <= "10000";
            when others =>
                LEDS <= (others => '0');
        end case;
    end process;
end Behavioral;