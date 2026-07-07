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
                when others => normal_d7 <= "0000000"; -- ERROR
			end case;
            
	end process;
	d7 <= not normal_d7; --acender = nivel logico baixo
end behavior;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY media_aritmetica IS
	Port(
      clk, ld, ld2 : in std_logic;
    switches : in std_logic_vector(15 downto 0);

    d0,d1,d2,d3,d4 : out std_logic_vector(0 to 6);
    led : out std_logic;

    debug_output : out std_logic_vector(15 downto 0)
    	
   	);
    
end media_aritmetica;

architecture behavior of media_aritmetica is

component display7 is
	Port(
		hex: in std_logic_vector(3 downto 0);
		d7: out std_logic_vector(0 to 6)
	);
   end component;


-- signals e constantes:
constant initial_state : unsigned(15 downto 0) := to_unsigned(16#FFFF#,16);
constant X : unsigned(15 downto 0) := to_unsigned(4333,16); -- Quatro ultimos digitos  da matricula de Arthur. 

signal Y_reg : unsigned(15 downto 0);

signal media : unsigned(15 downto 0);

signal soma : unsigned(16 downto 0);


--estados:

constant mostrar_xy : std_logic_vector(1 downto 0) := "00";
constant recebe_y : std_logic_vector(1 downto 0) := "01"; 
constant mostrar_media : std_logic_vector(1 downto 0) := "10";
constant esperar : std_logic_vector(1 downto 0) := "11";

signal estado_atual : std_logic_vector(1 downto 0) := esperar;

--fim dos estados

signal display_output : unsigned (15 downto 0 );

--fim dos singals e constantes



begin

soma <= resize(X,17) + resize(Y_reg,17);

media <= soma(16 downto 1);

process(clk)
begin
	if(rising_edge(clk)) then
    	case estado_atual is
        	when recebe_y =>
            	led <= '0';
                
                
                if ld = '0' then
                	Y_reg <= unsigned(switches);
                    estado_atual <= mostrar_media;
                end if;
            
            when mostrar_xy =>
            	led <= '0';
                if ld = '0' then
                	estado_atual <= recebe_y;
                end if;
                
			when mostrar_media =>
            
            	led <= '1';
                
                if ld = '0' then
                	estado_atual <= esperar;
				end if;
                
			when esperar =>
            	led <= '0';
                
                if ld2 = '0' then
                	estado_atual <= mostrar_xy;
				end if;
               
            when others =>
            
            	estado_atual <= esperar;
                
            end case;
            
    end if;
end process;

with estado_atual select
	display_output <= 
		X when mostrar_xy,
        Y_reg when recebe_y,	
        media when mostrar_media,
        initial_state when esperar,
        X when others;


d0_display : display7 port map("1010",d0);


d1_display : display7
port map(std_logic_vector(display_output(3 downto 0)),d1);

d2_display : display7
port map(std_logic_vector(display_output(7 downto 4)),d2);

d3_display : display7
port map(std_logic_vector(display_output(11 downto 8)),d3);

d4_display : display7
port map(std_logic_vector(display_output(15 downto 12)),d4);
	debug_output <= std_logic_vector(display_output);
end behavior;
