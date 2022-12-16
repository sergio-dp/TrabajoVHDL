library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR is
    GENERIC (WITDH : positive);
    PORT ( 
        CLK : in std_logic;
        ASYNC_IN : in std_logic_vector(WITDH - 1 downto 0);
        SYNC_OUT : out std_logic_vector(WITDH - 1 downto 0)
    );
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is
    signal sreg : std_logic_vector(2*WITDH - 1 downto 0);
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            for i in 0 to WITDH - 1 loop
                SYNC_OUT(i) <= sreg(2*i + 1);
                sreg(2*i + 1 downto 2*i) <= sreg(2*i) & ASYNC_IN(i);
            end loop;
        end if; 
    end process;
end BEHAVIORAL;