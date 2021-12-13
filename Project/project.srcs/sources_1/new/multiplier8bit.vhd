library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier8bit is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           overflow: out std_logic);
end multiplier8bit;

architecture Behavioral of multiplier8bit is

component wallaceTree is
  Port (x,y: in std_logic_vector(3 downto 0);
        p: out std_logic_vector(7 downto 0));
end component;

component rippleCarryAdder is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           cin: in std_logic;
           sum : out STD_LOGIC_VECTOR (7 downto 0);
           cout: out std_logic);
end component;

--LL = yL, xL
--LH = yL, xH
--HL = yH, xL
--HH = yH, xH
signal resultLL, resultLH, resultHL, resultHH : std_logic_vector(7 downto 0);
--rca = ripple carry adder
--rca1 = resultLL + resultLH << 4
--rca2 = resultHL << 4 + resultHH << 8
signal resultRca1, resultRca2: std_logic_vector(7 downto 0);

signal rcaCout1, rcaCout2: std_logic;
signal shiftLH, shiftHL, shiftHH: std_logic_vector(7 downto 0);

begin

shiftLH <= resultLH(3 downto 0) & "0000";
shiftHL <= resultHL(3 downto 0) & "0000";
shiftHH <= "00000000";

wallaceTreeLL: wallaceTree port map (x => x(3 downto 0), y => y(3 downto 0), p => resultLL);
wallaceTreeLH: wallaceTree port map (x => x(7 downto 4), y => y(3 downto 0), p => resultLH);
wallaceTreeHL: wallaceTree port map (x => x(3 downto 0), y => y(7 downto 4), p => resultHL);
wallaceTreeHH: wallaceTree port map (x => x(7 downto 4), y => y(7 downto 4), p => resultHH);

rippleCarryAdder1: rippleCarryAdder port map (a => resultLL, b => shiftLH, cin => '0', sum => resultRca1, cout => rcaCout1);
rippleCarryAdder2: rippleCarryAdder port map (a => shiftHL, b => shiftHH, cin => '0', sum => resultRca2, cout => rcaCout2);
rippleCarryAdder3: rippleCarryAdder port map (a => resultRca1, b => resultRca2, cin => '0', sum => result, cout => overflow);

end Behavioral;
