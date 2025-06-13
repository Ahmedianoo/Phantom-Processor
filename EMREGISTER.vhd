library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ExecuteMemory is

    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        enable          : in  STD_LOGIC;

        Mem_Read_In        : in STD_LOGIC;
        Interrupt_In       : in STD_LOGIC;
        ALU_Result_In      : in STD_LOGIC_VECTOR(31 downto 0);
        Sp_Load_In         : in STD_LOGIC_vector(11 downto 0);
        Swap_In            : in STD_LOGIC;
        Rsrc1_In           : in STD_LOGIC_VECTOR(2 downto 0);
		  Rsrc2_In           : in STD_LOGIC_VECTOR(2 downto 0);
		  Rd_In              : in STD_LOGIC_VECTOR(2 downto 0);
        Reg1_Data_In       : in STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data_In       : in STD_LOGIC_VECTOR(31 downto 0);
        Reg_Write_In       : in STD_LOGIC;
        IN_Port_In         : in STD_LOGIC;
        Pc_In              : in STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry_In       : in STD_LOGIC;
        Sp_Inc_In          : in STD_LOGIC;
        Sp_Dec_In          : in STD_LOGIC;
        Sp_Enable_In       : in STD_LOGIC;
        Branch_In          : in STD_LOGIC;
        Update_Flag_In     : in STD_LOGIC;
        Mem_Write_In       : in STD_LOGIC;
        RTI_In             : in STD_LOGIC;
        Return_Signal_In   : in STD_LOGIC;
		  DM_IN              : in STD_LOGIC;
		  Imm_Offset_In      : in STD_LOGIC_VECTOR(15 downto 0);
		  Out_Port_In        : in STD_LOGIC;
          call_In            : in STD_LOGIC;
        -- Outputs
        RTI            : out STD_LOGIC;
        Mem_Read       : out STD_LOGIC;
        Return_Signal  : out STD_LOGIC;
        Mem_Write      : out STD_LOGIC;
        ALU_Result     : out STD_LOGIC_VECTOR(31 downto 0);
        Sp_Load        : out STD_LOGIC_VECTOR( 11 downto 0);
        Rsrc1          : out STD_LOGIC_VECTOR(2 downto 0);
		  Rsrc2          : out STD_LOGIC_VECTOR(2 downto 0);
		  Rd             : out STD_LOGIC_VECTOR(2 downto 0);
        Pc             : out STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry      : out STD_LOGIC;
        Sp_Inc         : out STD_LOGIC;
        Sp_Dec         : out STD_LOGIC;
        Sp_Enable      : out STD_LOGIC;
        Branch         : out STD_LOGIC;
        Update_Flag    : out STD_LOGIC;
        Reg1_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Swap           : out STD_LOGIC;
        Reg_Write      : out STD_LOGIC;
        IN_Port        : out STD_LOGIC;
        call_out       : out STD_LOGIC;
		  DM_Addr        : out STD_LOGIC;
		  Index          : out STD_LOGIC_VECTOR(15 downto 0);
		  Out_Port       : out STD_LOGIC
    );
	 
end ExecuteMemory;

architecture Behavioral of ExecuteMemory is

    signal Mem_Read_Reg        : STD_LOGIC := '0';
    signal Interrupt_Reg       : STD_LOGIC := '0';
    signal ALU_Result_Reg      : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Sp_Load_Reg         : STD_LOGIC_vector(11 downto 0) := (others => '0');
    signal Swap_Reg            : STD_LOGIC := '0';
    signal Rsrc1_Reg           : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
	 signal Rsrc2_Reg           : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
	 signal Rd_Reg              : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Reg1_Data_Reg       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Reg2_Data_Reg       : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Reg_Write_Reg       : STD_LOGIC := '0';
    signal IN_Port_Reg         : STD_LOGIC := '0';
    signal Pc_Reg              : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Set_Carry_Reg       : STD_LOGIC := '0';
    signal Sp_Inc_Reg          : STD_LOGIC := '0';
    signal Sp_Dec_Reg          : STD_LOGIC := '0';
    signal Sp_Enable_Reg       : STD_LOGIC := '0';
    signal Branch_Reg          : STD_LOGIC := '0';
    signal Update_Flag_Reg     : STD_LOGIC := '0';
    signal Mem_Write_Reg       : STD_LOGIC := '0';
    signal RTI_Reg             : STD_LOGIC := '0';
    signal Return_Signal_Reg   : STD_LOGIC := '0';
	 signal DM_Reg              : STD_LOGIC := '0';
	 signal Imm_Offset_Reg      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
	 signal Out_Port_Reg        : STD_LOGIC := '0';
     signal call_Reg            : STD_LOGIC := '0';
	 
