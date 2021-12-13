library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity filters is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           filterSelect : in STD_LOGIC_VECTOR (2 downto 0);
           overflow: out std_logic);
end filters;

architecture Behavioral of filters is

component multiplier8bit is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           result : out STD_LOGIC_VECTOR (7 downto 0);
           overflow: out std_logic);
end component;

component rippleCarryAdder is
    Port ( a : in STD_LOGIC_VECTOR (7 downto 0);
           b : in STD_LOGIC_VECTOR (7 downto 0);
           cin: in std_logic;
           sum : out STD_LOGIC_VECTOR (7 downto 0);
           cout: out std_logic);
end component;

--first multiplier signals
signal a, b, product1: std_logic_vector(7 downto 0) := (others => '0');
signal of1: std_logic := '0';
--second multiplier signals
signal c, d, product2: std_logic_vector(7 downto 0) := (others => '0');
signal of2: std_logic := '0';
--third multiplier signals
signal e, f, product3: std_logic_vector(7 downto 0) := (others => '0');
signal of3: std_logic := '0';

--first ripple carry adder signals
signal ra, rb, sum1: std_logic_vector(7 downto 0) := (others => '0');
signal cout1: std_logic := '0';
--second ripple carry adder signals
signal rc, rd, sum2: std_logic_vector(7 downto 0) := (others => '0');
signal cout2: std_logic := '0';

--input states
signal xn, xn1, xn2: std_logic_vector(7 downto 0) := (others => '0');
--output states
signal yn, yn1: std_logic_vector(7 downto 0) := (others => '0');

--counter for n
signal n: std_logic_vector(7 downto 0) := "00000000";

begin

multiplier1: multiplier8bit port map (x => a, y => b, result => product1, overflow => of1);
multiplier2: multiplier8bit port map (x => c, y => d, result => product2, overflow => of2);
multiplier3: multiplier8bit port map (x => e, y => f, result => product3, overflow => of3);

rippleCarryAdder1: rippleCarryAdder port map (a => ra, b => rb, cin => '0', sum => sum1, cout => cout1);
rippleCarryAdder2: rippleCarryAdder port map (a => rc, b => rd, cin => cout1, sum => sum2, cout => cout2);

--updating input and output states, n
process(clk)
begin
    if rising_edge(clk) then
        xn2 <= xn1;
        xn1 <= xn;
        xn <= x;
        yn1 <= yn;
        n <= n + '1';
        yn <= sum2;
        y <= yn;
    end if;
end process;

--any overflow from any component signals an error in calculation
overflow <= of1 or of2 or of3 or cout2;

--process for selecting operands for arithmetical components
process(filterSelect,clk)
begin
    if rising_edge(clk) then
        case filterSelect is
            --2xn + 3xn1
            when "000" =>
                a <= "00000010";
                b <= xn;
                c <= "00000011";
                d <= xn1;
                e <= "00000000";
                f <= "00000000";
                ra <= product1;
                rb <= product2;
                rc <= sum1;
                rd <= "00000000";
            --xn + 2*n*xn1
            when "001" =>
                a <= "00000010";
                b <= n;
                c <= product1;
                d <= xn1;
                e <= "00000000";
                f <= "00000000";
                ra <= xn;
                rb <= product2;
                rc <= sum1;
                rd <= "00000000";
            --4xn + 2xn1 + 3xn2
            when "010" =>
                a <= "00000100";
                b <= xn;
                c <= "00000010";
                d <= xn1;
                e <= "00000011";
                f <= xn2;
                ra <= product1;
                rb <= product2;
                rc <= sum1;
                rd <= product3;
            --2xn - xn1 + 3yn1
            when "011" =>
                a <= "00000010";
                b <= xn;
                c <= "00000001";
                d <= (xn1 nand "11111111") + '1'; -- (-xn1)
                e <= "00000011";
                f <= yn1;
                ra <= product1;
                rb <= product2;
                rc <= sum1;
                rd <= product3;
            --xn*xn + xn1*xn1
            when "100" =>
                a <= xn;
                b <= xn;
                c <= xn1;
                d <= xn1;
                e <= "00000000";
                f <= "00000000";
                ra <= product1;
                rb <= product2;
                rc <= sum1;
                rd <= "00000000";
            --h0 * xn + h1 * xn1 + h2 *xn2 --TODO
            when "101" =>
                a <= "00000000";
                b <= "00000000";
                c <= "00000000";
                d <= "00000000";
                e <= "00000000";
                f <= "00000000";
                ra <= "00000000";
                rb <= "00000000";
                rc <= "00000000";
                rd <= "00000000";
            when "110" =>
                a <= "00000000";
                b <= "00000000";
                c <= "00000000";
                d <= "00000000";
                e <= "00000000";
                f <= "00000000";
                ra <= "00000000";
                rb <= "00000000";
                rc <= "00000000";
                rd <= "00000000";
            when "111" =>
                a <= "00000000";
                b <= "00000000";
                c <= "00000000";
                d <= "00000000";
                e <= "00000000";
                f <= "00000000";
                ra <= "00000000";
                rb <= "00000000";
                rc <= "00000000";
                rd <= "00000000";
            when others =>
                a <= "00000000";
                b <= "00000000";
                c <= "00000000";
                d <= "00000000";
                e <= "00000000";
                f <= "00000000";
                ra <= "00000000";
                rb <= "00000000";
                rc <= "00000000";
                rd <= "00000000";
        end case;
   end if;
end process;
--TODO: implement w reset, clk

end Behavioral;
