library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_tempo is
end tb_tempo;

architecture Behavioral of tb_tempo is
    COMPONENT TEMPORIZADOR is
        port ( 
            CLK : in std_logic;
            ENABLE : in integer;
            TIEMPO : in integer;
            FIN : out std_logic
        );
    END COMPONENT;
    constant tiempo : integer := 3;
    signal clk : std_logic;
    signal enable: integer;
    signal fin : std_logic;
begin
    process
    begin
        clk <= '0';
        wait for 25ns;
        clk <= '1';
        wait for 25ns;
    end process;
    
    Inst_sincronizador : TEMPORIZADOR
        port map(
            CLK => clk,
            ENABLE => enable,
            TIEMPO => tiempo,
            FIN => fin
    );
    
    process
    begin
        ENABLE <= 0;
        wait for 200 ns;
        ENABLE <= 10;
        wait for 200 ns;
        ENABLE <= 0;
        wait for 200 ns;
        assert false
            report "Simulation finished."
            severity failure;
    end process;
end Behavioral;