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
    		ld: in std_logic;

            Input : in std_logic_vector(15 downto 0);
            op : in std_logic;

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

constant escrever : std_logic := '0';

constant ler : std_logic := '1';



constant estado_op : std_logic_vector := "000";

constant estado_end : std_logic_vector := "001";

constant estado_escrever : std_logic_vector := "010";

constant estado_ler : std_logic_vector := "011";

constant estado_espera : std_logic_vector := "100";



signal estado_atual : std_logic_vector(2 downto 0) := estado_espera;

signal operator : std_logic := '0';

signal address : std_logic_vector(2 downto 0) := "000";

signal bt_previous : std_logic := '1';



----------



signal reg0 : std_logic_vector(15 downto 0) := (others => '0');

signal reg1 : std_logic_vector(15 downto 0) := (others => '0');

signal reg2 : std_logic_vector(15 downto 0) := (others => '0');

signal reg3 : std_logic_vector(15 downto 0) := (others => '0');

signal reg4 : std_logic_vector(15 downto 0) := (others => '0');

signal reg5 : std_logic_vector(15 downto 0) := (others => '0');

signal reg6 : std_logic_vector(15 downto 0) := (others => '0');

signal reg7 : std_logic_vector(15 downto 0) := (others => '0');



---------------------

signal reset_regs : std_logic := '1';

signal display_data: std_logic_vector(15 downto 0) := (others => '0');



signal use_output0 : std_logic := '0';



signal display7_output0 : std_logic_vector(0 to 6) := (others => '0');

signal output0_normal : std_logic_vector(0 to 6) := (others => '0');

begin



process(clk)

	variable button_pressed : boolean;

begin
    
	if(rising_edge(clk)) then
   
    	 button_pressed := false;

		if bt_previous = '1' and ld = '0' then
    		button_pressed := true;
		end if;
    
        
        if reset_regs = '1' then
            reg0 <= (others => '0');
            reg1 <= (others => '0');
            reg2 <= (others => '0');
            reg3 <= (others => '0');
            reg4 <= (others => '0');
            reg5 <= (others => '0');
            reg6 <= (others => '0');
            reg7 <= (others => '0');
            reset_regs <= '0';
        end if;

        case estado_atual is

            when estado_espera =>
                use_output0 <= '1';
                display_data <= (others => '0');
                Output4 <= "0000001";
                
                if button_pressed then
                    estado_atual <= estado_op;
                end if;

            when estado_op =>
                use_output0 <= '0';
                display_data(15 downto 8) <= (others => '0');
                Output4 <= "1100010"; -- O
                
                operator <= op;

                if op = escrever then
                    output0_normal <= "0110000"; -- E
                else
                    output0_normal <= "1110001"; -- L
                end if;

                if button_pressed then
                    estado_atual <= estado_end;
                end if;

            when estado_end =>
                use_output0 <= '1';
                Output4 <= "0001000"; -- A

                display_data(2 downto 0) <= Input(2 downto 0);
                display_data(15 downto 3) <= (others => '0');

                address <= Input(2 downto 0);

                if button_pressed then
                    if operator = escrever then
                        estado_atual <= estado_escrever;
                    else
                        estado_atual <= estado_ler;
                    end if;
                end if;

            when estado_escrever =>
                use_output0 <= '1';
                Output4 <= "0110000"; -- E

                display_data <= Input;

                if button_pressed then
                    case address is
                        when "000" => reg0 <= Input;
                        when "001" => reg1 <= Input;
                        when "010" => reg2 <= Input;
                        when "011" => reg3 <= Input;
                        when "100" => reg4 <= Input;
                        when "101" => reg5 <= Input;
                        when "110" => reg6 <= Input;
                        when "111" => reg7 <= Input;
                        when others => null;
                    end case;

                    estado_atual <= estado_espera;
                end if;

            when estado_ler =>
                use_output0 <= '1';
                Output4 <= "1110001"; -- L

                case address is
                    when "000" => display_data <= reg0;
                    when "001" => display_data <= reg1;
                    when "010" => display_data <= reg2;
                    when "011" => display_data <= reg3;
                    when "100" => display_data <= reg4;
                    when "101" => display_data <= reg5;
                    when "110" => display_data <= reg6;
                    when "111" => display_data <= reg7;
                    when others => display_data <= (others => '0');
                end case;

                if button_pressed then
                    estado_atual <= estado_espera;
                end if;

            when others =>
                estado_atual <= estado_espera;

        end case;
        
        bt_previous <= ld;
        	
	end if;
end process;


     led0 : display7 port map(display_data(3 downto 0), display7_output0);



    led1 : display7 port map(display_data(7 downto 4), Output1);



    led2 : display7 port map(display_data(11 downto 8), Output2);

          

    led3 : display7 port map(display_data(15 downto 12), Output3);

    

    Output0 <= output0_normal when (use_output0 = '0') else display7_output0; 



end bank;





