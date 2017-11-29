library IEEE; use IEEE.STD_LOGIC_1164.all;

entity hazarddetection is -- hazard detector
  port(idexrt, ifidrs, ifidrt: in  STD_LOGIC_VECTOR(4 downto 0);
       memread:                in  STD_LOGIC;
       stall:                  out STD_LOGIC);
end;

architecture behave of hazarddetection is
begin
  stall <= memread and (idexrt = ifidrs or idexrt = ifidrt);
end;