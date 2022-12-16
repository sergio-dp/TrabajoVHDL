library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top is
end tb_top;

architecture Behavioral of tb_top is
    -- VARIABLES NECESARIAS PARA EL DISPLAY DE 7 SEGMENTOS
    COMPONENT TOP is
        GENERIC (WITDH : positive := 4; -- Tenemos 4 tipos diferentes de monedas
             DISPLAYS : positive := 8; -- Vamos a encender 3 displays
             SEGMENTOS : positive := 8 -- Cada display tiene 7 segmentos
        );
        PORT ( CLK : in std_logic; -- Señal de reloj
               RESET : in std_logic; -- Señal de reset
               MONEDA : in std_logic_vector(WITDH - 1 downto 0); -- Entradas de las monedas
               PRODUCTO : in std_logic_vector(WITDH - 1 downto 0); -- Entradas de productos
               LEDS : out std_logic_vector(WITDH downto 0); -- Leds que indican que se ha terminado de introducir la cantidad
               DISPLAYS_ENCENDIDOS : out std_logic_vector(DISPLAYS - 1 downto 0); -- Sirve para encender los displays
               SEGMENTOS_ENCENDIDOS : out std_logic_vector(SEGMENTOS - 1 downto 0) -- Sirve para encender los segmentos de los displays
        );
    END COMPONENT;
    constant WITDH : positive := 4;
    constant DISPLAYS : positive := 8;
    constant SEGMENTOS : positive := 8;
    signal clk,reset : std_logic;
    signal moneda,producto : std_logic_vector(WITDH - 1 downto 0);
    signal leds : std_logic_vector(WITDH downto 0);
    signal displays_encendidos : std_logic_vector(DISPLAYS - 1 downto 0);
    signal segmentos_encendidos : std_logic_vector(SEGMENTOS - 1 downto 0);
begin
    process
    begin
        clk <= '0';
        wait for 25 ns;
        clk <= '1';
        wait for 25 ns;
    end process;
    
    Inst_maquina_refrescos : TOP
        generic map (WITDH,DISPLAYS,SEGMENTOS)
        port map(
            CLK => clk,
            RESET => reset,
            MONEDA => moneda,
            PRODUCTO => producto,
            LEDS => leds,
            DISPLAYS_ENCENDIDOS => displays_encendidos,
            SEGMENTOS_ENCENDIDOS => segmentos_encendidos
    );
    
    process
    begin
        reset <= '0';
        wait for 30 ns;
        reset <= '1';
        producto <= "0010";
        wait for 920 ns;
        moneda(0) <= '1';
        wait for 100 ns;
        moneda(0) <= '0';
        for i in 1 to 3 loop
            wait for 900 ns;
            moneda(1) <= '1';
            wait for 100 ns;
            moneda(1) <= '0';
        end loop;
        wait for 900 ns;
        moneda(2) <= '1';
        wait for 100 ns;
        moneda(2) <= '0';
        wait for 4 ms;
        assert false
            report "Simulation finished."
            severity failure;
    end process;
end Behavioral;