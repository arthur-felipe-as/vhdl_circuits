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


library IEEE;
use IEEE.std_logic_1164.all;

entity Adder8Bit is
	port(
    A, B: in std_logic_vector(7 downto 0);
    Cin: in std_logic;
    S: out std_logic_vector(7 downto 0);
    Cout: out std_logic);
end Adder8Bit;

architecture A8B of Adder8Bit is
	component FullAdd is
    	port(
        A, B, Cin: in std_logic;
        S, Cout: out std_logic);
    end component;
        
    signal C: std_logic_vector(6 downto 0);
    signal B_Comp: std_logic_vector(7 downto 0);
begin
    process(B, Cin) is
    begin
        for i in 0 to 7 loop
          B_Comp(i) <= B(i) xor Cin;
        end loop;
    end process;

	s0: FullAdd port map(A(0), B_Comp(0), Cin, S(0), C(0));
    
	si: for i in 1 to 6 generate
      sum: FullAdd port map(A(i), B_Comp(i), C(i-1), S(i), C(i));
    end generate;
    
    s7: FullAdd port map(A(7), B_Comp(7), C(6), S(7), Cout);
end A8B;
