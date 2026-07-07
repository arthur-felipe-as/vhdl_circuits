library IEEE;
use IEEE.std_logic_1164.all;

entity display7 is
Port(
	hex: in std_logic_vector(3 downto 0);
    d7: out std_logic_vector(0 to 6) 
);
end display7;

architecture behavior of display7 is
signal normal_d7: std_logic_vector(0 to 6);
begin
	
	process(hex)
    	begin
        	case hex is
            	when "0000" => normal_d7 <= "1111110"; -- 0
				when "0001" => normal_d7 <= "0110000"; -- 1
                when "0010" => normal_d7 <= "1101101"; -- 2
                when "0011" => normal_d7 <= "1111001"; -- 3
                when "0100" => normal_d7 <= "0110011"; -- 4
                when "0101" => normal_d7 <= "1011011"; -- 5
                when "0110" => normal_d7 <= "1011111"; -- 6
                when "0111" => normal_d7 <= "1110000"; -- 7
                when "1000" => normal_d7 <= "1111111"; -- 8
                when "1001" => normal_d7 <= "1111011"; -- 9
                
                when "1010" => normal_d7 <= "1110111"; -- A
                when "1011" => normal_d7 <= "0011111"; -- B
                when "1100" => normal_d7 <= "1001110"; -- C
                when "1101" => normal_d7 <= "0111101"; -- D
                when "1110" => normal_d7 <= "1001111"; -- E
                when "1111" => normal_d7 <= "1000111"; -- F
			end case;
	end process;
	d7 <= not normal_d7; --acender = nivel logico baixo
end behavior;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;
ENTITY register_bank IS
	port( clk,ld: in std_logic;
			Input : in std_logic_vector(15 downto 0);
			Output0, Output1, Output2, Output3, Output4: out std_logic_vector(0 to 6)
			);
end register_bank;

architecture bank of register_bank is
component display7 is
	Port(
		hex: in std_logic_vector(3 downto 0);
		d7: out std_logic_vector(0 to 6)
	);
	end component;
constant escrever : std_logic := '0';
constant ler : std_logic := '1';

constant estado_op : std_logic_vector := "00";
constant estado_end : std_logic_vector := "01";
constant estado_escrever : std_logic_vector := "10";
constant estado_ler : std_logic_vector := "11";

signal estado_atual : std_logic_vector(1 downto 0) := estado_op;

signal operator : std_logic := '0';
signal address : std_logic_vector(2 downto 0) := "000";

type reg_array is array (7 downto 0) of std_logic_vector(15 downto 0);
signal regs : reg_array;
signal reset_regs : std_logic := '1';
signal display_data: std_logic_vector(15 downto 0) := (others => '0');

signal use_output0 : std_logic := '0';

signal display7_output0 : std_logic_vector(6 downto 0) := (others => '0');
signal output0_normal : std_logic_vector(6 downto 0) := (others => '0');
begin
process(clk, ld, Input)
begin
if(rising_edge(clk)) then
	if(reset_regs = '1') then
	regs <= (others => (others => '0'));
	reset_regs <= '0';
	end if;
	if (estado_atual = estado_op) then
		use_output0 <= '0';
		display_data(15 downto 8) <= (others => '0');
		Output4 <= "1100010"; --- o
		if (Input(0) = escrever) then
			output0_normal <= "0110000"; -- E
		else
			output0_normal <= "1110001"; -- L
		end if;
		if(ld = '0') then
			operator <= Input(0);
			estado_atual <= estado_end;
		end if;
		
	elsif(estado_atual = estado_end) then
		use_output0 <= '1';
		Output4 <= "0001000"; --- A
		display_data(2 downto 0) <= Input(2 downto 0);
		display_data(15 downto 3) <= (others => '0'); 
		if(ld = '0') then
			if(operator = escrever) then
				estado_atual <= estado_escrever;
			else 
				estado_atual <= estado_ler;
			end if;
			
		address <= Input(2 downto 0);
		end if;
	elsif(estado_atual = estado_escrever) then
		use_output0 <= '1';
		Output4 <= "0110000"; --- E
		display_data(15 downto 0) <= Input(15 downto 0);
		if(ld = '0') then
			regs(to_integer(unsigned(address))) <= Input;
			estado_atual <= estado_op;
		end if;
	elsif(estado_atual =  estado_ler) then
		use_output0 <= '1';
		Output4 <= "1110001"; -- L
		display_data <= regs(to_integer(unsigned(address)));
		if(ld = '0') then
			estado_atual <= estado_op;
		end if;
		
		
	
	end if;
end if;
end process;
	 led0 : display7 port map(display_data(3 downto 0), display7_output0);

    led1 : display7 port map(display_data(7 downto 4), Output1);

    led2 : display7 port map(display_data(11 downto 8), Output2);
		  
    led3 : display7 port map(display_data(15 downto 12), Output3);
	
	Output0 <= output0_normal when (use_output0 = '0') else display7_output0; 

end bank;