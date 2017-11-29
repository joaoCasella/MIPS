library IEEE; use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity regmemwb is -- register between mem and wb
  port(clk:                      in  STD_LOGIC;
       writereg_mem:             in  STD_LOGIC_VECTOR(4 downto 0);
       readdata_mem, aluout_mem: in  STD_LOGIC_VECTOR(31 downto 0);
       writereg_wb:              out STD_LOGIC_VECTOR(4 downto 0);
       readdata_wb, aluout_wb:   out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of regmemwb is
  signal writereg:         STD_LOGIC_VECTOR(4 downto 0);
  signal readdata, aluout: STD_LOGIC_VECTOR(31 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
      writereg_wb <= writereg;
      readdata_wb <= readdata;
      aluout_wb   <= aluout;
      writereg    <= writereg_mem;
      readdata    <= readdata_mem;
      aluout      <= aluout_mem;
    end if;
  end process;
end;