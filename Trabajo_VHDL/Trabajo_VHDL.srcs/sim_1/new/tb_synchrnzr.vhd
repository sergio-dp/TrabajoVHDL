library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_synchrnzr is
end tb_synchrnzr;

architecture Behavioral of tb_synchrnzr is
    COMPONENT SYNCHRNZR is
        generic (WITDH : positive);
        port ( 
            CLK : in std_logic;
            ASYNC_IN : in std_logic_vector(WITDH -1 downto 0);
            SYNC_OUT : out std_logic_vector(WITDH -1 downto 0)
        );
    END COMPONENT;
    constant witdh : positive := 4;
    signal clk : std_logic;
    signal async_in, sync_out : std_logic_vector(WITDH -1 downto 0);
begin
    process
    begin
        clk <= '0';
        wait for 25ns;
        clk <= '1';
        wait for 25ns;
    end process;

    Inst_sincronizador : SYNCHRNZR
        generic map (witdh)
        port map(
            CLK => clk,
            ASYNC_IN => async_in,
            SYNC_OUT => sync_out
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
        wait for 200ns;
        assert false
            report "Simulation finished."
            severity failure;
    end process;
end Behavioral;