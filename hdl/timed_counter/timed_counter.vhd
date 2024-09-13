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
