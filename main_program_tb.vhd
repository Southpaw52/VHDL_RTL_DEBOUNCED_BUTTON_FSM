library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main_program_tb is
end entity;

architecture tb of main_program_tb is

    -- DUT ports
    signal clk          : std_logic := '0';
    signal sol_buton    : std_logic := '0';
    signal sag_buton    : std_logic := '0';
    signal merkez_buton : std_logic := '0';
    signal nRst         : std_logic := '0';
    signal led          : std_logic_vector(2 downto 0);

    -- 100 MHz clock => 10 ns period
    constant CLK_PERIOD : time := 10 ns;

    -- Your debounce count: 1_000_000 @100MHz => 10 ms
    constant DEBOUNCE_TIME : time := 10 ms;

    -- Small helper time
    constant TICKS : time := 50 * CLK_PERIOD; -- a few cycles margin

    -- Procedure: simulate a "bouncy" press then stable high long enough for debounce
    procedure press_with_bounce(
        signal btn : out std_logic
    ) is
    begin
        -- Bounce (quick toggles)
        btn <= '1'; wait for 200 ns;
        btn <= '0'; wait for 150 ns;
        btn <= '1'; wait for 120 ns;
        btn <= '0'; wait for 180 ns;
        btn <= '1';

        -- Hold stable long enough to pass debounce
        wait for (DEBOUNCE_TIME + 2 ms);

        -- Release (with a tiny bounce)
        btn <= '0'; wait for 150 ns;
        btn <= '1'; wait for 120 ns;
        btn <= '0';

        -- Let FSM settle
        wait for TICKS;
    end procedure;

begin

    -- DUT instantiation
    dut: entity work.main_program
        port map(
            clk          => clk,
            sol_buton    => sol_buton,
            sag_buton    => sag_buton,
            merkez_buton => merkez_buton,
            nRst         => nRst,
            led          => led
        );

    -- Clock generator
    clk_gen: process
    begin
        while true loop
            clk <= '0'; wait for CLK_PERIOD/2;
            clk <= '1'; wait for CLK_PERIOD/2;
        end loop;
    end process;

    -- Test sequence
    stim: process
    begin
        -- Initial reset low
        nRst <= '0';
        sol_buton <= '0';
        sag_buton <= '0';
        merkez_buton <= '0';
        wait for 200 ns;

        -- Release reset
        nRst <= '1';
        wait for TICKS;

        -- In your RTL, basla outputs "010"
        assert led = "010"
            report "Expected basla led=010 after reset release" severity error;

        ----------------------------------------------------------------------
        -- 1) basla -> sola_don on SOL press => led=100
        ----------------------------------------------------------------------
        press_with_bounce(sol_buton);
        assert led = "100"
            report "Expected sola_don led=100 after SOL press" severity error;

        -- Holding button longer should NOT retrigger (edge-only)
        sol_buton <= '1';
        wait for (DEBOUNCE_TIME + 2 ms);
        assert led = "100"
            report "LED changed while holding SOL; edge-only expected" severity error;
        sol_buton <= '0';
        wait for TICKS;

        ----------------------------------------------------------------------
        -- 2) sola_don -> dur on SOL press again => led=010
        ----------------------------------------------------------------------
        press_with_bounce(sol_buton);
        assert led = "010"
            report "Expected dur led=010 after SOL press in sola_don" severity error;

        ----------------------------------------------------------------------
        -- 3) dur -> saga_don on SAG press => led=001
        ----------------------------------------------------------------------
        press_with_bounce(sag_buton);
        assert led = "001"
            report "Expected saga_don led=001 after SAG press in dur" severity error;

        ----------------------------------------------------------------------
        -- 4) saga_don -> dur on SAG press again => led=010
        ----------------------------------------------------------------------
        press_with_bounce(sag_buton);
        assert led = "010"
            report "Expected dur led=010 after SAG press in saga_don" severity error;

        ----------------------------------------------------------------------
        -- 5) dur -> basla on MERKEZ press => led=010 (same as dur in your code)
        ----------------------------------------------------------------------
        press_with_bounce(merkez_buton);
        assert led = "010"
            report "Expected basla led=010 after MERKEZ press in dur" severity error;

        ----------------------------------------------------------------------
        -- 6) Reset during operation: force nRst low, expect basla (your code => led 010)
        ----------------------------------------------------------------------
        -- Go to sola_don first
        press_with_bounce(sol_buton);
        assert led = "100"
            report "Expected sola_don led=100 before reset test" severity error;

        -- Apply reset
        nRst <= '0';
        wait for 200 ns;
        nRst <= '1';
        wait for TICKS;

        assert led = "010"
            report "Expected basla led=010 after reset cycle" severity error;

        report "ALL TESTS PASSED ✅" severity note;
        wait;
    end process;

end architecture;
