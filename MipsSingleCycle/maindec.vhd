library IEEE; use IEEE.STD_LOGIC_1164.all;

entity maindec is -- main control decoder
  port(op:                 in  STD_LOGIC_VECTOR(5 downto 0);
       memtoreg, memwrite: out STD_LOGIC;
       branch, alusrc:     out STD_LOGIC;
       regdst, regwrite:   out STD_LOGIC;
       jump:               out STD_LOGIC;
       aluop:              out STD_LOGIC_VECTOR(1 downto 0);
       signextend:         out STD_LOGIC);
end;

architecture behave of maindec is
  signal controls: STD_LOGIC_VECTOR(8 downto 0);
begin
  process(all) begin
    case op is
      when "000000" => controls <= "1100000100"; -- RTYPE
      when "100011" => controls <= "1010010001"; -- LW
      when "101011" => controls <= "0010100001"; -- SW
      when "000100" => controls <= "0001000010"; -- BEQ
      when "001000" => controls <= "1010000001"; -- ADDI
      when "001101" => controls <= "1010000110"; -- ORI
      when "000010" => controls <= "0000001000"; -- J
      when others   => controls <= "----------"; -- illegal op
    end case;
  end process;

  (regwrite, regdst, alusrc, branch, memwrite,
   memtoreg, jump, aluop(1 downto 0), signextend) <= controls;
end;