library ieee;
use ieee.std_logic_1164.all;

entity timed_counter is
	generic (
		clk_period	: time;
		count_time	: time
	);
	port (
		clk			: in 	std_ulogic;
		enable		: in	boolean;
		done			: out	boolean
	);
end entity timed_counter;

architecture behavioral of timed_counter is
	-- Calculate the limit of the counter
	constant COUNTER_LIMIT : natural := integer(count_time / clk_period);
	
	-- Signal for the counter value constrained to the needed range.
	signal counter : natural range 0 to COUNTER_LIMIT := 0;
	
begin

	process(clk)
	begin
		if rising_edge(clk) then
			if enable then
				-- Inc the counter if enable = true
				if counter < COUNTER_LIMIT - 1 then
					counter <= counter + 1;
				else
					-- If counter is at the limit, assert done for a single clock cycle and reset.
					done <= true;
					counter <= 0;
				end if;
			else
				-- Reset counter when enable = false
				counter <= 0;
				done <= false;
			end if;
		end if;
	end process;
end architecture behavioral;