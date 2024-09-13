library ieee;
use ieee.std_logic_1164.all;
use work.print_pkg.all;
use work.assert_pkg.all;
use work.tb_pkg.all;

entity timed_counter_tb is
end entity timed_counter_tb;

architecture testbench of timed_counter_tb is
	
	component timed_counter is
		generic (
			clock_period	: time;
			count_time		: time
		);
		
		port (
			clk		: in 	std_ulogic;
			enable 	: in	boolean;
			done 		: out	boolean
		);
	end component timed_counter;
	
	signal clk_tb : std_ulogic := '0';
	
	signal enable_100ns_tb	: boolean := false;
	signal done_100ns_tb		: boolean;
	
	constant HUNDRED_NS		: time : 100 ns;
	
	procedure predict_counter_done (
		constant count_time	: in time;
		signal enable			: in boolean;
		signal done 			: in boolean;
		constant count_iter	: in natural
	) is
	
	begin
	
		if enable then
			if count_iter < (count_time / CLK_PERIOD) then
				assert_false(done, "Counter not done");
			else
				assert_true(done, "Counter is done");
			end if;
		else
			assert_false(done, "Counter not enabled");
		end if;
		
	end procedure predict_counter_done;
	
begin
	
	dut_100ns_counter : component timed_counter
	
		generic map (
			clk_period => CLK_PERIOD,
			count_time => HUNDRED_NS
		)
		
		port map (
			clk		=> clk_tb,
			enable	=> HUNDRED_NS
		);
		
	clk_tb <= not_clock_tb after CLK_PERIOD / 2;
	
	simuli_and_checker : process is
	begin
	
		-- Test 100 ns timer when it's enabled
		print("Testing 100ns timer: Enabled.");
		wait_for_clock_edge(clk_tb);
		enable_100ns_tb <= true;
		
		-- Loop for the number of clock cycles that is equal to the timer's period.
		for i in 0 to (HUNDRED_NS / CLK_PERIOD) loop
			wait_for_clock_edge(clk_tb);
			predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
		end loop;
		
		-- Add other test cases..
		
		-- TB is done!
		
		std.env.finish;

	end process simuli_and_checker;
end architcture testbench;