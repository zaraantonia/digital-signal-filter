library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;



entity UART_transceiver is

    port(
        clk            : in  std_logic;
        reset          : in  std_logic;
        tx_start       : in  std_logic;
        ovf           : out  std_logic;
        data_in        : in  std_logic_vector (7 downto 0);
        data_out       : out std_logic_vector (7 downto 0);

        rx             : in  std_logic;
        tx             : out std_logic
        );
end UART_transceiver;


architecture Behavioral of UART_transceiver is

    component UART_tx
        port(
            clk            : in  std_logic;
            reset          : in  std_logic;
            tx_start       : in  std_logic;
            tx_data_in     : in  std_logic_vector (7 downto 0);
            tx_data_out    : out std_logic
            );
    end component;


    component UART_rx
        port(
            clk            : in  std_logic;
            reset          : in  std_logic;
            rx_data_in     : in  std_logic;
            rx_data_out    : out std_logic_vector (7 downto 0)
            );
    end component;
    
    component filters is
    Port ( x : in STD_LOGIC_VECTOR (7 downto 0);
           y : out STD_LOGIC_VECTOR (7 downto 0);
           clk : in STD_LOGIC;
           new_input: in std_logic;
           filterSelect : in STD_LOGIC_VECTOR (2 downto 0);
           overflow: out std_logic);
end component;

signal y: STD_LOGIC_VECTOR (7 downto 0);
signal filterSelect : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal c_input: std_logic_vector(7 downto 0) := (others => '0');

begin

    transmitter: UART_tx
    port map(
            clk            => clk,
            reset          => reset,
            tx_start       => tx_start,
            tx_data_in     => y,
            tx_data_out    => tx
            );


    receiver: UART_rx
    port map(
            clk            => clk,
            reset          => reset,
            rx_data_in     => rx,
            rx_data_out    => c_input
            );
            
   flt: filters port map (x => c_input, y => y, clk => clk, filterSelect => filterSelect, overflow => ovf, new_input => tx_start);

    data_out <= y;
    
end Behavioral;