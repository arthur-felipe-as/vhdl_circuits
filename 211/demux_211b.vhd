library ieee;
use ieee.std_logic_1164.all;


entity demux_211 is
	port( X :in std_logic_vector(2 downto 0);
			S1, S2 : in std_logic;
			Y1,Y2,Y3,Y4: out std_logic_vector(2 downto 0));
end;

architecture demux of demux_211 is
	signal S : std_logic_vector(0 to 1);
	begin
	S(0) <= S1;
	S(1) <= S2;
	
	with (S) select
			Y1 <= X when "00",
			"000" when others;
	with (S) select
			Y2 <= X when "01",
			"000" when others;
	with (S) select
			Y3 <= X when "10",
			"000" when others;
	with (S) select		
			Y4 <= X when "11",
			"000" when others;
		
end demux;
	
			
