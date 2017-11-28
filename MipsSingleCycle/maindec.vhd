library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
  port(op:                       in  STD_LOGIC_VECTOR(5 downto 0);
       memtoreg, memwrite:       out STD_LOGIC;
       branch, branchne, alusrc: out STD_LOGIC;
       regdst, regwrite:         out STD_LOGIC;
       jump:                     out STD_LOGIC;
       aluop:                    out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture behave of maindec is
  signal controls: STD_LOGIC_VECTOR(9 downto 0);
begin
  process(all) begin
    case op is
      when "000000" => controls <= "1100000010"; -- RTYPE
      when "100011" => controls <= "1010001000"; -- LW
      when "101011" => controls <= "0010010000"; -- SW
      when "000100" => controls <= "0001000001"; -- BEQ
      when "000101" => controls <= "0000100011"; -- BNE
      when "001000" => controls <= "1010000000"; -- ADDI
      when "000010" => controls <= "0000000100"; -- J
      when others   => controls <= "----------"; -- illegal op
    end case;
  end process;

  (regwrite, regdst, alusrc, branch, branchne, memwrite,
   memtoreg, jump, aluop(1 downto 0)) <= controls;
end;