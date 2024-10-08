library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.assert_pkg.all;
use work.print_pkg.all;
use work.tb_pkg.all;

entity debouncer is
	generic (
		clk_period	: time := 20 ns;
		debounce_time	: time
	);
	port (
		clk		: in 	std_ulogic;
		rst		: in	std_ulogic;
		input		: in 	std_ulogic;
		debounced	: out	std_ulogic
	);
end entity debouncer;

architecture debouncer_arch of debouncer is
	type state_type is (idle, debouncing);
	signal current_state, next_state : state_type := idle;
	signal count : integer range 0 to (debounce_time / clk_period);
	begin

-- State Memory

	STATE_MEMORY : process(clk, rst)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				current_state <= idle;
				count <= 0;
			else
				current_state <= next_state;
				if current_state = debouncing then
					if count < (debounce_time / clk_period) then
						count <= count + 1;
					end if;
				else
					count <= 0; -- Resetting count when not debouncing
				end if;
			end if;
		end if;
	end process;

-- Next State Logic

	NEXT_STATE_LOGIC : process (current_state, input)
	begin
		case current_state is
			when idle =>
				if input = '1' then
					next_state <= debouncing;
				else
					next_state <= idle;
				end if;

			when debouncing =>
				if count >= (debounce_time / clk_period) then
					next_state <= idle;
				else
					next_state <= debouncing;
				end if;
		end case;
	end process;

-- Output Logic

	OUTPUT_LOGIC : process (current_state)
	begin
		case (current_state) is
			when idle => 
				debounced <= '0';
			when debouncing => 
				if count >= (debounce_time / clk_period) then
					debounced <= '1'; -- Yayy debounced :D
				else
					debounced <= '0'; -- Still debouncing :(
				end if;
			when others => 
				debounced <= '0';
		end case;
	end process;
end architecture debouncer_arch;