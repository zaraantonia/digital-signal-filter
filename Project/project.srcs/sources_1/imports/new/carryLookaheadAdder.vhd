library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity carryLookaheadAdder is
  Port (x,y: in std_logic_vector(3 downto 0);
        c0: in std_logic;
        s: out std_logic_vector(3 downto 0);
        c4: out std_logic);
end carryLookaheadAdder;

architecture Behavioral of carryLookaheadAdder is 

component fullAdder is
  Port (x,y,cin: in std_logic;
        sum, cout: out std_logic );
end component;

component carryBlock1 is
  Port (x0,y0,c0: in std_logic;
    c1: out std_logic );
end component;

component carryBlock2 is
  Port (x0,y0,x1,y1,c0: in std_logic;
    c2: out std_logic );
end component;

component carryBlock3 is
  Port (x0,y0,x1,y1,x2,y2,c0: in std_logic;
    c3: out std_logic );
end component;

component carryBlock4 is
  Port (x0,y0,x1,y1,x2,y2,x3,y3,c0: in std_logic;
    c4: out std_logic );
end component;

signal c1,c2,c3,dummycout1,dummycout2,dummycout3,dummycout4: std_logic;

begin

FA1: fullAdder port map(x => x(0), y => y(0), cin => c0, sum => s(0), cout => dummycout1);
FA2: fullAdder port map(x => x(1), y => y(1), cin => c1, sum => s(1), cout => dummycout2);
FA3: fullAdder port map(x => x(2), y => y(2), cin => c2, sum => s(2), cout => dummycout3);
FA4: fullAdder port map(x => x(3), y => y(3), cin => c3, sum => s(3), cout => dummycout4);

CB1: carryBlock1 port map(x0 => x(0), y0 => y(0),
                            c0 => c0, c1 => c1);
CB2: carryBlock2 port map(x0 => x(0), y0 => y(0), 
                            x1 => x(1), y1 => y(1), 
                            c0 => c0, c2 => c2);
CB3: carryBlock3 port map(x0 => x(0), y0 => y(0), 
                            x1 => x(1), y1 => y(1),
                            x2 => x(2), y2 => y(2), 
                            c0 => c0, c3 => c3);
CB4: carryBlock4 port map(x0 => x(0), y0 => y(0), 
                            x1 => x(1), y1 => y(1),
                            x2 => x(2), y2 => y(2), 
                            x3 => x(3), y3 => y(3),
                            c0 => c0, c4 => c4);
end Behavioral;
