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
       signextend:        in STD_LOGIC;
       memwrite:          in STD_LOGIC;
       branch, branchne:  in STD_LOGIC);
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
  component regifid is -- IF/ID register
    port(clk:                  in   STD_LOGIC;
         pcplus4_if, instr_if: in   STD_LOGIC_VECTOR(31 downto 0);
  	     pcplus4_id, instr_id: out  STD_LOGIC_VECTOR(31 downto 0));
  end component;

  entity regidex is -- ID/EX register
    port(clk:                                  in  STD_LOGIC;
         pcplus4_id, signimm_id:               in  STD_LOGIC_VECTOR(31 downto 0);
  	     readdata1_id, readdata2_id:           in  STD_LOGIC_VECTOR(31 downto 0);
  	     ifidrt, ifidrd:                       in  STD_LOGIC_VECTOR(4 downto 0);
  	     pcplus4_ex, signimm_ex:               out STD_LOGIC_VECTOR(31 downto 0);
  	     readdata1_ex, readdata2_ex:           out STD_LOGIC_VECTOR(31 downto 0);
  	     idexrt, idexrd:                       out STD_LOGIC_VECTOR(4 downto 0);
  	     memtoregifid, memwriteifid:           in  STD_LOGIC;
         branchifid, branchneifid, alusrcifid: in  STD_LOGIC;
         regdstifid, regwriteifid:             in  STD_LOGIC;
         aluopifid:                            in  STD_LOGIC_VECTOR(1 downto 0);
  	     memtoregidex, memwriteidex:           out STD_LOGIC;
         branchidex, branchneidex, alusrcidex: out STD_LOGIC;
         regdstidex, regwriteidex:             out STD_LOGIC;
         aluopidex:                            out STD_LOGIC_VECTOR(1 downto 0));
  end;

  signal writereg, s_writeregex:           STD_LOGIC_VECTOR(4 downto 0);
  signal pcjump, pcnext,
         pcnextbr, pcplus4,
         pcbranch:           STD_LOGIC_VECTOR(31 downto 0);
  signal signimm, signimmsh: STD_LOGIC_VECTOR(31 downto 0);
  signal s_srca, s_srcb, result: STD_LOGIC_VECTOR(31 downto 0);
  signal s_pcplus4_id, s_instr_id: STD_LOGIC_VECTOR(31 downto 0);
  signal s_pcplus4_ex, s_signimm_ex:               STD_LOGIC_VECTOR(31 downto 0);
  signal s_readdata1_ex, s_readdata2_ex:           STD_LOGIC_VECTOR(31 downto 0);
  signal s_idexrt, s_idexrd:                       STD_LOGIC_VECTOR(4 downto 0);
  signal s_memtoregidex, s_memwriteidex:           STD_LOGIC;
  signal s_branchidex, s_branchneidex, s_alusrcidex: STD_LOGIC;
  signal s_regdstidex, s_regwriteidex:             STD_LOGIC;
  signal s_aluopidex:                            STD_LOGIC_VECTOR(1 downto 0));
begin
  --pcplus4_ex <= s_pcplus4_ex, signimm_ex <= s_signimm_ex,readdata1_ex <= s_readdata1_ex, readdata2_ex <= s_readdata2_ex,

  -- IF
  pcjump <= pcplus4(31 downto 28) & instr(25 downto 0) & "00"; -- tava no IF, creio que possa ser ID (?)
  pcreg: flopr generic map(32) port map(clk, reset, pcnext, pc); -- definitivamente IF
  pcadd1: adder port map(pc, X"00000004", pcplus4); -- definitivamente IF
  pcbrmux: mux2 generic map(32) port map(pcplus4, pcbranch, pcsrc, pcnextbr);  -- creio que IF
  pcmux: mux2 generic map(32) port map(pcnextbr, pcjump, jump, pcnext); -- creio que IF

  -- IF/ID Register
  ifidreg: regifid port map (clk, pcplus4_if <= pcplus4, instr_if <= instr, pcplus4_id <= s_pcplus4_id, instr_id <= s_instr_id);

  -- ID
  rf: regfile port map(clk, regwrite, s_instr_id(25 downto 21), s_instr_id(20 downto 16),
                       writereg, result, s_srca, writedata); -- definitivamente ID
  se: imextender port map(s_instr_id(15 downto 0), signextend, signimm); -- definitivamente ID

  -- ID/EX Register - falta branch, branchne
  idexreg: regidex port map (clk, pcplus4_id <= s_pcplus4_id, signimm_id <= signimm, readdata1_id <= s_srca,
  readdata2_id <= writedata, ifidrt <= s_instr_id(20 downto 16), ifidrd <= s_instr_id(15 downto 11),
  memtoregifid <= memtoreg, memwriteifid <= memwrite, branchifid <= branch, branchneifid <= branchne, alusrcifid <= alusrc,
  regdstifid <= regdst, regwriteifid <= regwrite, aluopifid <= alucontrol, pcplus4_ex <= s_pcplus4_ex, signimm_ex <= s_signimm_ex,
  readdata1_ex <= s_readdata1_ex, readdata2_ex <= s_readdata2_ex, idexrt <= s_idexrt, idexrd <= s_idexrd, memtoregidex <= s_memtoregidex,
  memwriteidex <= s_memwriteidex, branchidex <= s_branchidex, branchneidex <= s_branchneidex, alusrcidex <= s_alusrcidex,
  regdstidex <= s_regdstidex, regwriteidex <= s_regwriteidex, aluopidex <= s_aluopidex);

  -- EX
  pcadd2: adder port map(s_pcplus4_ex, signimmsh, pcbranch); -- tava no IF, é EX pelo livro
  immsh: sl2 port map(s_signimm_ex, signimmsh); -- tava no IF, é EX pelo livro
  wrmux: mux2 generic map(5) port map(s_idexrt, s_idexrd, s_regdstidex, s_writeregex); -- tava no ID, é EX pelo livro
  srcbmux: mux2 generic map(32) port map(s_readdata2_ex, s_signimm_ex, s_alusrcidex, s_srcb); -- definitivamente EX
  mainalu: alu port map(s_readdata1_ex, s_srcb, s_aluopidex, aluout, zero); -- definitivamente EX

  -- WB (sim)
  resmux: mux2 generic map(32) port map(aluout, readdata, memtoreg, result); --tava no ID, é WB pelo livro

  srca <= s_srca;
  srcb <= s_srcb;
end;
