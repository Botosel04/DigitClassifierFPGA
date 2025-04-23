----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2025 07:08:52 PM
-- Design Name: 
-- Module Name: TOP - Behavioral
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
use work.Types.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TOP is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           reset: in STD_LOGIC;
           leds : out STD_LOGIC_VECTOR (15 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end TOP;

architecture Behavioral of TOP is

component mpg is
 port (
 clk : in std_logic;
 btn1 : in std_logic;
 enable : out std_logic

 );
end component;

component Layer is
  generic (
    input_size  : positive := 784;
    output_size : positive := 128
  );
  port (
    clk           : in  std_logic;
    reset         : in  std_logic;
    start         : in  std_logic;
    input_weights : in  vector_t(0 to input_size*output_size-1);
    input_bias    : in  vector_t(0 to output_size-1);
    input_vector  : in  vector_t(0 to input_size-1);
    output_vector : out vector_t(0 to output_size-1);
    output_ready  : out std_logic
  );
end component;

signal button: std_logic;
signal start : std_logic := '0';
signal input_neurons: vector_t(0 to 783);
signal l1_weights: vector_t(0 to 100352);
signal l1_bias: vector_t(0 to 128) := (-21, 20);


signal l1_output_neurons: vector_t(0 to 128);
signal l2_weights: vector_t(0 to 100352);
signal l2_bias: vector_t(0 to 128);
signal l2_output_neurons: vector_t(0 to 128);

begin
label0: mpg port map(clk, btn, button);
layer1: Layer port map(clk, reset, '1', l1_weights, l1_bias, input_neurons, l1_output_neurons, start);
layer2: Layer generic map(128, 128) port map(clk, reset, start,l2_weights, l2_bias, l1_output_neurons, l2_output_neurons, start);


end Behavioral;
