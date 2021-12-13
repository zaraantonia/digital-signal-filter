library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity fsm_hw is
    Port ( clk : in std_logic;
           btnL : in std_logic;
		   btnC :in std_logic;
           sw : in std_logic_vector(7 downto 0);
		   btnR : in std_logic;
		   --tx : out std_logic;
           --tx_rdy : out std_logic);
           led: out std_logic_vector(1 downto 0));
end fsm_hw;

architecture Behavioral of fsm_hw is

component mpg is
    Port(clk: in std_logic;
        enable: out std_logic;
        btn : in std_logic);
end component;

signal tx_data: std_logic_vector (7 downto 0);
signal bit_cnt:std_logic_vector(2 downto 0);   
type state_type is (idle, start, bit_state, stop);
signal state : state_type;
signal rst: std_logic;
signal tx_en: std_logic;
signal tx,tx_rdy,baud_en: std_logic;

 
begin

btnCmpg: mpg port map(clk => clk, enable => tx_en, btn => btnC);
btnRmpg: mpg port map(clk => clk, enable => rst, btn => btnR);
btnLmpg: mpg port map(clk => clk, enable => baud_en, btn => btnL);

--baud_en <= btnL;
tx_data <= sw;
--rst <= btnR;
--tx_en <= btnC;

state_change:process (clk,rst,tx_en)
begin
    if (rst ='1') then
           state <=idle;
    elsif (clk='1' and clk'event ) then
        if baud_en='1' then
			case state is
				when start => state <= bit_state; 
				when bit_state =>  if (bit_cnt < "111") then
											  state <= bit_state;
											  bit_cnt <= bit_cnt+1;
									   else
											  state <= stop;
									   end if;
				when idle => if (tx_en = '1') then
									state <= start;
									bit_cnt<="000";
								else
									state <= idle;
						   end if;
				when others =>  state <= idle;   
			end case;
        end if;
    end if;
end process;

variable_change:process(state)
begin
    case state is
        when idle => tx<='1'; tx_rdy<='1';
        when start => tx<='0'; tx_rdy<='0';
        when bit_state => tx<=tx_data(conv_integer(bit_cnt)); tx_rdy<='0';
        when others => tx<='1'; tx_rdy<='0';
    end case;
end process;

led <= tx & tx_rdy;

end Behavioral;
