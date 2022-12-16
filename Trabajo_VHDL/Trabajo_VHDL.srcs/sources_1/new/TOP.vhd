library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    GENERIC (WITDH : positive := 4; -- Tenemos 4 tipos diferentes de monedas
             DISPLAYS : positive := 8; -- Existen 8 displays en la placa
             SEGMENTOS : positive := 8 -- Cada display tiene 7 segmentos y el punto
    );
    PORT ( CLK : in std_logic; -- Señal de reloj
           RESET : in std_logic; -- Señal de reset
           MONEDA : in std_logic_vector(WITDH - 1 downto 0); -- Entradas de las monedas
           PRODUCTO : in std_logic_vector(WITDH - 1 downto 0); -- Entradas de productos
           LEDS : out std_logic_vector(WITDH downto 0); -- Leds que indican que se ha terminado de introducir la cantidad
           DISPLAYS_ENCENDIDOS : out std_logic_vector(DISPLAYS - 1 downto 0); -- Sirve para encender los displays
           SEGMENTOS_ENCENDIDOS : out std_logic_vector(SEGMENTOS - 1 downto 0) -- Sirve para encender los segmentos de los displays
    );
end top;

architecture Behavioral of top is
    -- VARIABLES NECESARIAS PARA EL SINCRONIZADOR
    COMPONENT SYNCHRNZR is
        generic (witdh : positive);
        port ( 
            clk : in std_logic;
            async_in : in std_logic_vector(witdh - 1 downto 0);
            sync_out : out std_logic_vector(witdh - 1 downto 0)
        );
    END COMPONENT;
    signal sincro_moneda : std_logic_vector(WITDH - 1 downto 0); -- salida del sincronizador
    
    -- VARIABLES NECESARIAS PARA EL GENERADOR DE PULSOS
    COMPONENT EDGEDTCTR is
        generic (witdh : positive);
        port ( 
            clk : in std_logic;
            sync_in : in std_logic_vector(witdh - 1 downto 0);
            edge : out std_logic_vector(witdh - 1 downto 0)
        );
    END COMPONENT;
    signal pulso_moneda : std_logic_vector(WITDH - 1 downto 0); -- salida del generador de pulsos

    -- VARIABLES NECESARIAS PARA LA MÁQUINA DE ESTADOS
    COMPONENT ESTADOS is
        generic (witdh : positive;
                 displays : positive;
                 segmentos : positive
        );
        port ( clk : in std_logic;
               reset : in std_logic;
               moneda : in std_logic_vector(witdh - 1 downto 0);
               producto : in std_logic_vector(witdh - 1 downto 0);
               leds : out std_logic_vector(witdh downto 0);
               displays_encendidos : out std_logic_vector(displays - 1 downto 0);
               segmentos_encendidos : out std_logic_vector(segmentos - 1 downto 0)
        );
    END COMPONENT;
begin
    -- INSTANCIAS DE LOS COMPONENTES NECESARIOS
    Inst_sincronizador : SYNCHRNZR
        generic map (WITDH)
        port map(
            clk => CLK,
            async_in => MONEDA,
            sync_out => sincro_moneda
    );
    Inst_generador_pulsos : EDGEDTCTR
        generic map (WITDH)
        port map(
            clk => CLK,
            sync_in => sincro_moneda,
            edge => pulso_moneda
    );
    Inst_maquina_estados : ESTADOS
        generic map (WITDH, DISPLAYS, SEGMENTOS)
        port map (
            clk => CLK,
            reset => RESET,
            moneda => pulso_moneda,
            producto => PRODUCTO,
            leds => LEDS,
            displays_encendidos => DISPLAYS_ENCENDIDOS,
            segmentos_encendidos => SEGMENTOS_ENCENDIDOS
    );
end Behavioral;