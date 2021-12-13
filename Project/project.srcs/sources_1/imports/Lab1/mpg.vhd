----------------------------------------------------------------------------------
-- Company: UTCN
-- Engineer: Zara Antonia-Maria
-- Create Date: 02/27/2021 05:12:57 PM

-- Title: Mono Pulse Generator
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
    Port(clk: in std_logic;
        enable: out std_logic;
        btn : in std_logic);
end mpg;

architecture Behavioral of mpg is

signal count: std_logic_vector(15 downto 0) := "0000000000000000";
signal en: std_logic;
signal Q1,Q2,Q3: std_logic;

begin

counter: process(clk)
begin
    if(rising_edge(clk)) then
        if(count = "1111111111111111") then
            en <= '1';
            count <= "0000000000000000";
         else
            en <= '0';
            count <= count + 1;
         end if;
     end if;
 end process;
 
 first_register: process(clk)
 begin
    if(rising_edge(clk)) then
        if(en = '1') then
            Q1 <= btn;
        end if;
    end if;
 end process;
 
 other_registers: process(clk)
 begin
    if(rising_edge(clk)) then
        Q2 <= Q1;
        Q3 <= Q2;
     end if;
  end process;
  
 --signals whose change does not depend on clock are not included in processes
 
enable <= (not Q3) and Q2;
    
end Behavioral;
