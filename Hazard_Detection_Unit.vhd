library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Hazard_Detection_Unit is
    port
    (    
        FD_RS1 : in std_logic_vector(2 downto 0);
        FD_RS2 : in std_logic_vector(2 downto 0);
        D_Ex_rd : in std_logic_vector(2 downto 0);
        D_EX_Mem_Read: in std_logic;
        D_EX_Mem_Write: in std_logic;
        Data_interface_needed: in std_logic;
        Branch_Taken: in std_logic;
        -- Outputs
        Stall: out std_logic_vector(1 downto 0);
        Flush: out std_logic_vector(1 downto 0)

    );
end entity; 
architecture Behavioral of Hazard_Detection_Unit is
    begin
        process(FD_RS1, FD_RS2, Branch_Taken, D_Ex_rd, D_EX_Mem_Read, D_EX_Mem_Write, Data_interface_needed)
        begin
            -- Default values
            Stall <= "00";
            Flush <= "00";
    
            if (Branch_Taken = '1') then
                -- Branch hazard → flush
                Stall <= "00";
                Flush <= "11"; --Flush Decode Control signals and Fetch register
    
            elsif (D_EX_Mem_Read = '1' and ((FD_RS1 = D_Ex_rd) or (FD_RS2 = D_Ex_rd))) then
                -- Load-use hazard → stall
                Stall <= "01"; --Disable FD register and PC
                Flush <= "10"; --Flush Decode control signals
    
            elsif (Data_interface_needed = '1') then
                -- Structural hazard (shared memory) → stall
                Stall <= "01";
                Flush <= "00";
    
            else
                Stall <= "00";
                Flush <= "00";
            end if;
        end process;
    end architecture;
      