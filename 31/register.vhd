LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY reg_paraleload IS
PORT ( I : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
clk, ld : IN STD_LOGIC;
Q : OUT STD_LOGIC_VECTOR (15 DOWNTO 0) );
END;
ARCHITECTURE reg OF reg_paraleload IS
BEGIN
PROCESS (I, clk, ld)
BEGIN
IF (clk'event AND clk = '1' AND ld = '1')
THEN
Q <= I;
END IF;
END PROCESS;
END;