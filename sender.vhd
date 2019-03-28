----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 08:31:42 PM
-- Design Name: 
-- Module Name: sender - fsm
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

entity sender is
  Port ( 
        rst, en, btn, rdy, clk: in std_logic;
        send: out std_logic;
        char: out std_logic_vector(7 downto 0)
  );
end sender;

architecture fsm of sender is
type char_ar is array (0 to 4) of std_logic_vector(7 downto 0);
    signal NETID: char_ar;
    
type state is (idle, busyA, busyB, busyC);
    signal PS : state := idle; 
signal i: std_logic_vector(3 downto 0):=(others => '0');
signal j: integer;

begin

NETID(0 to 4) <= (0=> "01101101", 1=> "01101110", 2=> "00110101", 3=> "00110111", 4=> "00110000");

FSM: process (clk)
begin
    if rising_edge(clk) and en = '1' then
        if rst = '1' then
            send <= '0';
            char <= (others => '0');
            i <= (others => '0');
            PS <= idle;
        elsif rdy = '1' and btn = '1' then
            if unsigned(i) < 5 then
                send <= '1';
                j <= to_integer(unsigned(i));
                char <= NETID(j);
                i <= std_logic_vector(unsigned(i) + 1);
                PS <= busyA;
            elsif unsigned(i) = 5 then
                i <= (others => '0');
                PS <= idle;
            end if;
        else
            case PS is
                when busyA =>
                    PS <= busyB;
                when busyB =>
                    send <= '0';
                    PS <= busyC;
                when busyC =>
                    if rdy = '1' and btn = '0' then
                        PS <= idle;
                    end if;
                when others =>
                    PS <= idle;
            end case;
        end if;
    end if;
end process FSM;

end fsm;
