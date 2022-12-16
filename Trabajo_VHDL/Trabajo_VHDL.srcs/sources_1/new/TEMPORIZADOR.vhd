library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TEMPORIZADOR is
    PORT ( CLK : in std_logic;
           ENABLE : in integer; -- Solo quiero empezar a contar cuando esté en S100 o S_mas
           TIEMPO : in integer; -- Tiempo a contar en segundos
           FIN : out std_logic
    );
end TEMPORIZADOR;

architecture Behavioral of TEMPORIZADOR is
    signal salida_auxiliar : std_logic;
begin    
    process(CLK)
        subtype ciclos is integer range 0 to 10**8;
        variable contaje : ciclos;
        variable segundos : integer;
    begin
        if rising_edge(CLK) then
            if ENABLE = 10 or ENABLE = 11 then
                contaje := contaje + 1;
                if contaje = 10**8 - 1 then
                    contaje := 0;
                    segundos := segundos + 1;
                end if;
                if segundos = TIEMPO then
                    salida_auxiliar <= '1';
                end if;
            else
                contaje := 0;
                segundos := 0;
                salida_auxiliar <= '0';
            end if;
        end if;
    end process;
    
    FIN <= salida_auxiliar; -- salida definitiva de la entidad
end Behavioral;