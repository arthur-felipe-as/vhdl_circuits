library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

 entity maqCafe is 
 PORT(
 botoes: in std_logic_vector(2 downto 0);
 	saidas: out std_logic_vector(7 downto 0) 
 );
 end maqCafe;

 architecture behavior of maqCafe is
 begin
	process(botoes) begin
 	case botoes is
 		when "001" => saidas <= "00000001";
	 	when "010" => saidas <= "00000010";
	 	when "011" => saidas <= "00000011";
	 	when "100" => saidas <= "00000100";
	 	when "101" => saidas <= "00000101";
	 	when "110" => saidas <= "00000110";
	 	when "111" => saidas <= "00000111";
	 	when "000" => saidas <= "00001000";
	 	when others => saidas <= "00000000";
 	end case;
 	end process;
 end behavior;
