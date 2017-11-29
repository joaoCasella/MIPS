library IEEE; use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity regexmem is -- register between ex and mem
  port(clk:                                   in  STD_LOGIC;
       zero_ex:                               in  STD_LOGIC;
       writereg_ex:                           in  STD_LOGIC_VECTOR(4 downto 0);
       pcjump_ex, aluout_ex, writedata_ex:    in  STD_LOGIC_VECTOR(31 downto 0);
       zero_mem:                              out STD_LOGIC;
       writereg_mem:                          out STD_LOGIC_VECTOR(4 downto 0);
       pcjump_mem, aluout_mem, writedata_mem: out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture behave of regexmem is
  signal zero:                      STD_LOGIC;
  signal writereg:                  STD_LOGIC_VECTOR(4 downto 0);
  signal pcjump, aluout, writedata: STD_LOGIC_VECTOR(31 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
      zero_mem      <= zero;
      writereg_mem  <= writereg;
      pcjump_mem    <= pcjump;
      aluout_mem    <= aluout;
      writedata_mem <= writedata;
      zero          <= zero_ex;
      writereg      <= writedata_ex;
      pcjump        <= pcjump_ex;
      aluout        <= aluout_ex;
      writedata     <= writedata_ex;
    end if;
  end process;
end;