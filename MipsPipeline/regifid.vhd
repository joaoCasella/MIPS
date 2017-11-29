library IEEE; use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity regifid is -- IF/ID register
  port(clk:                        in   STD_LOGIC;
       pcplus4_if, instr_if: in   STD_LOGIC_VECTOR(31 downto 0);
	   pcplus4_id, instr_id: out  STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of regifid is
  signal pcplus4, instruction: STD_LOGIC_VECTOR(31 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
       pcplus4_id  <= pcplus4;
	   instr_id    <= instruction;
	   pcplus4     <= pcplus4_if;
	   instruction <= instr_if;
    end if;
  end process;
end;