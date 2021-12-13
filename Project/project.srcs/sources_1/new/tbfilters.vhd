library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tbfilters is
--  Port ( );
end tbfilters;

architecture Behavioral of tbfilters is 
component filters is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           filterSelect : in STD_LOGIC_VECTOR (2 downto 0);
           overflow: out std_logic);
end component;

signal x,y: STD_LOGIC_VECTOR (7 downto 0);
signal clk, overflow: std_logic;
signal filterSelect : STD_LOGIC_VECTOR (2 downto 0);

begin

flt: filters port map (x => x, y => y, clk => clk, filterSelect => filterSelect, overflow => overflow);

process
begin
    clk <= '0';
    wait for 5us;
    clk <= '1';
    wait for 5us;
end process;

filterSelect <= "000";

end Behavioral;
