library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR is
    GENERIC (WITDH : positive);
    PORT ( 
        CLK : in std_logic;
        SYNC_IN : in std_logic_vector(WITDH - 1 downto 0);
        EDGE : out std_logic_vector(WITDH - 1 downto 0)
    );
end EDGEDTCTR;

architecture BEHAVIORAL of EDGEDTCTR is
    signal sreg : std_logic_vector(3*WITDH - 1 downto 0);
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            for i in 0 to WITDH - 1 loop
                sreg(3*i + 2 downto 3*i) <= sreg(3*i + 1 downto 3*i) & SYNC_IN(i);
                case sreg(3*i + 2 downto 3*i) is
                    when "100" =>
                        EDGE(i) <= '1';
                    when others =>
                        EDGE(i) <= '0';
                end case;
            end loop;
        end if;
    end process;
end BEHAVIORAL;