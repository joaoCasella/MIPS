library IEEE; use IEEE.STD_LOGIC_1164.all; 
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity regidex is -- ID/EX register
  port(clk:                                  in STD_LOGIC;
       pcplus4_id, signimm_id:               in STD_LOGIC_VECTOR(31 downto 0);
	   readdata1_id, readdata2_id:           in STD_LOGIC_VECTOR(31 downto 0);
	   ifidrt, ifidrd:                       in STD_LOGIC_VECTOR(4 downto 0);
	   pcplus4_ex, signimm_ex:               out STD_LOGIC_VECTOR(31 downto 0);
	   readdata1_ex, readdata2_ex:           out STD_LOGIC_VECTOR(31 downto 0);
	   idexrt, idexrd:                       out STD_LOGIC_VECTOR(4 downto 0);
	   memtoregifid, memwriteifid:           in STD_LOGIC;
       branchifid, branchneifid, alusrcifid: in STD_LOGIC;
       regdstifid, regwriteifid:             in STD_LOGIC;
       aluopifid:                            in STD_LOGIC_VECTOR(1 downto 0);
	   memtoregidex, memwriteidex:           out STD_LOGIC;
       branchidex, branchneidex, alusrcidex: out STD_LOGIC;
       regdstidex, regwriteidex:             out STD_LOGIC;
       aluopidex:                            out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture behave of regidex is
  signal pcplus4, signimm, readdata1, readdata2: STD_LOGIC_VECTOR(31 downto 0);
  signal rt, rd: STD_LOGIC_VECTOR(4 downto 0);
  signal memtoreg, memwrite, branch, branchne, alusrc, regdst, regwrite: STD_LOGIC;
  signal aluop: STD_LOGIC_VECTOR(1 downto 0);
begin
  process(clk) begin
    if rising_edge(clk) then
       pcplus4_ex   <= pcplus4;
	   signimm_ex   <= signimm;
	   readdata1_ex <= readdata1;
	   readdata2_ex <= readdata2;
	   idexrt       <= rt;
	   idexrd       <= rd;
	   memtoregidex <= memtoreg;
	   memwriteidex <= memwrite;
	   branchidex   <= branch;
	   branchneidex <= branchne;
	   alusrcidex   <= alusrc;
	   regdstidex   <= regdst;
	   regwriteidex <= regwrite;
       aluopidex    <= aluop;
	   pcplus4      <= pcplus4_id;
	   signimm      <= signimm_id;
	   readdata1    <= readdata1_id;
	   readdata2    <= readdata2_id;
	   rt           <= ifidrt;
	   rd           <= ifidrd;
	   memtoreg     <= memtoregifid;
	   memwrite     <= memwriteifid;
	   branch       <= branchifid;
	   branchne     <= branchneifid;
	   alusrc       <= alusrcifid;
	   regdst       <= regdstifid;
	   regwrite     <= regwriteifid;
       aluop        <= aluopifid;
    end if;
  end process;
end;