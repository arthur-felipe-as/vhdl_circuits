LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY register_bank IS
	port( clk,ld,op: in std_logic;
			address : in std_logic_vector(2 downto 0);
			write_input : in std_logic_vector(15 downto 0);
			operator_output : out std_logic_vector(0 to 6);
			content_output : out std_logic_vector(15 downto 0)
			);
end register_bank;

architecture bank of register_bank is
constant escrever : std_logic := '0';
constant ler : std_logic := '1';

constant estado_op : std_logic_vector := "00";
constant estado_end : std_logic_vector := "01";
constant estado_escrever : std_logic_vector := "10";
constant estado_ler : std_logic_vector := "11";

signal estado_atual : std_logic_vector(1 downto 0) := estado_op;
	component reg_paraleload is
	PORT ( I : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
			clk, ld : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) );
	END component;
begin

--- TODO: toda a logica lol

end bank;