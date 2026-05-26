library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


--Displlay dos botoes, numeros
entity display7_num is
Port(
    hex: in std_logic_vector(2 downto 0);
    d7: out std_logic_vector(0 to 6) --  8 1 2 4 5 6 7
);
end display7_num;

architecture behavior1 of display7_num is
    signal normal_d7: std_logic_vector(0 to 6);
begin
    
    process(hex)
        begin
            case hex is
                when "000" => normal_d7 <= "1111111"; -- 8
                when "001" => normal_d7 <= "0110000"; -- 1
                when "010" => normal_d7 <= "1101101"; -- 2
                when "011" => normal_d7 <= "1111001"; -- 3
                when "100" => normal_d7 <= "0110011"; -- 4
                when "101" => normal_d7 <= "1011011"; -- 5
                when "110" => normal_d7 <= "1011111"; -- 6
                when "111" => normal_d7 <= "1110000"; -- 7
                when others => normal_d7 <= "0000000"; -- Desligado
            end case;
    end process;
	d7 <= not normal_d7;
end behavior1;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Display dos cafes (letras)
entity display7_char is
Port(
	hex: in std_logic_vector(2 downto 0);
    d7: out std_logic_vector(0 to 6) --  a b c d e f g h
);
end display7_char;

architecture behavior2 of display7_char is
signal normal_d7: std_logic_vector(0 to 6);

begin
	process(hex)
    	begin
        	case hex is
                when "001" => normal_d7 <= "1110111"; -- A
                when "010" => normal_d7 <= "0011111"; -- B
                when "011" => normal_d7 <= "1001110"; -- C
                when "100" => normal_d7 <= "0111101"; -- D
                when "101" => normal_d7 <= "1001111"; -- E
                when "110" => normal_d7 <= "1000111"; -- F
              	when "111" => normal_d7 <= "1011110"; -- G
              	when "000" => normal_d7 <= "0110111"; -- H
              	when others => normal_d7 <= "0000000"; -- Desligado
			end case;
	end process;
	d7 <= not normal_d7;
end behavior2;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity maqCafe is 
PORT(
    botoes: in std_logic_vector(0 to 7);
    saida_input: out std_logic_vector(0 to 6);
    saida_output: out std_logic_vector(0 to 6));
end maqCafe;

architecture behavior of maqCafe is
	component display7_num is
	Port(
    	hex: in std_logic_vector(2 downto 0);
    	d7: out std_logic_vector(0 to 6)); --  8 1 2 4 5 6 7
	end component;

	component display7_char is
	Port(
		hex: in std_logic_vector(2 downto 0);
    	d7: out std_logic_vector(0 to 6)); --  a b c d e f g h
	end component;

	signal disp_in, disp_out: std_logic_vector(0 to 6);

	signal botoes_bin: std_logic_vector(2 downto 0);
	signal enable_display: std_logic;
    
	begin
	process(botoes)
	begin
	enable_display <= '1';
	case botoes is
		when "00000001" => botoes_bin <= "001";
		when "00000010" => botoes_bin <= "010";
		when "00000100" => botoes_bin <= "011";
		when "00001000" => botoes_bin <= "100";
		when "00010000" => botoes_bin <= "101";
		when "00100000" => botoes_bin <= "110";
		when "01000000" => botoes_bin <= "111";
		when "10000000" => botoes_bin <= "000";
		when others => 
						botoes_bin <= "000";
						enable_display <= '0';
		end case;
	end process;
	mostrar_entrada : display7_num port map (botoes_bin, disp_in);
	mostrar_saida : display7_char port map (botoes_bin, disp_out);
	
	saida_input  <= "1111110" when enable_display = '0' else disp_in;
    saida_output <= "1111110" when enable_display = '0' else disp_out;
 end behavior;