begin

    process (clk, rst)
	 
    begin
	 
        if rst = '1' then
		    call_Reg <= '0';
            Mem_Read_Reg      <= '0';
            Interrupt_Reg     <= '0';
            ALU_Result_Reg    <= (others => '0');
            Sp_Load_Reg       <= (others => '0');
            Swap_Reg          <= '0';
            Rsrc1_Reg         <= (others => '0');
				Rsrc2_Reg         <= (others => '0');
				Rd_Reg            <= (others => '0');
            Reg1_Data_Reg     <= (others => '0');
            Reg2_Data_Reg     <= (others => '0');
            Reg_Write_Reg     <= '0';
            IN_Port_Reg       <= '0';
            Pc_Reg            <= (others => '0');
            Set_Carry_Reg     <= '0';
            Sp_Inc_Reg        <= '0';
            Sp_Dec_Reg        <= '0';
            Sp_Enable_Reg     <= '0';
            Branch_Reg        <= '0';
            Update_Flag_Reg   <= '0';
            Mem_Write_Reg     <= '0';
            RTI_Reg           <= '0';
            Return_Signal_Reg <= '0';
				DM_Reg            <= '0';
				Imm_Offset_Reg    <= (others => '0');
				Out_Port_Reg      <= '0';

--            RTI            <= '0';
--            Mem_Read       <= '0';
--            Return_Signal  <= '0';
--            Mem_Write      <= '0';
--            ALU_Result     <= (others => '0');
--            Sp_Load        <= (others => '0');
--            Rsrc1          <= (others => '0');
--				Rsrc2          <= (others => '0');
--				Rd             <= (others => '0');
--            Pc             <= (others => '0');
--            Set_Carry      <= '0';
--            Sp_Inc         <= '0';
--            Sp_Dec         <= '0';
--            Sp_Enable      <= '0';
--            Branch         <= '0';
--            Update_Flag    <= '0';
--            Reg1_Data      <= (others => '0');
--            Reg2_Data      <= (others => '0');
--            Swap           <= '0';
--            Reg_Write      <= '0';
--            IN_Port        <= '0';
--				DM_Addr        <= '0';
--				Index          <= (others => '0');
--				Out_Port       <= '0';

        elsif rising_edge(clk) then
		  
            if enable = '1' then
				call_Reg <= call_In;
                Mem_Read_Reg      <= Mem_Read_In;
                Interrupt_Reg     <= Interrupt_In;
                ALU_Result_Reg    <= ALU_Result_In;
                Sp_Load_Reg       <= Sp_Load_In;
                Swap_Reg          <= Swap_In;
                Rsrc1_Reg         <= Rsrc1_In;
					 Rsrc2_Reg         <= Rsrc2_In;
					 Rd_Reg            <= Rd_In;
                Reg1_Data_Reg     <= Reg1_Data_In;
                Reg2_Data_Reg     <= Reg2_Data_In;
                Reg_Write_Reg     <= Reg_Write_In;
                IN_Port_Reg       <= IN_Port_In;
                Pc_Reg            <= Pc_In;
                Set_Carry_Reg     <= Set_Carry_In;
                Sp_Inc_Reg        <= Sp_Inc_In;
                Sp_Dec_Reg        <= Sp_Dec_In;
                Sp_Enable_Reg     <= Sp_Enable_In;
                Branch_Reg        <= Branch_In;
                Update_Flag_Reg   <= Update_Flag_In;
                Mem_Write_Reg     <= Mem_Write_In;
                RTI_Reg           <= RTI_In;
                Return_Signal_Reg <= Return_Signal_In;
					 DM_Reg            <= DM_In;
					 Imm_Offset_Reg    <= Imm_Offset_In;
					 Out_Port_Reg      <= Out_Port_In;
					 
            end if;

        elsif falling_edge(clk) then
				RTI            <= RTI_IN;
            Mem_Read       <= Mem_Read_IN;
            Return_Signal  <= Return_Signal_IN;
            Mem_Write      <= Mem_Write_IN;
            ALU_Result     <= ALU_Result_IN;
            Sp_Load        <= Sp_Load_IN;
            Rsrc1          <= Rsrc1_IN;
				Rsrc2          <= Rsrc2_IN;
				Rd             <= Rd_IN;
            Pc             <= Pc_IN;
            Set_Carry      <= Set_Carry_IN;
            Sp_Inc         <= Sp_Inc_IN;
            Sp_Dec         <= Sp_Dec_IN;
            Sp_Enable      <= Sp_Enable_IN;
            Branch         <= Branch_IN;
            Update_Flag    <= Update_Flag_IN;
            Reg1_Data      <= Reg1_Data_IN;
            Reg2_Data      <= Reg2_Data_IN;
            Swap           <= Swap_IN;
            Reg_Write      <= Reg_Write_IN;
            IN_Port        <= IN_Port_IN;
				DM_Addr        <= DM_IN;
				Index          <= Imm_Offset_IN;
				Out_Port       <= Out_Port_IN;
            
				
        end if;
		  
    end process;
	 
			
	 
end Behavioral;
