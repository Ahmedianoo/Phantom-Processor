library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MemoryWrite is
    Port (
        clk          : in  STD_LOGIC;
        rst          : in  STD_LOGIC;
        en           : in  STD_LOGIC;

        Read_Data_In     : in STD_LOGIC_VECTOR(31 downto 0);
        ALU_Result_In    : in STD_LOGIC_VECTOR(31 downto 0);
        Mem_Read_In      : in STD_LOGIC;
        Rsrc1_In         : in STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2_In         : in STD_LOGIC_VECTOR(2 downto 0);
        Rd_In            : in STD_LOGIC_VECTOR(2 downto 0);
        Reg1_Data_In     : in STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data_In     : in STD_LOGIC_VECTOR(31 downto 0);
        Swap_In          : in STD_LOGIC;
        Reg_Write_In     : in STD_LOGIC;
        IN_Port_In       : in STD_LOGIC;
        Out_Port_In      : in STD_LOGIC;

        Read_Data     : out STD_LOGIC_VECTOR(31 downto 0);
        ALU_Result    : out STD_LOGIC_VECTOR(31 downto 0);
        Rd            : out STD_LOGIC_VECTOR(2 downto 0);
        Rsrc1         : out STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2         : out STD_LOGIC_VECTOR(2 downto 0);
        Mem_Read      : out STD_LOGIC;
        Reg1_Data     : out STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data     : out STD_LOGIC_VECTOR(31 downto 0);
        Swap          : out STD_LOGIC;
        Reg_Write     : out STD_LOGIC;
        IN_Port       : out STD_LOGIC;
        Out_Port      : out STD_LOGIC
    );
end MemoryWrite;

architecture Behavioral of MemoryWrite is
    -- Internal registers to store input values
    signal Read_Data_Reg     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALU_Result_Reg    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Mem_Read_Reg      : STD_LOGIC := '0';
    signal Rsrc1_Reg         : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Rsrc2_Reg         : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Rd_Reg            : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Reg1_Data_Reg     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Reg2_Data_Reg     : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal Swap_Reg          : STD_LOGIC := '0';
    signal Reg_Write_Reg     : STD_LOGIC := '0';
    signal IN_Port_Reg       : STD_LOGIC := '0';
    signal Out_Port_Reg      : STD_LOGIC := '0';
     
begin
    -- Sequential process for register updates
    process (clk, rst)
    begin
        if rst = '1' then
            -- Reset all registers to default values
            Read_Data_Reg   <= (others => '0');
            ALU_Result_Reg  <= (others => '0');
            Mem_Read_Reg    <= '0';
            Rsrc1_Reg       <= (others => '0');
            Rsrc2_Reg       <= (others => '0');
            Rd_Reg          <= (others => '0');
            Reg1_Data_Reg   <= (others => '0');
            Reg2_Data_Reg   <= (others => '0');
            Swap_Reg        <= '0';
            Reg_Write_Reg   <= '0';
            IN_Port_Reg     <= '0';
            Out_Port_Reg    <= '0';
        elsif rising_edge(clk) then
            -- On rising edge, update registers if enabled
            if en = '1' then
                Read_Data_Reg   <= Read_Data_In;
                ALU_Result_Reg  <= ALU_Result_In;
                Mem_Read_Reg    <= Mem_Read_In;
                Rsrc1_Reg       <= Rsrc1_In;
                Rsrc2_Reg       <= Rsrc2_In;
                Rd_Reg          <= Rd_In;
                Reg1_Data_Reg   <= Reg1_Data_In;
                Reg2_Data_Reg   <= Reg2_Data_In;
                Swap_Reg        <= Swap_In;
                Reg_Write_Reg   <= Reg_Write_In;
                IN_Port_Reg     <= IN_Port_In;
                Out_Port_Reg    <= Out_Port_In;
            end if;
		elsif falling_edge(clk) then
			 Read_Data   <= Read_Data_Reg;
			 ALU_Result  <= ALU_Result_Reg;
			 Rd          <= Rd_Reg;
			 Rsrc1       <= Rsrc1_Reg;
			 Rsrc2       <= Rsrc2_Reg;
			 Mem_Read    <= Mem_Read_Reg;
			 Reg1_Data   <= Reg1_Data_Reg;
			 Reg2_Data   <= Reg2_Data_Reg;
			 Swap        <= Swap_Reg;
			 Reg_Write   <= Reg_Write_Reg;
			 IN_Port     <= IN_Port_Reg;
        end if;
    end process;
   
    -- Continuous assignments for outputs
    -- Output values are directly driven by the register values
 
    Out_Port    <= Out_Port_Reg;
     
end Behavioral;