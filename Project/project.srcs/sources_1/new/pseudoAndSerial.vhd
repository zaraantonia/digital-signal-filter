library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pseudoAndSerial is
--  Port ( );
end pseudoAndSerial;

architecture Behavioral of pseudoAndSerial is

component pseudoRandomGenerator is
    Port ( clk : in STD_LOGIC;
           nr : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component UART_controller is

    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        tx_enable        : in  std_logic;

        data_in          : in  std_logic_vector (7 downto 0);
        data_out         : out std_logic_vector (7 downto 0);

        rx               : in  std_logic;
        tx               : out std_logic
        );
end component;

begin


end Behavioral;
