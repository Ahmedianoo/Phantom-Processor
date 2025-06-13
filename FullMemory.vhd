LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY UnifiedMemory IS
    GENERIC (
        Address_bits : INTEGER := 12;  -- 12 bits = 4096 memory locations
        Data_width   : INTEGER := 32   -- 32-bit data width
    );
    PORT (
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;

        -- Instruction memory interface
        PC              : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
        Instruction     : OUT STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
        
        -- Data memory control signals
        Mem_Read        : IN STD_LOGIC;
        Mem_Write       : IN STD_LOGIC;

        -- Address inputs for data memory
        DM_address      : IN STD_LOGIC;  -- Selector for address source
        ALU_result      : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
        SP_Load         : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
        SP_INC          : IN STD_LOGIC;
        Call            : IN STD_LOGIC;

        -- Data inputs
        Rsrc1           : IN STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
        PC_Flag_1       : IN STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);

        -- Data memory output
        Read_data       : OUT STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF UnifiedMemory IS
    -- Memory array to hold both instructions and data
    TYPE memory_array IS ARRAY (0 TO 2**Address_bits - 1) OF STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
    SIGNAL memory : memory_array := (OTHERS => (OTHERS => '0'));
    
    -- Internal signals for memory operations
    SIGNAL WriteAddress : STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
    SIGNAL ReadAddress  : STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
    SIGNAL Write_data   : STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
BEGIN
    -- Address MUX logic for write address selection
    PROCESS(DM_address, ALU_result, SP_Load)
    BEGIN
        IF DM_address = '1' THEN
            WriteAddress <= SP_Load;
        ELSE
            WriteAddress <= ALU_result;
        END IF;
    END PROCESS;

    -- Address MUX logic for read address selection
    PROCESS(SP_INC, ALU_result, SP_Load)
    BEGIN
        IF SP_INC = '1' THEN
            ReadAddress <= SP_Load;
        ELSE
            ReadAddress <= ALU_result;
        END IF;
    END PROCESS;

    -- Data MUX logic for write data selection
    PROCESS(Call, Rsrc1, PC_Flag_1)
    BEGIN
        IF Call = '1' THEN
            Write_data <= PC_Flag_1;
        ELSE
            Write_data <= Rsrc1;
        END IF;
    END PROCESS;

    -- Memory Write process (only for data memory)
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF Mem_Write = '1' THEN
                memory(to_integer(unsigned(WriteAddress))) <= Write_data;
            END IF;
        END IF;
    END PROCESS;

    -- Data Memory Read process
    PROCESS(clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF Mem_Read = '1' THEN
                Read_data <= memory(to_integer(unsigned(ReadAddress)));
            ELSE
                Read_data <= (OTHERS => 'Z');  -- Tri-state if not reading
            END IF;
        END IF;
    END PROCESS;
    
    -- Instruction Memory Read (combinational)
    -- This provides continuous access to instructions without requiring Mem_Read signal
    Instruction <= memory(to_integer(unsigned(PC)));

END ARCHITECTURE;