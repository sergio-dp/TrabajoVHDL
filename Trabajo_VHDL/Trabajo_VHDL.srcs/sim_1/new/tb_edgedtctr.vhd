library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_edgedtctr is
end tb_edgedtctr;

architecture Behavioral of tb_edgedtctr is
    COMPONENT SYNCHRNZR is
        generic (WITDH : positive);
        port ( 
            CLK : in std_logic;
            ASYNC_IN : in std_logic_vector(WITDH -1 downto 0);
            SYNC_OUT : out std_logic_vector(WITDH -1 downto 0)
        );
    END COMPONENT;
    COMPONENT EDGEDTCTR is
        generic (WITDH : positive);
        port ( 
            CLK : in std_logic;
            SYNC_IN : in std_logic_vector(WITDH -1 downto 0);
            EDGE : out std_logic_vector(WITDH -1 downto 0)
        );
    END COMPONENT;
    constant witdh : positive := 4;
    signal clk : std_logic;
    signal async_in, sync_out, pulso : std_logic_vector(WITDH -1 downto 0);
begin
    process
    begin
        clk <= '0';
        wait for 25ns;
        clk <= '1';
        wait for 25ns;
    end process;
    
    Inst_sincronizador : SYNCHRNZR
        generic map (WITDH)
        port map(
            CLK => clk,
            ASYNC_IN => async_in,
            SYNC_OUT => sync_out
    );
    Inst_generador_pulsos : EDGEDTCTR
        generic map (WITDH)
        port map(
            CLK => clk,
            SYNC_IN => sync_out,
            EDGE => pulso
    );
    
    process
    begin
        async_in <= "0000";
        wait for 15 ns;
        for i in 0 to WITDH -1 loop
            async_in(i) <= '1';
            wait for 80 ns;
            async_in(i) <= '0';
            wait for 50 ns;
        end loop;
        wait for 400ns;
        assert false
            report "Simulation finished."
            severity failure;
    end process;
end Behavioral;