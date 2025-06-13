LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY Memory IS
    GENERIC (
        Address_bits : INTEGER := 12;
        Data_width   : INTEGER := 32
    );
    PORT (
        clk             : IN STD_LOGIC;
        reset           : IN STD_LOGIC;

        -- Control signals
        Mem_Read        : IN STD_LOGIC;
        Mem_Write       : IN STD_LOGIC;

        -- Address inputs
        DM_address      : IN STD_LOGIC;
        ALU_result      : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
        SP_Load         : IN STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
        SP_INC          : IN STD_LOGIC;
        Call            : IN STD_LOGIC;

        -- Data inputs
        Rsrc1           : IN STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
        PC_Flag_1        : IN STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);

        -- Data memory interface
        Read_data       : OUT STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE Behavioral OF Memory IS
    TYPE memory_array IS ARRAY (0 TO 2**Address_bits - 1) OF STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
    SIGNAL memory : memory_array := (OTHERS => (OTHERS => '0'));

    SIGNAL WriteAddress : STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
    SIGNAL ReadAddress  : STD_LOGIC_VECTOR(Address_bits - 1 DOWNTO 0);
    SIGNAL Write_data   : STD_LOGIC_VECTOR(Data_width - 1 DOWNTO 0);
BEGIN

    -- Address MUX logic
    PROCESS( DM_address, ALU_result, SP_Load)
    BEGIN
        if DM_address='1' then
            WriteAddress <= SP_Load;
        else
            WriteAddress <= ALU_result;
        end if;
    END PROCESS;

    PROCESS( SP_INC, ALU_result, SP_Load)
    BEGIN
        if SP_INC='1' then
            ReadAddress <= SP_Load;
        else
            ReadAddress <= ALU_result;
        end if;
    END PROCESS;

    -- Data MUX logic
    PROCESS(Call, Rsrc1, PC_Flag_1)
    BEGIN
        if Call='1' then
            Write_data <= PC_Flag_1;
        else
            Write_data <= Rsrc1;
        end if;
    END PROCESS;

    -- Memory Write process
    PROCESS(clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF Mem_Write = '1' THEN
                memory(to_integer(unsigned(WriteAddress))) <= Write_data;
            END IF;
        END IF;
    END PROCESS;

    -- Combinational Memory Read
    PROCESS(ReadAddress, Mem_Read,clk)
    BEGIN
        IF falling_edge(clk) THEN
            IF Mem_Read = '1' THEN
                Read_data <= memory(to_integer(unsigned(ReadAddress)));
            ELSE
                Read_data <= (OTHERS => 'Z');  -- Tri-state if not reading
            END IF;
        end if;
    END PROCESS;

END ARCHITECTURE;