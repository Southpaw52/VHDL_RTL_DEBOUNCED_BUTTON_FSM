library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_program is
    Port ( clk : in STD_LOGIC;
           sol_buton : in STD_LOGIC;
           sag_buton : in STD_LOGIC;
           merkez_buton : in STD_LOGIC;
           nRst : in STD_LOGIC;
           led : out STD_LOGIC_VECTOR (2 downto 0));
end main_program;

architecture Behavioral of main_program is

type state_type is (basla, sola_don, saga_don, dur);
signal current_state, next_state: state_type;

constant bekleme_suresi : integer :=  1000000;
signal sol_sayac, sag_sayac, merkez_sayac : integer range 0 to bekleme_suresi := 0;
signal sol_onceki, sag_onceki, merkez_onceki : std_logic := '0';
signal sol_temiz, sag_temiz, merkez_temiz : std_logic := '0';
begin

debounce_islemi: process(clk) is
begin
    if rising_edge(clk) then
        if sol_buton = '1' then
            if sol_sayac < bekleme_suresi then
                sol_sayac <= sol_sayac + 1;
                sol_temiz <= '0';
             else
                sol_temiz <= '1';
             end if; 
         else
            sol_sayac <= 0;
            sol_temiz <= '0';
         end if;
--         -------------------------------------------------------------------------------------------------
--         -------------------------------------------------------------------------------------------------   
        if sag_buton = '1' then
            if sag_sayac < bekleme_suresi then
                sag_sayac <= sag_sayac + 1;
                sag_temiz <= '0';
             else
                sag_temiz <= '1';
             end if; 
         else
            sag_sayac <= 0;
            sag_temiz <= '0';
         end if;  
--         -------------------------------------------------------------------------------------------------
--         -------------------------------------------------------------------------------------------------   
        if merkez_buton = '1' then
            if merkez_sayac < bekleme_suresi then
                merkez_sayac <= merkez_sayac + 1;
                merkez_temiz <= '0';
            else
                merkez_temiz <= '1';
            end if;
        else
            merkez_sayac <= 0;
            merkez_temiz <= '0';
        end if;
        
        sol_onceki    <= sol_temiz;
        sag_onceki    <= sag_temiz;
        merkez_onceki <= merkez_temiz;
               
     end if; 
    
end process debounce_islemi;


fsm_islemi: process(clk,nRst)
begin
    if nRst = '0' then
        current_state <= basla;
    elsif rising_edge(clk) then
        current_state <= next_state;
    end if;
end process fsm_islemi;

karar: process(current_state, sol_temiz, sol_onceki, sag_temiz, sag_onceki, merkez_temiz, merkez_onceki)
begin
    next_state <= current_state;
    case current_state is
        when basla =>
            led <= "010";
            if sol_temiz = '1' and sol_onceki = '0' then
            next_state <= sola_don;
            end if;
            if sag_temiz = '1' and sag_onceki = '0' then
            next_state <= saga_don;
            end if;
        
        when sola_don =>
            led <= "100";
            if sol_temiz = '1' and sol_onceki = '0' then
            next_state <= dur;
            end if;
        
        when saga_don =>
            led <= "001";
            if sag_temiz = '1' and sag_onceki = '0' then
            next_state <= dur;
            end if;   
        
        when dur =>
            led <= "010";
            if sol_temiz = '1' and sol_onceki = '0' then
            next_state <= sola_don;
            end if;
            if sag_temiz = '1' and sag_onceki = '0' then
            next_state <= saga_don;
            end if;   
            if merkez_temiz = '1' and merkez_onceki = '0' then
            next_state <= basla;
            end if;     
         end case;
        
 end process karar;

end Behavioral;
