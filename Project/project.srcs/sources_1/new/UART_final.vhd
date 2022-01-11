library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity UART_final is

    port(
        clk              : in  std_logic;
        reset            : in  std_logic;
        tx_enable        : in  std_logic;
        ovf           : out  std_logic;
        data_in          : in  std_logic_vector (7 downto 0);
        data_out         : out std_logic_vector (7 downto 0);
        filter_select    : in std_logic_vector (1 downto 0);
        rx               : in  std_logic;
        tx               : out std_logic
        );
end UART_final;


architecture Behavioral of UART_final is

    component button_debounce
        port(
            clk        : in  std_logic;
            reset      : in  std_logic;
            button_in  : in  std_logic;
            button_out : out std_logic
            );
    end component;


    component UART_transceiver
        port(
            clk            : in  std_logic;
            reset          : in  std_logic;
            tx_start       : in  std_logic;
            ovf           : out  std_logic;
            data_in        : in  std_logic_vector (7 downto 0);
            data_out       : out std_logic_vector (7 downto 0);
            filter_select    : in std_logic_vector (1 downto 0);
            rx             : in  std_logic;
            tx             : out std_logic
            );
    end component;

    signal button_pressed : std_logic;

begin

    tx_button_controller: button_debounce
    port map(
            clk            => clk,
            reset          => reset,
            button_in      => tx_enable,
            button_out     => button_pressed
            );

    uart: UART_transceiver
    port map(
            clk            => clk,
            reset          => reset,
            tx_start       => button_pressed,
            data_in        => data_in,
            data_out       => data_out,
            rx             => rx,
            tx             => tx,
            ovf           => ovf,
            filter_select => filter_select
            );

end Behavioral;