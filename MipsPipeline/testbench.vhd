library IEEE; 
use IEEE.STD_LOGIC_1164.all; use IEEE.NUMERIC_STD_UNSIGNED.all;

entity testbench is
end;

architecture test of testbench is
  component top
    port(clk, reset:           in  STD_LOGIC;
         writedata, dataadr:   out STD_LOGIC_VECTOR(31 downto 0);
         memwrite:             out STD_LOGIC;
         readdata:             out STD_LOGIC_VECTOR(31 downto 0);
         srca:                 out STD_LOGIC_VECTOR(31 downto 0);
         srcb:                 out STD_LOGIC_VECTOR(31 downto 0);
         zero:                 out STD_LOGIC;
         branch:               out STD_LOGIC;
         pcsrc:                out STD_LOGIC;
         pc, instr:            out STD_LOGIC_VECTOR(31 downto 0));
  end component;
  signal writedata, dataadr:    STD_LOGIC_VECTOR(31 downto 0);
  signal clk, reset, memwrite, zero, branch, pcsrc: STD_LOGIC;
  signal readdata, srca, srcb, pc, instr: STD_LOGIC_VECTOR(31 downto 0);
begin

  -- instantiate device to be tested
  dut: top port map(clk, reset, writedata, dataadr, memwrite, readdata, srca, srcb, zero, branch, pcsrc, pc, instr);

  -- Generate clock with 10 ns period
  process begin
    clk <= '1';
    wait for 5 ns; 
    clk <= '0';
    wait for 5 ns;
  end process;

  -- Generate reset for first two clock cycles
  process begin
    reset <= '1';
    wait for 22 ns;
    reset <= '0';
    wait;
  end process;

  -- check that 7 gets written to address 84 at end of program
  process (clk) begin
    if (clk'event and clk = '0' and memwrite = '1') then
      if (to_integer(dataadr) = 84 and writedata = X"FFFF7F02") then
        report "NO ERRORS: Simulation succeeded" severity failure;
      elsif (dataadr /= 80) then 
        report "Simulation failed" severity failure;
      end if;
    end if;
  end process;
end;