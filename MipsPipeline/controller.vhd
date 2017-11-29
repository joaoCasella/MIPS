library IEEE; use IEEE.STD_LOGIC_1164.all;

entity controller is -- single cycle control decoder
  port(op, funct:          in  STD_LOGIC_VECTOR(5 downto 0);
       zero:               in  STD_LOGIC;
       memtoreg, memwrite: out STD_LOGIC;
       pcsrc, alusrc:      out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       alucontrol:         out STD_LOGIC_VECTOR(2 downto 0);
       signextend:         out STD_LOGIC;
       branch:             out STD_LOGIC);
end;


architecture struct of controller is
  component maindec
    port(op:                       in  STD_LOGIC_VECTOR(5 downto 0);
         memtoreg, memwrite:       out STD_LOGIC;
         branch, branchne, alusrc: out STD_LOGIC;
         regdst, regwrite:         out STD_LOGIC;
         jump:                     out STD_LOGIC;
         aluop:                    out STD_LOGIC_VECTOR(1 downto 0);
         signextend:               out STD_LOGIC);
  end component;
  component aludec
    port(funct:      in  STD_LOGIC_VECTOR(5 downto 0);
         aluop:      in  STD_LOGIC_VECTOR(1 downto 0);
         alucontrol: out STD_LOGIC_VECTOR(2 downto 0));
  end component;

  signal aluop:            STD_LOGIC_VECTOR(1 downto 0);
  signal s_branch, branchne: STD_LOGIC;
begin
  md: maindec port map(op, memtoreg, memwrite, s_branch, branchne,
                       alusrc, regdst, regwrite, jump, aluop, signextend);
  ad: aludec port map(funct, aluop, alucontrol);

  pcsrc <= (s_branch and zero) or (branchne and (not zero));
  branch <= s_branch;
end;
