library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Types is
    type vector_t is array (natural range <>) of signed(7 downto 0);
end package;
