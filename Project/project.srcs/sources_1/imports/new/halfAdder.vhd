library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity halfAdder is
  Port (x,y: in std_logic;
        sum, cout: out std_logic );
end halfAdder;

architecture Behavioral of halfAdder is

begin
process(x,y)
begin
    sum <= x xor y;
    cout <= x and y;
end process;

end Behavioral;
