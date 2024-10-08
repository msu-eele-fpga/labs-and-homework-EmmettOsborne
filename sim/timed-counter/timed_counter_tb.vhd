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
            clk_period      : time;
            count_time      : time
        );
        
        port (
            clk     : in    std_ulogic;
            enable  : in    boolean;
            done    : out   boolean
        );
    end component timed_counter;
    
    signal clk_tb : std_ulogic := '0';
    
    signal enable_100ns_tb   : boolean := false;
    signal done_100ns_tb     : boolean;

    signal enable_240ns_tb   : boolean := false;
    signal done_240ns_tb     : boolean;
    
    constant HUNDRED_NS      : time := 100 ns;
    constant TWO_HUNDRED_FORTY_NS : time := 240 ns;

    -- Procedure to predict when the counter should assert done
	 procedure predict_counter_done (
		 constant count_time  : in time;
		 signal enable        : in boolean;
		 signal done          : in boolean;
		 constant count_iter  : in natural
	 ) is
	 begin
		 if enable then
			print(count_iter);
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
    
    -- Instantiate the first timed_counter for 100ns
    dut_100ns_counter : component timed_counter
        generic map (
            clk_period => CLK_PERIOD,
            count_time => HUNDRED_NS
        )
        port map (
            clk     => clk_tb,
            enable  => enable_100ns_tb,
            done    => done_100ns_tb
        );

    -- Instantiate the second timed_counter for 240ns
    dut_240ns_counter : component timed_counter
        generic map (
            clk_period => CLK_PERIOD,
            count_time => TWO_HUNDRED_FORTY_NS
        )
        port map (
            clk     => clk_tb,
            enable  => enable_240ns_tb,
            done    => done_240ns_tb
        );
        
    -- Clock gen
    clk_tb <= not clk_tb after CLK_PERIOD / 2;
    
    stimuli_and_checker : process is
    begin
    
        -- Success Case 1 for 100 ns timer
        print("Testing 100ns timer: Enabled.");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= true;
        
        -- Loop for the number of clock cycles that is equal to the timer's period.
        for i in 0 to (HUNDRED_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
        end loop;

        -- Success Case 2 for 100 ns timer
        print("Testing 100ns timer: Disabled.");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= false;
        
        -- Ensure the counter does not assert 'done' for two full periods
        for i in 0 to 2 * (HUNDRED_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
        end loop;

        -- Success Case 3 for 100 ns timer
        print("Testing 100ns timer: Enabled for multiple periods.");
        wait_for_clock_edge(clk_tb);
        enable_100ns_tb <= true;
        
        -- Outer loop: Run for multiple count_time periods. Doing 3 periods bc that seemed like enough
        for j in 0 to 2 loop -- Nested loops :D
            for i in 0 to (HUNDRED_NS / CLK_PERIOD) loop
                wait_for_clock_edge(clk_tb);
                predict_counter_done(HUNDRED_NS, enable_100ns_tb, done_100ns_tb, i);
            end loop;
        end loop;

        -- Success Case 1 for 240 ns timer
        print("Testing 240ns timer: Enabled.");
        wait_for_clock_edge(clk_tb);
        enable_240ns_tb <= true;
        
        -- Loop for the number of clock cycles that is equal to the timer's period.
        for i in 0 to (TWO_HUNDRED_FORTY_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(TWO_HUNDRED_FORTY_NS, enable_240ns_tb, done_240ns_tb, i);
        end loop;

        -- Success Case 2 for 240 ns timer
        print("Testing 240ns timer: Disabled.");
        wait_for_clock_edge(clk_tb);
        enable_240ns_tb <= false;
        
        -- Ensure the counter does not assert 'done' for two full periods
        for i in 0 to 2 * (TWO_HUNDRED_FORTY_NS / CLK_PERIOD) loop
            wait_for_clock_edge(clk_tb);
            predict_counter_done(TWO_HUNDRED_FORTY_NS, enable_240ns_tb, done_240ns_tb, i);
        end loop;

        -- Success Case 3 for 240 ns timer
        print("Testing 240ns timer: Enabled for multiple periods.");
        wait_for_clock_edge(clk_tb);
        enable_240ns_tb <= true;
        
        -- Outer loop: Run for multiple count_time periods
        for j in 0 to 2 loop
            for i in 0 to (TWO_HUNDRED_FORTY_NS / CLK_PERIOD) loop
                wait_for_clock_edge(clk_tb);
                predict_counter_done(TWO_HUNDRED_FORTY_NS, enable_240ns_tb, done_240ns_tb, i);
            end loop;
        end loop;

        -- Testbench is done!
        std.env.finish;

    end process stimuli_and_checker;

end architecture testbench;