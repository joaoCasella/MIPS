library IEEE; use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity regidex is -- ID/EX register
  port(clk:                        in   STD_LOGIC;
       pcplus4_id, signimm_id:     in   STD_LOGIC_VECTOR(31 downto 0);
	   readdata1_id, readdata2_id: in   STD_LOGIC_VECTOR(31 downto 0);
	   pcplus4_ex, signimm_ex:     out   STD_LOGIC_VECTOR(31 downto 0);
	   readdata1_ex, readdata2_ex: out   STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of regidex is
  signal pcplus4, signimm, readdata1, readdata2: STD_LOGIC_VECTOR(31 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
       pcplus4_ex   <= pcplus4;
	   signimm_ex   <= signimm;
	   readdata1_ex <= readdata1;
	   readdata2_ex <= readdata2;
	   pcplus4      <= pcplus4_id;
	   signimm      <= signimm_id;
	   readdata1    <= readdata1_id;
	   readdata2    <= readdata2_id;
    end if;
  end process;
end;