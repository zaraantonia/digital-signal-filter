library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity filters is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           new_input: in std_logic;
           filterSelect : in STD_LOGIC_VECTOR (1 downto 0);
           overflow: out std_logic;
           reset: in std_logic);
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
signal rc, rd, sum2, sum2n1: std_logic_vector(7 downto 0) := (others => '0');
signal cout2: std_logic := '0';

--input states
signal xn, xn1, xn2, xn3, xn4: std_logic_vector(7 downto 0) := (others => '0');
--output states
signal yn, yn1: std_logic_vector(7 downto 0) := (others => '0');

--counter for n
signal n: std_logic_vector(7 downto 0) := "00000000";

--signal for 010 filter, pipeline issues
signal xn2_pipeline: std_logic_vector(7 downto 0) := "00000000";
signal xn2_pipeline_en: std_logic := '0';

--signal for 001 filter, pipeline issues
signal xn1_pipeline_001: std_logic_vector(7 downto 0) := "00000000";
signal xn1_pipeline_001_en: std_logic := '0';

--signal for 001 filter, pipeline issues
signal yn_pipeline_011: std_logic_vector(7 downto 0) := "00000001";
signal yn_pipeline_011_en: std_logic := '1';

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
        if reset = '1' then
            xn2_pipeline <= (others => '0');
            xn1_pipeline_001 <= (others => '0');
            xn4 <= (others => '0');
            xn3 <= (others => '0');
            xn2 <= (others => '0');
            xn1 <= (others => '0');
            xn <= (others => '0');
            yn1 <= (others => '0');
            yn <= (others => '0');
            n <= (others => '0');
            y <= (others => '0');
        elsif new_input = '1' then
            if xn2_pipeline_en = '1' then
                xn2_pipeline <= xn2;
            end if;
            if xn1_pipeline_001_en = '1' then
                xn1_pipeline_001 <= xn;
            end if;
            xn4 <= xn3;
            xn3 <= xn2;
            xn2 <= xn1;
            xn1 <= xn;
            xn <= x;
            yn1 <= yn;
            n <= n + '1';
            yn <= sum2;
            y <= yn;
        end if;
    end if;
end process;

--any overflow from any component signals an error in calculation
overflow <= of1 or of2 or of3 or cout2;

--process for selecting operands for arithmetical components
process(filterSelect,clk)
begin
    if rising_edge(clk) then
    if new_input = '1' then
        case filterSelect is
            --2xn + 3xn1
            when "00" =>
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
                xn2_pipeline_en <= '0';
                xn1_pipeline_001_en <= '0';
                yn_pipeline_011_en <= '0';
            --xn + 2*n*xn1
            when "01" =>
                a <= "00000010";
                b <= n;
                c <= product1;
                d <= xn1;
                e <= "00000000";
                f <= "00000000";
                ra <= xn1_pipeline_001;
                rb <= product2;
                rc <= sum1;
                rd <= "00000000";
                xn2_pipeline_en <= '0';
                xn1_pipeline_001_en <= '1';
                yn_pipeline_011_en <= '0';
            --4xn + 2xn1 + 3xn2
            when "10" =>
                a <= "00000100";
                b <= xn;
                c <= "00000010";
                d <= xn1;
                e <= "00000011";
                f <= xn2_pipeline;
                ra <= product1;
                rb <= product2;
                rc <= sum1;
                rd <= product3;
                xn2_pipeline_en <= '1';
                xn1_pipeline_001_en <= '0';
                yn_pipeline_011_en <= '0';
            --xn*xn + xn1*xn1
            when "11" =>
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
                xn2_pipeline_en <= '0';
                xn1_pipeline_001_en <= '0';
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
                xn2_pipeline_en <= '0';
                xn1_pipeline_001_en <= '0';
        end case;
   end if;
   end if;
end process;

end Behavioral;
