library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rippleCarryAdder is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           cin: in std_logic;
           sum : out STD_LOGIC_VECTOR (7 downto 0);
           cout: out std_logic);
end rippleCarryAdder;

architecture Behavioral of rippleCarryAdder is

component fullAdder is
  Port (x,y,cin: in std_logic;
        sum, cout: out std_logic );
end component;

signal c1,c2,c3,c4,c5,c6,c7 : std_logic;

begin

fullAdder1: fullAdder port map(x => a(0), y => b(0), cin => '0', sum => sum(0), cout => c1);
fullAdder2: fullAdder port map(x => a(1), y => b(1), cin => c1, sum => sum(1), cout => c2);
fullAdder3: fullAdder port map(x => a(2), y => b(2), cin => c2, sum => sum(2), cout => c3);
fullAdder4: fullAdder port map(x => a(3), y => b(3), cin => c3, sum => sum(3), cout => c4);
fullAdder5: fullAdder port map(x => a(4), y => b(4), cin => c4, sum => sum(4), cout => c5);
fullAdder6: fullAdder port map(x => a(5), y => b(5), cin => c5, sum => sum(5), cout => c6);
fullAdder7: fullAdder port map(x => a(6), y => b(6), cin => c6, sum => sum(6), cout => c7);
fullAdder8: fullAdder port map(x => a(7), y => b(7), cin => c7, sum => sum(7), cout => cout);


end Behavioral;
