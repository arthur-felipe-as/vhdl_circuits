--- DIVISOR ---

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AlgDivis is
port(
	clk, load: in std_logic;
	input: in std_logic_vector(15 downto 0);
	err, ans: out std_logic;
	Output0, Output1, Output2, Output3, Output4: out std_logic_vector(0 to 6);
	temp: out std_logic_vector(1 downto 0)
	);
end AlgDivis;

architecture divis of AlgDivis is
	component register_bank is
        port( 
        clk, ld1, ld2: in std_logic;
        Input : in std_logic_vector(15 downto 0);
        Output0, Output1, Output2, Output3, Output4: out std_logic_vector(0 to 6)
        );
    end component;
    
    constant A: std_logic_vector := "00";
    constant B: std_logic_vector := "01";
    constant X: std_logic_vector := "10";
    constant C: std_logic_vector := "11";
    
    signal reginput, VA, VB, VX: std_logic_vector(15 downto 0);
    signal ld1, ld2: std_logic;
    signal out0, out1, out2, out3, out4: std_logic_vector(0 to 6);
    signal state: std_logic_vector(1 downto 0) := "00";
	
begin
	
	WA: register_bank port map (clk, ld1, ld2, reginput, out0, out1, out2, out3, out4);
    
	process(clk, load, input)
		--variable VX: std_logic_vector(15 downto 0);
		variable v_VA: std_logic_vector(15 downto 0);
	begin

	if(rising_edge(clk)) then
		if(out4 = "0000001" or out4 = "0001000") then -- espera ou endereÃ§o
			temp <= "00";
			ld1 <= '1';
			if(state = C) then
				reginput <= "0000000000000010";
			else
				reginput <= "00000000000000" & state;
			end if;
			
			ld2 <= '0';
					
		elsif(out4 = "1100010") then -- operaÃ§Ã£o
			temp <= "01";
			ld2 <= '1';
			  if(state = C) then
				reginput <= "0000000000000001";
			  else
				reginput <= "0000000000000000";
			end if;
			ld1 <= '0';
			  
			
		elsif(out4 = "0110000") then -- escrita
			temp <= "10";
			ld2 <= '1';
			reginput <= input;
			  
			if(state = A and load = '0') then
				Output4 <= "0001000";
				VA <= input;
				state <= B;
				ld1 <= '0';
					
			elsif(state = B and load = '0') then
				Output4 <= "1100000";
				VB <= input;
				VX <= "0000000000000000";
				state <= X;
				ld1 <= '0';
					
			elsif(state = X) then
				if(VA > VB and VB > "0000000000000000") then
					VA <= std_logic_vector(unsigned(VA) - unsigned(VB));
					VX <= std_logic_vector(to_unsigned(to_integer(unsigned(VX)) + 1, 16));
				else
					reginput <= VX;
					state <= C;
					ld1 <= '0';
				end if;
			end if;
			
			Output0 <= out0;
			Output1 <= out1;
			Output2 <= out2;
			Output3 <= out3;
			  
		elsif(out4 = "1110001") then -- leitura
			temp <= "11";
			ld2 <= '1';
			Output4 <= "0110001";
			ld1 <= '0';
		
			Output0 <= out0;
			Output1 <= out1;
			Output2 <= out2;
			Output3 <= out3;
		end if;
	end if;
	
	--temp <= state;
    
	report "end the iof";
    
	end process;
end divis;