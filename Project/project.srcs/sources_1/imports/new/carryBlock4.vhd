library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity carryBlock4 is
  Port (x0,y0,x1,y1,x2,y2,x3,y3,c0: in std_logic;
    c4: out std_logic );
end carryBlock4;

architecture Behavioral of carryBlock4 is
begin
process(x0,y0,c0)
variable g0,p0,g1,p1,g2,p2,g3,p3,c1,c2,c3: std_logic;
begin
    g0 := x0 and y0;
    p0 := x0 or y0;
    c1 := g0 or (p0 and c0); 
     
    g1 := x1 and y1;
    p1 := x1 or y1;
    c2 := g1 or (p1 and c1); 
    
    g2 := x2 and y2;
    p2 := x2 or y2;
    c3 := g2 or (p2 and c2);
    
    g3 := x3 and y3;
    p3 := x3 or y3;
    c4 <= g3 or (p3 and c3);
end process;
    

end Behavioral;
