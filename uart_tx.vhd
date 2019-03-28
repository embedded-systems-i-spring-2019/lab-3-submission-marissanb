----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 11:30:47 AM
-- Design Name: 
-- Module Name: uart_tx - FSM
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity uart_tx is
    port (
    clk , en , send , rst : in std_logic ;
    char : in std_logic_vector (7 downto 0);
    ready , tx : out std_logic
);
end uart_tx ;

architecture FSM of uart_tx is
type state is (idle, start, data);
    signal PS : state := idle;
signal char_reg: std_logic_vector(7 downto 0);
signal counter: integer range 0 to 7;

begin

process (clk)
begin
    if rising_edge(clk) then

        if rst = '1' then

            PS <= idle;
            counter <= 0;
            char_reg <= (others => '0');
            tx <= '1';
            
        elsif en = '1' then
            case PS is

                when idle =>
                    ready <= '1';
                    if send = '1' then
                        char_reg <= char;
                        PS <= start;
                    end if;

                when start =>
                    tx <= '0';
                    counter <= 0;
                    PS <= data;

                when data =>
                    if counter <= 7 then
                        tx <= char_reg(counter);
                        counter <= counter + 1;
                    else
                        PS <= idle;
                    end if;

                when others =>
                    PS <= idle;

            end case;
        end if;

    end if;
    end process;


end FSM;
