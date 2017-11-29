library IEEE; 
use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD_UNSIGNED.all;

entity top is -- top-level design for testing
  port(clk, reset:           in     STD_LOGIC;
       writedata, dataadr:   buffer STD_LOGIC_VECTOR(31 downto 0);
       memwrite:             buffer STD_LOGIC;
       readdata:             out STD_LOGIC_VECTOR(31 downto 0);
       srca:                 out STD_LOGIC_VECTOR(31 downto 0);
       srcb:                 out STD_LOGIC_VECTOR(31 downto 0);
       zero:                 out STD_LOGIC;
       branch:               out STD_LOGIC;
       pcsrc:                out STD_LOGIC;
       pc, instr:            out STD_LOGIC_VECTOR(31 downto 0));
end;

architecture test of top is
  component mips 
    port(clk, reset:        in  STD_LOGIC;
         pc:                out STD_LOGIC_VECTOR(31 downto 0);
         instr:             in  STD_LOGIC_VECTOR(31 downto 0);
         memwrite:          out STD_LOGIC;
         aluout, writedata: out STD_LOGIC_VECTOR(31 downto 0);
         readdata:          in  STD_LOGIC_VECTOR(31 downto 0);
         pcsrc:             out STD_LOGIC;
         zero:              out STD_LOGIC;
         branch:            out STD_LOGIC;
         srca, srcb:        out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component imem
    port(a:  in  STD_LOGIC_VECTOR(5 downto 0);
         rd: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component dmem
    port(clk, we:  in STD_LOGIC;
         a, wd:    in STD_LOGIC_VECTOR(31 downto 0);
         rd:       out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  signal s_pc, s_instr, s_readdata: STD_LOGIC_VECTOR(31 downto 0);
begin
  -- instantiate processor and memories
  mips1: mips port map(clk, reset, s_pc, s_instr, memwrite, dataadr, writedata, s_readdata, pcsrc, zero, branch, srca, srcb);
  imem1: imem port map(s_pc(7 downto 2), s_instr);
  dmem1: dmem port map(clk, memwrite, dataadr, writedata, s_readdata);
  
  instr <= s_instr;
  pc <= s_pc;
  readdata <= s_readdata;
end;