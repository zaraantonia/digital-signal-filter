library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carryBlock2 is
  Port (x0,y0,x1,y1,c0: in std_logic;
    c2: out std_logic );
end carryBlock2;

architecture Behavioral of carryBlock2 is
begin
process(x0,y0,c0)
variable g0,p0,g1,p1,c1: std_logic;
begin
    g0 := x0 and y0;
    p0 := x0 or y0;
    c1 := g0 or (p0 and c0);  
    g1 := x1 and y1;
    p1 := x1 or y1;
    c2 <= g1 or (p1 and c1);   
end process;
    

end Behavioral;
