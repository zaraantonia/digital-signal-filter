library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fullAdder is
  Port (x,y,cin: in std_logic;
        sum, cout: out std_logic );
end fullAdder;

architecture Behavioral of fullAdder is

begin
process(x,y,cin)
begin
    sum <= x xor y xor cin;
    cout <= (x and y) or ((x or y) and cin);
end process;

end Behavioral;
