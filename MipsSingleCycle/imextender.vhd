library IEEE; use IEEE.STD_LOGIC_1164.all;

entity imextender is -- immediate extender
  port(a: in  STD_LOGIC_VECTOR(15 downto 0);
       signextend: in  STD_LOGIC;
       y: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of imextender is
  signal signextender: STD_LOGIC;

begin
  signextender <= signextend and a(15);

  y <= X"ffff" & a when signextender = '1' else X"0000" & a;
end;