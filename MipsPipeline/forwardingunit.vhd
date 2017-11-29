library IEEE; use IEEE.STD_LOGIC_1164.all;

entity forwardingunit is -- forwarding unit
  port(exmemrd, idexrs, idexrt:      in  STD_LOGIC_VECTOR(4 downto 0);
       memwbrd, memwbrd:             in  STD_LOGIC_VECTOR(4 downto 0);
       exmemregwrite, memwbregwrite: in  STD_LOGIC;
       forwardA, forwardB:           out STD_LOGIC_VECTOR(1 downto 0));
end;

architecture behave of forwardingunit is
  process(all) begin
    if exmemregwrite = '1' and exmemrd /= "00000" and exmemrd = idexrs then
      forwardA = "10";
    elsif memwbregwrite = '1' and memwbrd /= "00000" and not(exmemregwrite and exmemrd /= "00000")
     and exememrd /= idexrs and memwbrd /= idexrs then
      forwardA = "01";
    else
      forwardA = "00";
    end if;
    
    if exmemregwrite = '1' and exmemrd /= "00000" and exmemrd = idexrt then
      forwardB = "10";
    elsif memwbregwrite = '1' and memwbrd /= "00000" and not(exmemregwrite and exmemrd /= "00000")
     and exememrd /= idexrt and memwbrd /= idexrt then
      forwardB = "01";
    else
      forwardA = "00";
    end if;
  end process;
end;