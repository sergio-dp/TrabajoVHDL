library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_decoder is
end tb_decoder;

architecture Behavioral of tb_decoder is
    COMPONENT DECODER is
        generic (DISPLAYS : positive; -- Numero total de displays que hay
                 SEGMENTOS : positive -- Segmentos que tiene cada display
        );
        port (
            CLK : in std_logic;
            ESTADO_ACTUAL : in integer;
            DISPLAYS_ENCENDIDOS : out std_logic_vector(DISPLAYS - 1 downto 0);
            SEGMENTOS_ENCENDIDOS : out std_logic_vector(SEGMENTOS - 1 downto 0)
        );
    END COMPONENT;
    constant displays : positive := 8;
    constant segmentos : positive := 8;
    signal clk : std_logic;
    signal estado_actual : integer := 0;
    signal displays_encendidos : std_logic_vector(displays - 1 downto 0);
    signal segmentos_encendidos : std_logic_vector(segmentos - 1 downto 0);
begin
    process
    begin
        clk <= '0';
        wait for 25 ns;
        clk <= '1';
        wait for 25 ns;
    end process;
    
    Inst_decoder : DECODER
        generic map (DISPLAYS,SEGMENTOS)
        port map(
            CLK => clk,
            ESTADO_ACTUAL => estado_actual,
            DISPLAYS_ENCENDIDOS => displays_encendidos,
            SEGMENTOS_ENCENDIDOS => segmentos_encendidos
    );
    
    process
    begin
        wait for 125 ns;
        for i in 1 to 11 loop
            wait for 900 ns;
            estado_actual <= i;
        end loop;
        wait for 900ns;
        assert false
            report "Simulation finished."
            severity failure;
    end process;
end Behavioral;