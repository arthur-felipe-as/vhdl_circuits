library IEEE;
use IEEE.std_logic_1164.all;

entity display7 is
Port(
	hex: in std_logic_vector(3 downto 0);
    d7: out std_logic_vector(6 downto 0) --  a b c d e f g
);
end display7;

architecture behavior of display7 is
begin
	process(hex)
    	begin
        	case hex is
            	when "0000" => d7 <= "1111110"; -- 0
				when "0001" => d7 <= "0110000"; -- 1
                when "0010" => d7 <= "1101101"; -- 2
                when "0011" => d7 <= "1111001"; -- 3
                when "0100" => d7 <= "0110011"; -- 4
                when "0101" => d7 <= "1011011"; -- 5
                when "0110" => d7 <= "1011111"; -- 6
                when "0111" => d7 <= "1110000"; -- 7
                when "1000" => d7 <= "1111111"; -- 8
                when "1001" => d7 <= "1111011"; -- 9
                
                when "1010" => d7 <= "1110111"; -- A
                when "1011" => d7 <= "0011111"; -- B
                when "1100" => d7 <= "1001110"; -- C
                when "1101" => d7 <= "0111101"; -- D
                when "1110" => d7 <= "1001111"; -- E
                when "1111" => d7 <= "1000111"; -- F
              	when others => d7 <= "0000000"; -- Desligado
                
			end case;
	end process;
end behavior;