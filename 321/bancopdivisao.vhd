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
				when others => normal_d7 <= "0000000"; -- Error
            end case;

    end process;

    d7 <= not normal_d7; --acender = nivel logico baixo

end behavior;



LIBRARY ieee;

USE ieee.std_logic_1164.all;

use ieee.numeric_std.all;

ENTITY register_bank2 IS

    port( 
    		clk: in std_logic;
    		
            we : in std_logic;
			address : in std_logic_vector(1 downto 0);
	
    		data_input : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0);
            

			
            Output0, Output1, Output2, Output3, Output4: out std_logic_vector(0 to 6)

            );

end register_bank2;



architecture bank of register_bank2 is

component display7 is

    Port(

        hex: in std_logic_vector(3 downto 0);

        d7: out std_logic_vector(0 to 6)

    );

    end component;


----------



signal reg0 : std_logic_vector(15 downto 0) := (others => '0');

signal reg1 : std_logic_vector(15 downto 0) := (others => '0');

signal reg2 : std_logic_vector(15 downto 0) := (others => '0');


---------------------

signal display_data: std_logic_vector(15 downto 0) := (others => '0');
signal display7_output0 : std_logic_vector(0 to 6) := (others => '0');

begin



process(clk)


begin
    
if(rising_edge(clk)) then
    
	if we='1' then
		case address is
            
			when "00" => reg0 <= data_input;
			when "01" => reg1 <= data_input;
  			when "10" => reg2 <= data_input;
  			when others => null;

   		end case;
        
	end if;
        	
end if;

end process;

--ler
process(address, reg0, reg1, reg2)
begin
    
    case address is
        
        when "00" =>
            data_out <= reg0;
            
        when "01" =>
            data_out <= reg1;
            
        when "10" =>
            data_out <= reg2;
            
        when others =>
            data_out <= (others => '0');
            
    end case;
    
end process;



	display_data <= data_out;

    led0 : display7 port map(display_data(3 downto 0), display7_output0);



    led1 : display7 port map(display_data(7 downto 4), Output1);



    led2 : display7 port map(display_data(11 downto 8), Output2);

          

    led3 : display7 port map(display_data(15 downto 12), Output3);

    
	Output0 <= display7_output0;

end bank;
