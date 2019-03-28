----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2019 09:26:18 PM
-- Design Name: 
-- Module Name: top_level - structural
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_level is
  Port ( 
        TXD, clk: in std_logic;
        btn: in std_logic_vector(1 downto 0);
        CTS, RTS: out std_logic:= '0';
        RXD: out std_logic
  );
end top_level;

architecture structural of top_level is

signal dbnc1: std_logic;
signal dbnc2: std_logic;
signal div: std_logic;
signal ready: std_logic;
signal char_out: std_logic_vector(7 downto 0);
signal send_out: std_logic;

component clock_div port
(
    clk : in std_logic;
    div : out std_logic
   );
end component;
component debounce port
(
    btn: in std_logic;
    clk: in std_logic;
    dbnc: out std_logic
  );
end component;
component sender port
(
    rst, en, btn, rdy, clk: in std_logic;
    send: out std_logic;
    char: out std_logic_vector(7 downto 0)
  );
end component;
component uart port
(
    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)
);
end component;

begin

    u1: debounce port map(
        btn => btn(0),
        clk => clk,
        dbnc => dbnc1);
    u2: debounce port map(
        btn => btn(1),
        clk => clk,
        dbnc => dbnc2);
    u3: clock_div port map(
        clk => clk,
        div => div);
    u4: sender port map(
        btn => dbnc2,
        clk => clk,
        en => div,
        rdy => ready,
        rst => dbnc1,
        char => char_out,
        send => send_out);
    u5: uart port map(
        charSend => char_out,
        clk => clk,
        en => div,
        rst => dbnc1,
        rx => TXD,
        send => send_out,
        ready => ready,
        tx => RXD);
         

end structural;
