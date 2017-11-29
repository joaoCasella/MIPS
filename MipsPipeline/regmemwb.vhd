library IEEE; use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity regmemwb is -- register between mem and wb
  port(clk:                        in  STD_LOGIC;
       memtoreg_mem, regwrite_mem: in  STD_LOGIC; --WB
       writereg_mem:               in  STD_LOGIC_VECTOR(4 downto 0);
       readdata_mem, aluout_mem:   in  STD_LOGIC_VECTOR(31 downto 0);
       memtoreg_wb, regwrite_wb:   out STD_LOGIC; --WB
       writereg_wb:                out STD_LOGIC_VECTOR(4 downto 0);
       readdata_wb, aluout_wb:     out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of regmemwb is
  signal memtoreg, regwrite: STD_LOGIC; --WB
  signal writereg:           STD_LOGIC_VECTOR(4 downto 0);
  signal readdata, aluout:   STD_LOGIC_VECTOR(31 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then

      memtoreg_wb <= memtoreg;
      regwrite_wb <= regwrite;
      writereg_wb <= writereg;
      readdata_wb <= readdata;
      aluout_wb   <= aluout;

      memtoreg    <= memtoreg_mem;
      regwrite    <= regwrite_mem;
      writereg    <= writereg_mem;
      readdata    <= readdata_mem;
      aluout      <= aluout_mem;

    end if;
  end process;
end;