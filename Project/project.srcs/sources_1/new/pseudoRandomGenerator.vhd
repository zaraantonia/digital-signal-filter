library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pseudoRandomGenerator is
    Port ( clk : in STD_LOGIC;
           nr : out STD_LOGIC_VECTOR (7 downto 0));
end pseudoRandomGenerator;

architecture Behavioral of pseudoRandomGenerator is

signal nrSig: std_logic_vector(4 downto 0) := "00010";
signal msb: std_logic := '0';

begin

process(clk)
begin
    if rising_edge(clk) then
        msb <= nrSig(4) xor nrSig(1);
        nrSig <= msb & nrSig(4 downto 1);
    end if;
end process;

nr <= "000" & nrSig;

end Behavioral;
