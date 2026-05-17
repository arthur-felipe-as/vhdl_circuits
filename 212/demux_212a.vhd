library IEEE;
use IEEE.std_logic_1164.all;

entity demux_212 is 
	port(
    X: in std_logic_vector(2 downto 0);
    S0, S1: in std_logic;
    V0, V1, V2, V3: out std_logic_vector(2 downto 0));
end demux_212;

architecture demux of demux_212 is
begin
  process (S0, S1) is
  begin
	if S0 = '0' and S1 = '0' then
    	V0 <= X;
    else
    	V0 <= "000";
    end if;
        
	if S0 = '0' and S1 = '1' then
    	V1 <= X;
    else
    	V1 <= "000";
    end if;

	if S0 = '1' and S1 = '0' then
    	V2 <= X;
    else
    	V2 <= "000";
    end if;

	if S0 = '1' and S1 = '1' then
    	V3 <= X;
    else
    	V3 <= "000";
    end if;
  end process;
end demux;
