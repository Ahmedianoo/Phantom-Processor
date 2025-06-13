library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Forwarding_Unit is
  port(
    -- Input registers from Decode/Execute stage
    D_EX_rs1      : in std_logic_vector(2 downto 0);
    D_EX_rs2      : in std_logic_vector(2 downto 0);
    
    -- Destination registers from Execute/Memory and Memory/Writeback stages
    EX_M_rd       : in std_logic_vector(2 downto 0);
    M_WB_rd       : in std_logic_vector(2 downto 0);
    
    -- Register write enable signals
    EX_M_RegWrite : in std_logic;
    M_WB_RegWrite : in std_logic;
    
    -- Input data signals (as shown in the diagram)
    M_WB_Rd_data  : in std_logic_vector(31 downto 0);
    EX_M_Rd_data  : in std_logic_vector(31 downto 0);
    Rarc1_data    : in std_logic_vector(31 downto 0);
    Rarc2_Data    : in std_logic_vector(31 downto 0);
    Rarc1_addr    : in std_logic_vector(2 downto 0);
    Rarc2_addr    : in std_logic_vector(2 downto 0);
    Immediate     : in std_logic_vector(15 downto 0);
    
    -- Immediate selection control
    IMM_Sel       : in std_logic;  -- Signal to select immediate value
    
    -- Output control signals (as shown in the diagram)

    -- Output operands (as shown in the diagram)
    Operand1      : out std_logic_vector(31 downto 0);
    Operand2      : out std_logic_vector(31 downto 0)
  );
end entity Forwarding_Unit;

architecture Behavioral of Forwarding_Unit is
  -- Internal signals for multiplexers
  signal sel_operand1 : std_logic_vector(1 downto 0);
  signal sel_operand2 : std_logic_vector(1 downto 0);
  signal final_operand2 : std_logic_vector(31 downto 0); -- Intermediate signal for operand2
begin
  -- Forwarding logic process
  forwarding_logic: process(D_EX_rs1, D_EX_rs2, EX_M_rd, M_WB_rd, EX_M_RegWrite, M_WB_RegWrite)
  begin
    -- Default: no forwarding
    sel_operand1 <= "00";
    sel_operand2 <= "00";
    
    -- Forwarding logic for rs1
    if (EX_M_RegWrite = '1' and EX_M_rd /= "000" and D_EX_rs1 = EX_M_rd) then
      sel_operand1 <= "10"; -- Forward from EX/MEM
    elsif (M_WB_RegWrite = '1' and M_WB_rd /= "000" and D_EX_rs1 = M_WB_rd) then
      sel_operand1 <= "01"; -- Forward from MEM/WB
    end if;
    
    -- Forwarding logic for rs2
    if (EX_M_RegWrite = '1' and EX_M_rd /= "000" and D_EX_rs2 = EX_M_rd) then
      sel_operand2 <= "10"; -- Forward from EX/MEM
    elsif (M_WB_RegWrite = '1' and M_WB_rd /= "000" and D_EX_rs2 = M_WB_rd) then
      sel_operand2 <= "01"; -- Forward from MEM/WB
    end if;
  end process forwarding_logic;
  
  -- Output the forwarding control signals

  
  -- Operand multiplexers
  operand_selection: process(sel_operand1, sel_operand2, Rarc1_data, Rarc2_Data, M_WB_Rd_data, EX_M_Rd_data, Immediate, IMM_Sel)
  begin
    -- Operand1 multiplexer
    case sel_operand1 is
      when "00" => 
        Operand1 <= Rarc1_data;           -- From register file
      when "01" => 
        Operand1 <= M_WB_Rd_data;         -- Forward from MEM/WB
      when "10" => 
        Operand1 <= EX_M_Rd_data;         -- Forward from EX/MEM
      when others => 
        Operand1 <= Rarc1_data;           -- Default
    end case;
    
    -- Operand2 multiplexer (first stage - select based on forwarding)
    case sel_operand2 is
      when "00" => 
        final_operand2 <= Rarc2_Data;     -- From register file
      when "01" => 
        final_operand2 <= M_WB_Rd_data;   -- Forward from MEM/WB
      when "10" => 
        final_operand2 <= EX_M_Rd_data;   -- Forward from EX/MEM
      when others => 
        final_operand2 <= Rarc2_Data;     -- Default
    end case;
    
    -- Second stage - select between register value and immediate value
    if (IMM_Sel = '1') then
      -- Sign extend the immediate value from 16 to 32 bits
      Operand2 <= std_logic_vector(resize(signed(Immediate), 32));
    else
      Operand2 <= final_operand2; -- Use the forwarded or register value
    end if;
    
  end process operand_selection;
  
end architecture Behavioral;