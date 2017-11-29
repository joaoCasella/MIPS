library IEEE; use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity regmemwb is -- three-port register file
  port(clk:                         in  STD_LOGIC;
       readdata_mem, aluresult_mem: in  STD_LOGIC_VECTOR(31 downto 0);
       readdata_wb, aluresult_wb:   out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of regmemwb is
  signal readdata, aluresult: STD_LOGIC_VECTOR(31 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
      readdata_wb  <= readdata;
      aluresult_wb <= aluresult;
      readdata     <= readdata_mem;
      aluresult    <= aluresult_mem;
    end if;
  end process;
end;