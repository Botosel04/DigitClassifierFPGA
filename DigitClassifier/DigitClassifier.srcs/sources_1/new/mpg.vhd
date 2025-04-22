library ieee;
 use ieee.std_logic_1164.all;
 use ieee.std_logic_arith.all;
 use ieee.std_logic_unsigned.all;
 
 
entity mpg is
 port (
 clk : in std_logic;
 btn1 : in std_logic;
 enable : out std_logic

 );
end entity mpg;


architecture behavioral of mpg is

signal cnt : std_logic_vector(15 downto 0) := X"0000";

signal c1,c2,c3: std_logic;


begin

process(clk)
begin

    if  rising_edge(clk) then 
        cnt<=cnt+1;
    end if;

end process;
    
process(clk, btn1, cnt)
begin
    
    if rising_edge(clk) then
        if cnt=X"ffff" then c1<=btn1;
        end if;
    end if;

end process;

process(clk)
begin

    if rising_edge(clk) then c2<=c1;
    end if;

end process;

process(clk)
begin

    if rising_edge(clk) then c3<=c2;
    end if;

end process;

enable <= (NOT c3) AND c2;
 
end architecture behavioral;