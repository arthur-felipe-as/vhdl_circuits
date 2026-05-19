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
        nMS := ((not M) and S1) and ( (Ap and (not S0)) or (As and S0) );
        MnS := (M and (not S1)) and ( (A and B and (not S0)) or ((A or B) and S0) );
        MS := (M and S1) and (A xor B xor S0);
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
