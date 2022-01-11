library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is

component filters is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           new_input: in std_logic;
           filterSelect : in STD_LOGIC_VECTOR (1 downto 0);
           overflow: out std_logic;
           reset: in std_logic);
end component;

signal x : STD_LOGIC_VECTOR (7 downto 0);
signal y : STD_LOGIC_VECTOR (7 downto 0);
signal clk :STD_LOGIC;
signal new_input: std_logic;
signal filterSelect : STD_LOGIC_VECTOR (1 downto 0);
signal overflow: std_logic;
signal reset: std_logic := '0';

begin

process
begin
    clk <= '1';
    wait for 1us;
    clk <= '0';
    wait for 1us;
end process;

process
begin
    new_input <= '1';
    wait for 1us;
    new_input <= '0';
    wait for 19us;
end process;

process
begin
    x <= x"01";
    wait for 20us;
    x <= x"02";
    wait for 20us;
    x <= x"03";
    wait for 20us;
    x <= x"04";
    wait for 20us;
end process;

filter: filters port map(
    x => x,
    y => y,
    clk => clk,
    new_input => new_input,
    filterSelect => filterSelect,
    overflow => overflow,
    reset => reset);

end Behavioral;
