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


-- Designing the Logic Extender
library IEEE;
use IEEE.std_logic_1164.all;

entity LogExt is
port(
	Ap, A, As, B, M, S1, S0: in std_logic;
    IA: out std_logic);
end LogExt;

architecture LE of LogExt is
begin
	process(Ap, A, As, B, M, S1, S0)
    	variable nMnS, nMS, MnS, MS: std_logic;
    begin
    	nMnS := ((not M) and (not S1)) and A;
        nMS :=        ((not M) and S1) and ( (Ap and (not S0)) or (As and S0) );
        MnS :=        (M and (not S1)) and ( (A and B and (not S0)) or ((A or B) and S0) );
        MS :=               (M and S1) and (A xor B xor S0);
        IA <= nMnS or nMS or MnS or MS;
    end process;
end LE;

-- Designing the Arithmetic Extender
library IEEE;
use IEEE.std_logic_1164.all;

entity ArithExt is
port(
	B, M, S1, S0: in std_logic;
    IB: out std_logic);
end ArithExt;

architecture AE of ArithExt is
begin
	IB <= (B xor S0) and not (M or S1);
end AE;

-- Designing the Logic Component
library IEEE;
use IEEE.std_logic_1164.all;

entity LogComp is
port(
	M, S1, S0: in std_logic;
	A, B: in std_logic_vector(15 downto 0);
    Ctrl: out std_logic;
    IA, IB: out std_logic_vector(15 downto 0));
end LogComp;

architecture LC of LogComp is
	component LogExt is
    port(
        Ap, A, As, B, M, S1, S0: in std_logic;
        IA: out std_logic);
    end component;
    
    component ArithExt is
    port(
        B, M, S1, S0: in std_logic;
        IB: out std_logic);
    end component;
begin
	L0: LogExt port map('0', A(0), A(1), B(0), M, S1, S0, IA(0));
    A0: ArithExt port map(B(0), M, S1, S0, IB(0));
    
    FL: for i in 1 to 14 generate
    	Li: LogExt port map(A(i-1), A(i), A(i+1), B(i), M, S1, S0, IA(i));
        Ai: ArithExt port map(B(i), M, S1, S0, IB(i));
    end generate;
    
	L15: LogExt port map(A(14), A(15), '0', B(15), M, S1, S0, IA(15));
    A15: ArithExt port map(B(15), M, S1, S0, IB(15));
    
   	Ctrl <= not M and not S1 and S0;
end LC;

-- Designing the Full Adder
library IEEE;
use IEEE.std_logic_1164.all;

entity FullAdd is
	port(
    A, B, Cin: in std_logic;
    S, Cout: out std_logic);
end FullAdd;

architecture FA of FullAdd is
begin
	S <= A xor B xor Cin;
    Cout <= (A and B) or ((A xor B) and Cin);
end FA;

-- Designing the 16-bit Adder
library IEEE;
use IEEE.std_logic_1164.all;

entity Adder16Bit is
	port(
    A, B: in std_logic_vector(15 downto 0);
    Cin: in std_logic;
    S: out std_logic_vector(15 downto 0);
    Cout: out std_logic);
end Adder16Bit;

architecture A16B of Adder16Bit is
	component FullAdd is
    	port(
        A, B, Cin: in std_logic;
        S, Cout: out std_logic);
    end component;
    
    signal C: std_logic_vector(14 downto 0);
begin
	S0: FullAdd port map(A(0), B(0), Cin, S(0), C(0));
    
	FL: for i in 1 to 14 generate
    	Si: FullAdd port map(A(i), B(i), C(i-1), S(i), C(i));
    end generate;
    
    S15: FullAdd port map(A(15), B(15), C(14), S(15), Cout);
end A16B;

-- Joining components in the ALU
library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
port(
	C1, C0, Set: in std_logic;
	Input: in std_logic_vector(15 downto 0);
    Output0, Output1, Output2, Output3, Output4: out std_logic_vector(0 to 6);
	Ovf: out std_logic);
end ALU;

architecture arch of ALU is
	component display7 is
	Port(
		hex: in std_logic_vector(3 downto 0);
		d7: out std_logic_vector(0 to 6)
	);
	end component;
	
    component LogComp is
    port(
        M, S1, S0: in std_logic;
        A, B: in std_logic_vector(15 downto 0);
        IA, IB: out std_logic_vector(15 downto 0);
        Ctrl: out std_logic);
    end component;
    
    component Adder16Bit is
    port(
        A, B: in std_logic_vector(15 downto 0);
        Cin: in std_logic;
        S: out std_logic_vector(15 downto 0);
        Cout: out std_logic);
    end component;
    
    signal A_in, B_in, F_out: std_logic_vector(15 downto 0); -- Values
    signal S_in: std_logic_vector(2 downto 0); -- Select operation
    
    signal IA, IB: std_logic_vector(15 downto 0);
    signal Cin: std_logic;
	signal display_data: std_logic_vector(15 downto 0);
begin
	S_in <= Input(2 downto 0) when (C1 = '0' and C0 = '0' and Set = '1') else S_in;
	A_in <= Input when (C1 = '0' and C0 = '1' and Set = '1') else A_in;
    B_in <= Input when (C1 = '1' and C0 = '0' and Set = '1') else B_in;
    
    Output4 <= "1011011" when (C1 = '0' and C0 = '0') else
    		   "1110111" when (C1 = '0' and C0 = '1') else
               "0011111" when (C1 = '1' and C0 = '0') else
               "1000111" when (C1 = '1' and C0 = '1');

	LOG: LogComp port map(S_in(2), S_in(1), S_in(0), A_in, B_in, IA, IB, Cin);
    ART: Adder16Bit port map(IA, IB, Cin, F_out, Ovf);
    
    process(C1, C0, A_in, B_in, F_out)
	begin
		if (C1 = '0' and C0 = '1') then
            display_data <= A_in;

        elsif (C1 = '1' and C0 = '0') then
            display_data <= B_in;

        elsif (C1 = '1' and C0 = '1') then
            display_data <= F_out;

        else
            display_data <= (others => '0');
            
        end if;
	end process;
    
	led0 : display7 port map(display_data(3 downto 0), Output0);

    led1 : display7 port map(display_data(7 downto 4), Output1);

    led2 : display7 port map(display_data(11 downto 8), Output2);
		  
    led3 : display7 port map(display_data(15 downto 12), Output3);

end arch;
