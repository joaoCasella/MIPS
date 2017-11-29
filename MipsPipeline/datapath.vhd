library IEEE; use IEEE.STD_LOGIC_1164.all; use IEEE.STD_LOGIC_ARITH.all;

entity datapath is  -- MIPS datapath
  port(clk, reset:        in  STD_LOGIC;
       memtoreg, pcsrc:   in  STD_LOGIC;
       alusrc, regdst:    in  STD_LOGIC;
       regwrite, jump:    in  STD_LOGIC;
       alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
       zero:              out STD_LOGIC;
       pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
       instr:             in  STD_LOGIC_VECTOR(31 downto 0);
       aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
       readdata:          in  STD_LOGIC_VECTOR(31 downto 0);
       srca, srcb:        out STD_LOGIC_VECTOR(31 downto 0);
       signextend:        in STD_LOGIC);
end;

architecture struct of datapath is
  component alu
    port(a, b:       in  STD_LOGIC_VECTOR(31 downto 0);
         alucontrol: in  STD_LOGIC_VECTOR(2 downto 0);
         result:     buffer STD_LOGIC_VECTOR(31 downto 0);
         zero:       out STD_LOGIC);
  end component;
  component regfile
    port(clk:           in  STD_LOGIC;
         we3:           in  STD_LOGIC;
         ra1, ra2, wa3: in  STD_LOGIC_VECTOR(4 downto 0);
         wd3:           in  STD_LOGIC_VECTOR(31 downto 0);
         rd1, rd2:      out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component adder
    port(a, b: in  STD_LOGIC_VECTOR(31 downto 0);
         y:    out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component sl2
    port(a: in  STD_LOGIC_VECTOR(31 downto 0);
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component imextender
    port(a: in  STD_LOGIC_VECTOR(15 downto 0);
         signextend: in STD_LOGIC;
         y: out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  component flopr generic(width: integer);
    port(clk, reset: in  STD_LOGIC;
         d:          in  STD_LOGIC_VECTOR(width-1 downto 0);
         q:          out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  component mux2 generic(width: integer);
    port(d0, d1: in  STD_LOGIC_VECTOR(width-1 downto 0);
         s:      in  STD_LOGIC;
         y:      out STD_LOGIC_VECTOR(width-1 downto 0));
  end component;
  signal writereg:           STD_LOGIC_VECTOR(4 downto 0);
  signal pcjump, pcnext,
         pcnextbr, pcplus4,
         pcbranch:           STD_LOGIC_VECTOR(31 downto 0);
  signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
  signal s_srca, s_srcb, result: STD_LOGIC_VECTOR(31 downto 0);
begin

  -- IF
  pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc); -- definitivamente IF
  pcadd1: adder port map(pc, X"00000004", pcplus4); -- definitivamente IF
  pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, pcsrc, pcnextbr);  -- creio que IF
  pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext); -- creio que IF

  -- ID
  pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00"; -- tava no IF, creio que possa ser ID (?)
  rf: regfile port map(clk, regwrite, instr(25 downto 21), instr(20 downto 16),
                       writereg, result, s_srca, writedata); -- definitivamente ID
  se: imextender port map(instr(15 downto 0), signextend, signimm); -- definitivamente ID

  -- EX
  pcadd2: adder port map(pcplus4, signimmsh, pcbranch); -- tava no IF, é EX pelo livro
  immsh: sl2 port map(signimm, signimmsh); -- tava no IF, é EX pelo livro
  wrmux: mux2 generic map(5) port map(instr(20 downto 16), instr(15 downto 11), regdst, writereg); -- tava no ID, é EX pelo livro
  srcbmux: mux2 generic map(32) port map(writedata, signimm, alusrc, s_srcb); -- definitivamente EX
  mainalu: alu port map(s_srca, s_srcb, alucontrol, aluout, zero); -- definitivamente EX

  -- WB (sim)
  resmux: mux2 generic map(32) port map(aluout, readdata, memtoreg, result); --tava no ID, é WB pelo livro

  srca <= s_srca;
  srcb <= s_srcb;
end;
