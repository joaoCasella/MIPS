library IEEE; use IEEE.STD_LOGIC_1164.all;

entity mips is -- single cycle MIPS processor
  port(clk, reset:        in  STD_LOGIC;
       pc:                out STD_LOGIC_VECTOR(31 downto 0);
       instr:             in  STD_LOGIC_VECTOR(31 downto 0);
       memwrite:          out STD_LOGIC;
       aluout, writedata: out STD_LOGIC_VECTOR(31 downto 0);
       readdata:          in  STD_LOGIC_VECTOR(31 downto 0)
       pcsrc:             out STD_LOGIC;
       zero:              out STD_LOGIC;
       branch:            out STD_LOGIC;
       srca, srcb         out STD_LOGIC_VECTOR(31 downto 0)
       );
end;

architecture struct of mips is
  component controller
    port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
         zero:               in  STD_LOGIC;
         memtoreg, memwrite: out STD_LOGIC;
         pcsrc, alusrc:      out STD_LOGIC;
         regdst, regwrite:   out STD_LOGIC;
         jump:               out STD_LOGIC;
         alucontrol:         out STD_LOGIC_VECTOR(2 downto 0);
         branch:             out STD_LOGIC
         );
  end component;
  component datapath
    port(clk, reset:        in  STD_LOGIC;
         memtoreg, pcsrc:   in  STD_LOGIC;
         alusrc, regdst:    in  STD_LOGIC;
         regwrite, jump:    in  STD_LOGIC;
         alucontrol:        in  STD_LOGIC_VECTOR(2 downto 0);
         zero:              out STD_LOGIC;
         pc:                buffer STD_LOGIC_VECTOR(31 downto 0);
         instr:             in STD_LOGIC_VECTOR(31 downto 0);
         aluout, writedata: buffer STD_LOGIC_VECTOR(31 downto 0);
         readdata:          in  STD_LOGIC_VECTOR(31 downto 0)
         srca, srcb:        out STD_LOGIC_VECTOR(31 downto 0)
         );
  end component;
  signal memtoreg, alusrc, regdst, regwrite, jump, s_pcsrc: STD_LOGIC;
  signal s_zero: STD_LOGIC;
  signal alucontrol: STD_LOGIC_VECTOR(2 downto 0);
begin
  cont: controller port map(instr(31 downto 26), instr(5 downto 0),
                            s_zero, memtoreg, memwrite, s_pcsrc, alusrc,
                            regdst, regwrite, jump, alucontrol, branch);
  dp: datapath port map(clk, reset, memtoreg, s_pcsrc, alusrc, regdst,
                        regwrite, jump, alucontrol, s_zero, pc, instr,
                        aluout, writedata, readdata, srca, srcb);

  zero  <= s_zero;
  pcsrc <= s_pcsrc;
end;
