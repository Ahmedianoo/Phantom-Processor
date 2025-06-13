library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DecodeExecute is

    Port (
        clk                     : in  STD_LOGIC;
        rst                     : in  STD_LOGIC;
        enable                  : in  STD_LOGIC;

        Pc_In                      : in STD_LOGIC_VECTOR(31 downto 0);
        Read_Addr1_In              : in STD_LOGIC_VECTOR(2 downto 0);
        Read_Addr2_In              : in STD_LOGIC_VECTOR(2 downto 0);
        Interrupt_In               : in STD_LOGIC;
        Rd_Addr_In                 : in STD_LOGIC_VECTOR(2 downto 0);
        Imm_Offset_In              : in STD_LOGIC_VECTOR(15 downto 0);
        Rsrc1_Data_In              : in STD_LOGIC_VECTOR(31 downto 0);
        Rsrc2_Data_In              : in STD_LOGIC_VECTOR(31 downto 0);
        Swap_In                    : in STD_LOGIC;
        Set_Carry_In               : in STD_LOGIC;
        Sp_Inc_In                  : in STD_LOGIC;
        Sp_Dec_In                  : in STD_LOGIC;
        Sp_Enable_In               : in STD_LOGIC;
        RTI_In                     : in STD_LOGIC;
        Return_Signal_In           : in STD_LOGIC;
        Call_In                    : in STD_LOGIC;
        ALU_Srcl_In                : in STD_LOGIC;
        Branch_In                  : in STD_LOGIC;
        Mem_Read_In                : in STD_LOGIC;
        Reg_Write_In               : in STD_LOGIC;
        Update_Flag_In             : in STD_LOGIC;
        IN_Port_In                 : in STD_LOGIC;
        Mem_Write_In               : in STD_LOGIC;
        J_SC_In                    : in STD_LOGIC_VECTOR(1 downto 0);
		  Opcode_In                  : in STD_LOGIC_VECTOR(4 downto 0);
		  DM_In                      : in STD_LOGIC;
		  Out_Port_In                : in STD_LOGIC;

        Mem_Read       : out STD_LOGIC;
        Interrupt      : out STD_LOGIC;
        Reg1_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Swap           : out STD_LOGIC;
        Rsrc1          : out STD_LOGIC_VECTOR(2 downto 0);
		  Rsrc2          : out STD_LOGIC_VECTOR(2 downto 0);
		  Rd             : out STD_LOGIC_VECTOR(2 downto 0);
        Reg_Write      : out STD_LOGIC;
        IN_Port        : out STD_LOGIC;
        Pc             : out STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry      : out STD_LOGIC;
        Sp_Inc         : out STD_LOGIC;
        Sp_Dec         : out STD_LOGIC;
        Sp_Enable      : out STD_LOGIC;
        RTI            : out STD_LOGIC;
        Return_Signal  : out STD_LOGIC;
        Call           : out STD_LOGIC;
        ALU_Srcl       : out STD_LOGIC;
        Branch         : out STD_LOGIC;
        Update_Flag    : out STD_LOGIC;
        Mem_Write      : out STD_LOGIC;
        J_SC           : out STD_LOGIC_VECTOR(1 downto 0);
		  ALU_SLC        : out STD_LOGIC_VECTOR(4 downto 0);
		  DM             : out STD_LOGIC;
		  Imm_Offset     : out STD_LOGIC_VECTOR(15 downto 0);
		  Out_Port       : out STD_LOGIC
    );
	 
end DecodeExecute;

architecture Behavioral of DecodeExecute is

    signal Pc_Reg                      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Read_Addr1_Reg              : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Read_Addr2_Reg              : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Interrupt_Reg               : STD_LOGIC := '0';
    signal Rd_Addr_Reg                 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Imm_Offset_Reg              : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Rsrc1_Data_Reg              : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Rsrc2_Data_Reg              : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Swap_Reg                    : STD_LOGIC := '0';
    signal Set_Carry_Reg               : STD_LOGIC := '0';
    signal Sp_Inc_Reg                  : STD_LOGIC := '0';
    signal Sp_Dec_Reg                  : STD_LOGIC := '0';
    signal Sp_Enable_Reg               : STD_LOGIC := '0';
    signal RTI_Reg                     : STD_LOGIC := '0';
    signal Return_Signal_Reg           : STD_LOGIC := '0';
    signal Call_Reg                    : STD_LOGIC := '0';
    signal ALU_Srcl_Reg                : STD_LOGIC := '0';
    signal Branch_Reg                  : STD_LOGIC := '0';
    signal Mem_Read_Reg                : STD_LOGIC := '0';
    signal Reg_Write_Reg               : STD_LOGIC := '0';
    signal Update_Flag_Reg             : STD_LOGIC := '0';
    signal IN_Port_Reg                 : STD_LOGIC := '0';
    signal Mem_Write_Reg               : STD_LOGIC := '0';
    signal J_SC_Reg                    : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');
	 signal Opcode_Reg                  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
	 signal DM_Reg                      : STD_LOGIC := '0';
	 signal Out_Port_Reg                : STD_LOGIC := '0';
	 
