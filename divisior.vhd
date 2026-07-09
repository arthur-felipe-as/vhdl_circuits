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
    		ld: in std_logic;

            Input : in std_logic_vector(15 downto 0);
            op : in std_logic;

            Output0, Output1, Output2, Output3, Output4: out std_logic_vector(0 to 6)
		);
	end component;
    
	--------------
    
    signal VA, VB, VQ, VR : std_logic_vector(15 downto 0) := (others => '0');
    
    
    signal ld_Reg : std_logic := '1';
    signal input_Reg : std_logic_vector(15 downto 0) := (others => '0');
    signal op_Reg : std_logic_vector := '0';
    
    signal out0,out1,out2,out3,out4 : std_logic_vector(0 to 6);
    
    signal estado_atual : std_logic_vector(2 downto 0) := "000";
	
    signal but_previous : std_logic := '1';
    
    signal step_counter : integer range 0 to 7 := 0;
    -----------
    
    constant estado_seting : std_logic_vector(2 downto 0) := "000";
    constant estado_escrever_A : std_logic_vector(2 downto 0) := "001";
    constant estado_escrever_B : std_logic_vector(2 downto 0) := "010";
    constant estado_espera_B : std_logic_vector(2 downto 0) := "111";
    constant estado_ler_A : std_logic_vector(2 downto 0) := "011";
    constant estado_subtracao : std_logic_vector(2 downto 0) := "100";
	constant estado_erro_maior : std_logic_vector(2 downto 0) := "101";
	constant estado_erro_zero : std_logic_vector(2 downto 0) := "110";
    
    begin
    	banco_reg : register_bank2
        	port map(
			clk => clk,
            ld => ld_Reg,
            Input => input_Reg,
            op => op_Reg,
            Output0 => out0,
            Output1 => out1,
            Output2 => out2,
            Output3 => out3,
            Output4 => out4
            );
    
    	process(clk)
        	begin
            	if(rising_edge(clk)) then
               		but_previous <= ld;
                    
                    ld_reg <= 1;
                    
                    case estado_atual is
                    	when estado_seting =>
                        	error_zero <= '0';
                            error_maior <= '0';
                            VQ <= (others => '0'); -- zera o quociente
                            ld_Reg <= '1';
                            step_counter <= 0;
                            
                            if(but_previous = '1' and ld = '0') then
                            	VA <= A;
                            	estado_atual <= estado_escrever_A;
                            end if;
                            
                      	 when estado_escrever_A =>
                       	 	case step_counter is
                            	when 0 =>
                                	ld_Reg <= '0';
                                	step_counter <= 1;
                              	when 1 =>
                                	ld_Reg <= '1'; 
                                    step_counter <= 2;
                                when 2 => 
                                	op_Reg <= '0';
                                    ld_Reg <= '0';
                                    step_counter <= 3;
                                when 3 =>
                                	ld_Reg <= '1';
                                    step_counter <= 4;
                                when 4 =>
                                	input_Reg <= (others => '0');
                                    ld_Reg <= '0';
                                    step_counter <= 5; 
                                when 5 => 
                                	ld_Reg <= '1';
                                    step_counter <= 6;
                                when 6 => 
                                	input_Reg <= VA;
                                    ld_Reg <= '0';
                                    step_counter <= 7;
                                when 7 => 
                                  ld_Reg <= '1';
                                  step_counter <= 0;
                                  estado_atual <= estado_espera_B;
                          	end case;
                          
                       	when estado_espera_B =>
                    		ld_Reg <= '1';
                    
                    		if (but_previous = '1' and ld = '0') then
                        		VB <= B;
                        		estado_atual <= estado_escrever_B;
                    		end if;
                            
						when estado_escrever_B =>
                          case step_counter is
                              when 0 => 
                              	ld_Reg <= '0'; 
                                step_counter <= 1;
                              when 1 => 
                              	ld_Reg <= '1';
                                step_counter <= 2;
                              when 2 =>
                              	op_Reg <= '0';
                              	ld_Reg <= '0';
                              	step_counter <= 3;
                              when 3 => 
                              	ld_Reg <= '1';
                              	step_counter <= 4;
                              when 4 => 
                              	input_Reg <= x"0001"; --registrado r 1
                              	ld_Reg <= '0'; step_counter <= 5;
                              when 5 =>
                              	ld_Reg <= '1';
                              	step_counter <= 6;
                              when 6 =>
                              	input_Reg <= VB; --valor a ser escrito dividendo
                                ld_Reg <= '0';
                                step_counter <= 7;
                              when 7 => 
                                  ld_Reg <= '1';
                                  step_counter <= 0;
                                  estado_atual <= estado_subtracao; -- muda estado
                          end case;
                        	
						when estado_subtracao =>
							--logica subtracao
                 
            		end case;
                
                
                end if;
                
    	end process;
        
    end div;
    	
        
