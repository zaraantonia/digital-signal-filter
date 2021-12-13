library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity wallaceTree is
  Port (x,y: in std_logic_vector(3 downto 0);
        p: out std_logic_vector(7 downto 0));
end wallaceTree;

architecture Behavioral of wallaceTree is

component fullAdder is
  Port (x,y,cin: in std_logic;
        sum, cout: out std_logic );
end component;

component halfAdder is
  Port (x,y: in std_logic;
        sum, cout: out std_logic );
end component;

--The carry out and sums:
--c1,s1 for half adder1
--c2,s2 for half adder2
--c3,s3 for half adder3
--c4,s4 for full adder1
--c5,s5 for full adder2
--c6,s6 for full adder3

--The rc1,rc2,rc3,rc4,rc5,rc6 signals are the ripple carries for the ripple carry (last level in adder,
--that outputs the final product bits).

signal c1,c2,c3,c4,c5,c6,s1,s2,s3,s4,s5,s6,rc1,rc2,rc3,rc4,rc5: std_logic;

--Here I store the intermediary products that will be added later.
signal products: std_logic_vector(15 downto 0);

begin
--halfAdder1
products(0) <= x(1) and y(2);
products(1) <= x(0) and y(3);
--halfAdder2
products(2) <= x(1) and y(3);
products(3) <= x(2) and y(2);
--halfAdder3
products(4) <= x(0) and y(2);
products(5) <= x(1) and y(1);
--fullAdder1
products(6) <= x(3) and y(0);
products(7) <= x(2) and y(1);
--fullAdder2
products(8) <= x(3) and y(1);
--fullAdder3
products(9) <= x(2) and y(3);
products(10) <= x(3) and y(2);
--halfAdder4
products(11) <= x(1) and y(0);
products(12) <= x(0) and y(1);
--fullAdder4
products(13) <= x(2) and y(0);
--fullAdder8
products(14) <= x(3) and y(3);
--p(0)
products(15) <= x(0) and y(0);

--Adders are numbered from right to left, up to down.

HA1: halfAdder port map (x => products(0), y => products(1), sum => s1, cout => c1);
HA2: halfAdder port map (x => products(2), y => products(3), sum => s2, cout => c2);

HA3: halfAdder port map(x => products(4), y => products(5), sum => s3, cout => c3);

FA1: fullAdder port map(x => products(6), y => products(7), cin => s1, sum => s4, cout => c4);
FA2: fullAdder port map(x => s2, y => products(8), cin => c1, sum => s5, cout => c5);
FA3: fullAdder port map(x => products(9), y => products(10), cin => c2, sum => s6, cout => c6);

HA4: halfAdder port map (x => products(11), y => products(12), sum => p(1), cout => rc1);

FA4: fullAdder port map(x => products(13), y => s3, cin => rc1, sum => p(2), cout => rc2);
FA5: fullAdder port map(x => c3, y => s4, cin => rc2, sum => p(3), cout => rc3);
FA6: fullAdder port map(x => c4, y => s5, cin => rc3, sum => p(4), cout => rc4);
FA7: fullAdder port map(x => c5, y => s6, cin => rc4, sum => p(5), cout => rc5);
FA8: fullAdder port map(x => c6, y => products(14), cin => rc5, sum => p(6), cout => p(7));

p(0) <= products(15);

end Behavioral;
