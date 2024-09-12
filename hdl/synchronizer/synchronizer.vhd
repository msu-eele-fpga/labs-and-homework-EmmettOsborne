library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
    port (
        clk   : in  std_ulogic;
        async : in  std_ulogic;
        sync  : out std_ulogic
    );
end entity synchronizer;

architecture behavioral of synchronizer is
    signal stg1, stg2 : std_ulogic;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            stg1 <= async;    --First flipflop stage
            stg2 <= stg1;   --Second flipflop stage
        end if;
    end process;

    sync <= stg2;   --Output sync'd signal

end architecture behavioral;