begin

    process (clk, rst)
	 
    begin
	 
        if rst = '1' then
		  
            Pc_Reg           <= (others => '0');
            Read_Addr1_Reg   <= (others => '0');
            Read_Addr2_Reg   <= (others => '0');
            Interrupt_Reg    <= '0';
            Rd_Addr_Reg      <= (others => '0');
            Imm_Offset_Reg   <= (others => '0');
            Rsrc1_Data_Reg   <= (others => '0');
            Rsrc2_Data_Reg   <= (others => '0');
            Swap_Reg         <= '0';
            Set_Carry_Reg    <= '0';
            Sp_Inc_Reg       <= '0';
            Sp_Dec_Reg       <= '0';
            Sp_Enable_Reg    <= '0';
            RTI_Reg          <= '0';
            Return_Signal_Reg<= '0';
            Call_Reg         <= '0';
            ALU_Srcl_Reg     <= '0';
            Branch_Reg       <= '0';
            Mem_Read_Reg     <= '0';
            Reg_Write_Reg    <= '0';
            Update_Flag_Reg  <= '0';
            IN_Port_Reg      <= '0';
            Mem_Write_Reg    <= '0';
            J_SC_Reg         <= (others => '0');
				Opcode_Reg       <= (others => '0');
				DM_Reg           <= '0';
				Out_Port_Reg     <= '0';

            --Mem_Read       <= '0';
--            Interrupt      <= '0';
--            Reg1_Data      <= (others => '0');
--            Reg2_Data      <= (others => '0');
--            Swap           <= '0';
--            Rsrc1          <= (others => '0');
--				Rsrc2          <= (others => '0');
--				Rd             <= (others => '0');
--            Reg_Write      <= '0';
--            IN_Port        <= '0';
--            Pc             <= (others => '0');
--            Set_Carry      <= '0';
--            Sp_Inc         <= '0';
--            Sp_Dec         <= '0';
--            Sp_Enable      <= '0';
--            RTI            <= '0';
--            Return_Signal  <= '0';
--            Call           <= '0';
--            ALU_Srcl       <= '0';
--            Branch         <= '0';
--            Update_Flag    <= '0';
--            Mem_Write      <= '0';
--            J_SC           <= (others => '0');
--				ALU_SLC        <= (others => '0');
--				DM             <= '0';
--				Imm_Offset     <= (others => '0');
--				Out_Port       <= '0';

        elsif rising_edge(clk) then
		  
            if enable = '1' then
				
                Pc_Reg           <= Pc_In;
                Read_Addr1_Reg   <= Read_Addr1_In;
                Read_Addr2_Reg   <= Read_Addr2_In;
                Interrupt_Reg    <= Interrupt_In;
                Rd_Addr_Reg      <= Rd_Addr_In;
                Imm_Offset_Reg   <= Imm_Offset_In;
                Rsrc1_Data_Reg   <= Rsrc1_Data_In;
                Rsrc2_Data_Reg   <= Rsrc2_Data_In;
                Swap_Reg         <= Swap_In;
                Set_Carry_Reg    <= Set_Carry_In;
                Sp_Inc_Reg       <= Sp_Inc_In;
                Sp_Dec_Reg       <= Sp_Dec_In;
                Sp_Enable_Reg    <= Sp_Enable_In;
                RTI_Reg          <= RTI_In;
                Return_Signal_Reg<= Return_Signal_In;
                Call_Reg         <= Call_In;
                ALU_Srcl_Reg     <= ALU_Srcl_In;
                Branch_Reg       <= Branch_In;
                Mem_Read_Reg     <= Mem_Read_In;
                Reg_Write_Reg    <= Reg_Write_In;
                Update_Flag_Reg  <= Update_Flag_In;
                IN_Port_Reg      <= IN_Port_In;
                Mem_Write_Reg    <= Mem_Write_In;
                J_SC_Reg         <= J_SC_In;
					 Opcode_Reg       <= Opcode_In;
					 DM_Reg           <= DM_In;
					 Out_Port_Reg     <= Out_Port_In;
					 
            end if;

        elsif falling_edge(clk) then
			
				Mem_Read       <= Mem_Read_Reg;
            Interrupt      <= Interrupt_IN;
            Reg1_Data      <= Rsrc1_Data_IN;
            Reg2_Data      <= Rsrc2_Data_IN;
            Swap           <= Swap_IN;
            Rsrc1          <= Read_Addr1_IN;
				Rsrc2          <= Read_Addr2_IN;
				Rd             <= Rd_Addr_IN;
            Reg_Write      <= Reg_Write_IN;
            IN_Port        <= IN_Port_IN;
            Pc             <= Pc_IN;
            Set_Carry      <= Set_Carry_IN;
            Sp_Inc         <= Sp_Inc_IN;
            Sp_Dec         <= Sp_Dec_IN;
            Sp_Enable      <= Sp_Enable_IN;
            RTI            <= RTI_IN;
            Return_Signal  <= Return_Signal_IN;
            Call           <= Call_IN;
            ALU_Srcl       <= ALU_Srcl_IN;
            Branch         <= Branch_IN;
            Update_Flag    <= Update_Flag_IN;
            Mem_Write      <= Mem_Write_IN;
            J_SC           <= J_SC_IN;
				ALU_SLC        <= Opcode_IN;
				DM             <= DM_IN;
				
				Out_Port       <= Out_Port_IN;
            
				
        end if;
		  
    end process; 
	 Imm_Offset     <= Imm_Offset_Reg;
	 
end Behavioral;