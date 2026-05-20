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
	M, S1, S0: in std_logic;
	A, B: in std_logic_vector(15 downto 0);
    F: out std_logic_vector(15 downto 0);
    Ovf: out std_logic);
end ALU;

architecture arch of ALU is
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
    
    signal IA, IB: std_logic_vector(15 downto 0);
    signal Cin: std_logic;
begin
	LOG: LogComp port map(M, S1, S0, A, B, IA, IB, Cin);
    
    ART: Adder16Bit port map(IA, IB, Cin, F, Ovf);
end arch;
