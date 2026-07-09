library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity divAlgo is
	Port(
    	clk: in	std_logic;
        ld : in	std_logic;
        
        A,B : in std_logic_vector(15 downto 0);
        
		quociente : out std_logic_vector(15 downto 0);
       	resto : out std_logic_vector(15 downto 0); --nao sei se é para mostrar o resto não esta especificado
        
        error_zero : out std_logic;
        error_maior : out std_logic
    );
end divAlgo;

architecture div of divAlgo is
	
    component register_bank2 is
       port( 
    		clk: in std_logic;
    		
            we : in std_logic;
			address : in std_logic_vector(1 downto 0);
	
    		data_input : in std_logic_vector(15 downto 0);
            data_out : out std_logic_vector(15 downto 0);
            

			
            Output0, Output1, Output2, Output3, Output4: out std_logic_vector(0 to 6)

            );
	end component;
    
	----------------------------------------------
    
	signal VR : unsigned(15 downto 0); -- resto
	signal VQ : unsigned(15 downto 0); -- quociente
    
    
    signal input_Reg : std_logic_vector(15 downto 0) := (others => '0');
    signal out_Reg : std_logic_vector(15 downto 0) := (others => '0');
    
    signal out0,out1,out2,out3,out4 : std_logic_vector(0 to 6);
    signal write : std_logic := '0';
    signal add : std_logic_vector(1 downto 0);
    signal but_previous : std_logic := '1';
    
    ----------- ESTADOS -----------
    
    type state_type is	(
		estado_seting,
		estado_escrever_A,
        estado_espera_B,
        estado_escrever_B,
        estado_zera_Q,
        estado_div_zero,
        estado_escrever_RESTO,
        estado_escrever_QUOCIENTE,
        estado_loop_sub,
        estado_loop_inc,
        estado_final
    );
    signal estado_atual : state_type := IDLE;
    
    --------------------------------
    begin
    	banco_reg : register_bank2
        	port map(
			clk => clk,
			we => write,
            address => add,
            data_input => input_Reg,
            data_out => out_Reg,
            Output0 => out0,
            Output1 => out1,
            Output2 => out2,
            Output3 => out3,
            Output4 => out4
            );
    
    	process(clk)
        	begin
            	if(rising_edge(clk)) then
                	write <= '0';
               		but_previous <= ld;
                    
                    case estado_atual is
                    	when estado_seting =>
                        	error_zero <= '0';
                            error_maior <= '0';
                            VQ <= (others => '0'); -- zera o quociente
                            
                            if(but_previous = '1' and ld = '0') then
                            	input_Reg <= A;
                                add <= "00";
                            	estado_atual <= estado_escrever_A;
                            end if;
                            
                      	when estado_escrever_A =>
                       	 	add <= "00";
                            input_Reg <= A;
                            write <= '1';
                          	estado_atual <= estado_espera_B;
                        
                       	when estado_espera_B =>
                    		if(but_previous = '1' and ld = '0') then
                            	input_Reg <= B;
                            	estado_atual <= estado_escrever_B;
                            end if;
                        
                        when estado_escrever_B =>
    						add <= "01";
                            input_Reg <= B;
                            write <= '1';

                            estado_atual <= estado_div_zero;
                            
                        when estado_div_zero =>
                        	if unsigned(B) = '0' then
                            	error_zero <= '1';
                                if(but_previous = '1' and ld = '0') then
                                	estado_atual <= estado_seting;
                            	end if;
                            elsif unsigned(A) < unsigned(B) then
                            	error_maior <= '1';
                                if(but_previous = '1' and ld = '0') then
                                	estado_atual <= estado_seting;
                            	end if;
                            else
                            	estado_atual <= estado_zera_Q;
                             
                            end if;
                            
						when estado_zera_Q =>
                          	add <= "10";
                          	input_Reg <= x"0000";
                          	write <= '1';

                          	estado_atual <= estado_subtracao;
                        	
						when estado_loop_sub =>

                		add <= "00";


                		if(unsigned(out_Reg) = 0) then

                   			estado_atual <= estado_final;


                		elsif(unsigned(out_Reg) < unsigned(B)) then

                    		estado_atual <= estado_final;


                		else
                	
                    		add <= "00";
                    		input_Reg <= std_logic_vector(unsigned(out_Reg) - unsigned(B));
                   		 	write <= '1';
                            
                    		estado_atual <= estado_loop_inc;


                		end if;

                        	
                        when estado_loop_inc =>
							add <= "10";
                          	input_Reg <= std_logic_vector(unsigned(out_Reg) + 1);
                          	write <= '1';

                          	estado_atual <= estado_subtracao;
                        
                        when estado_final =>
                			quociente <= out_Reg;

                			estado_atual <= estado_seting;



           				when others =>

                			estado_atual <= estado_setting;
								
                 
            		end case;
                
                
                end if;
                
    	end process;
        
    end div;
    	
        
