library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity vending_machine is
port (
	clk		: in	std_ulogic;
	rst		: in	std_ulogic;
	nickel		: in	std_ulogic;
	dime		: in	std_ulogic;
	dispense	: out	std_ulogic;
	amount		: out	natural range 0 to 15
);
end entity vending_machine;

architecture behavioral of vending_machine is
    -- Enumerated type for the states
    type state_type is (ZERO, FIVE, TEN, FIFTEEN);

    -- State signals
    signal current_state, next_state : state_type;

begin

    -- State transition logic (combinational)
    state_transition : process(current_state, nickel, dime)
    begin
        case current_state is
            when ZERO =>
                if nickel = '1' then
                    next_state <= FIVE;
                elsif dime = '1' then
                    next_state <= TEN;
                else
                    next_state <= ZERO;
                end if;

            when FIVE =>
                if nickel = '1' then
                    next_state <= TEN;
                elsif dime = '1' then
                    next_state <= FIFTEEN;
                else
                    next_state <= FIVE;
                end if;

            when TEN =>
                if nickel = '1' then
                    next_state <= FIFTEEN;
                elsif dime = '1' then
                    next_state <= FIFTEEN; -- Already at 15, stays at 15 bc we can do that for some reason lmao
                else
                    next_state <= TEN;
                end if;

            when FIFTEEN =>
                next_state <= ZERO; -- Dispense and reset to zero
        end case;
    end process state_transition;

    -- State register (synchronous)
    state_register : process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                current_state <= ZERO;  -- Reset to idle state
            else
                current_state <= next_state;
            end if;
        end if;
    end process state_register;

    -- Output logic :D
    output_logic : process(current_state)
    begin
        case current_state is
            when ZERO =>
                amount <= 0;
                dispense <= '0';

            when FIVE =>
                amount <= 5;
                dispense <= '0';

            when TEN =>
                amount <= 10;
                dispense <= '0';

            when FIFTEEN =>
                amount <= 15;
                dispense <= '1';  -- Dispense product! yayy
        end case;
    end process output_logic;

end architecture behavioral;
