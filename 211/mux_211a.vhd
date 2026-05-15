library ieee;
use ieee.std_logic_1164.all;


entity mux_211 is
	port( X :in std_logic_vector(2 downto 0);
			S1, S2: in std_logic;
			Y1,Y2,Y3,Y4: out std_logic_vector(2 downto 0));
end;

architecture mux of mux_211 is
	begin
	Y1 <= X when (S1 = '0' and S2 = '0') else "000";
	Y2 <= X when (S1 = '0' and S2 = '1') else "000";
	Y3 <= X when (S1 = '1' and S2 = '0') else "000";
	Y4 <= X when (S1 = '1' and S2 = '1') else "000";
end mux;
	
			