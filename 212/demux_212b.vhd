library IEEE;
use IEEE.std_logic_1164.all;

entity demux_212 is 
	port(
    X: in std_logic_vector(2 downto 0);
    S0, S1: in std_logic;
    V0, V1, V2, V3: out std_logic_vector(2 downto 0));
end demux_212;

architecture demux of demux_212 is
	signal S : std_logic_vector(0 to 1);
	begin
	S(0) <= S0;
	S(1) <= S1;
process (X, S0, S1) is
begin
  	case S is
    	when "00" => V0 <= X;
    	when others => V0 <= "000";
    end case;

	case S is
    	when "01" => V1 <= X;
    	when others => V1 <= "000";
    end case;
    
    case S is
    	when "10" => V2 <= X;
    	when others => V2 <= "000";
    end case;
    
    case S is
    	when "11" => V3 <= X;
    	when others => V3 <= "000";
    end case;
  end process;
end demux;
