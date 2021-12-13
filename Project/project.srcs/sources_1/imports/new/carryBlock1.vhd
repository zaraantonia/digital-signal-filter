library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carryBlock1 is
  Port (x0,y0,c0: in std_logic;
    c1: out std_logic );
end carryBlock1;

architecture Behavioral of carryBlock1 is
begin
process(x0,y0,c0)
variable g0,p0: std_logic;
begin
    g0 := x0 and y0;
    p0 := x0 or y0;
    c1 <= g0 or (p0 and c0);   
end process;
    

end Behavioral;
