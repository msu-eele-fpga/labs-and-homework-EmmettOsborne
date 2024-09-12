library ieee;
use ieee.std_logic_1164.all;

entity synchronizer is
    port (
        clk   : in  std_ulogic;
        async : in  std_ulogic;
        sync  : out std_ulogic
    );
end entity synchronizer;

