library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity washcontrol is
    port (
        inicia, cheia, tempo, vazia: in std_logic;
        clock: in std_logic;
        
        entrada_agua: out std_logic;
        aciona_motor: out std_logic;
        saida_agua: out std_logic
    );
end entity;

architecture behavioral of washcontrol is
    type state_type is (IDLE, FILLING, WASHING, DRAINING);
    signal current_state, next_state : state_type;
begin
    process (clock)
    begin
        if rising_edge(clock) then
            current_state <= next_state;
        end if;
    end process;
    
    process (current_state, inicia, cheia, tempo, vazia)
    begin
        entrada_agua <= '0';
        aciona_motor <= '0';
        saida_agua <= '0';
        
        case current_state is
            when IDLE =>
                if inicia = '1' then
                    next_state <= FILLING;
                else
                    next_state <= IDLE;
                end if;
            when FILLING =>
                entrada_agua <= '1';
                
                if cheia = '1' then
                    next_state <= WASHING;
                else
                    next_state <= FILLING;
                end if;
            when WASHING =>
                aciona_motor <= '1';
                
                if tempo = '1' then
                    next_state <= DRAINING;
                else
                    next_state <= WASHING;
                end if;
            when DRAINING =>
                saida_agua <= '1';
                
                if vazia = '1' then
                    next_state <= IDLE;
                else
                    next_state <= DRAINING;
                end if;
            when others =>
                next_state <= IDLE;
        end case;
    end process;
end architecture;