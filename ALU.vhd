library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        -- Inputs
        operand1 : in  STD_LOGIC_VECTOR(31 downto 0);  -- First operand
        operand2 : in  STD_LOGIC_VECTOR(31 downto 0);  -- Second operand
        ALU_OP   : in  STD_LOGIC_VECTOR(4 downto 0);   -- Operation select
        offset   : in  STD_LOGIC_VECTOR(15 downto 0);  -- Offset for address calculation
        Imm      : in  STD_LOGIC_VECTOR(15 downto 0);  -- Immediate value
        
        -- Outputs
        ALU_OUT  : out STD_LOGIC_VECTOR(31 downto 0);  -- ALU result
        CCR      : out STD_LOGIC_VECTOR(3 downto 0)    -- Condition Code Register (Z, N, C flags)
        -- zero flag = CCR(0)
        -- negative flag = CCR(1)
        -- carry flag = CCR(2)
    );
end ALU;

architecture Behavioral of ALU is
    -- Internal signals
    signal result          : STD_LOGIC_VECTOR(31 downto 0);
    signal result_unsigned : unsigned(32 downto 0);  -- 33 bits to capture carry
    signal A_unsigned      : unsigned(32 downto 0);
    signal B_unsigned      : unsigned(32 downto 0);
    signal carry_out       : STD_LOGIC;
    
    -- Flag signals
    signal zero_flag       : STD_LOGIC;
    signal negative_flag   : STD_LOGIC;
    signal carry_flag      : STD_LOGIC;
    signal current_flags   : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- To store current flag values
    signal update_z        : STD_LOGIC;  -- Whether to update Zero flag
    signal update_n        : STD_LOGIC;  -- Whether to update Negative flag
    signal update_c        : STD_LOGIC;  -- Whether to update Carry flag

    -- Sign-extended immediate value signals
    signal imm_sign_extended : STD_LOGIC_VECTOR(31 downto 0); 
    signal offset_sign_extended : STD_LOGIC_VECTOR(31 downto 0);

begin
    -- Extend A and B to 33 bits for carry detection
    A_unsigned <= unsigned('0' & operand1);
    B_unsigned <= unsigned('0' & operand2);
    
    -- Sign extension logic for immediate values 
    imm_sign_extended <= (31 downto 16 => Imm(15)) & Imm; 
    offset_sign_extended <= (31 downto 16 => offset(15)) & offset; 
    
    -- Main ALU operation logic
    process(operand1, operand2, ALU_OP, A_unsigned, B_unsigned, offset, Imm, imm_sign_extended, offset_sign_extended, result_unsigned)
    begin
        -- Default values
        result <= (others => '0');
        carry_out <= '0';
        result_unsigned <= (others => '0');
        
        -- Default flag update behavior
        update_z <= '0';  -- Don't update by default
        update_n <= '0';  -- Don't update by default
        update_c <= '0';  -- Don't update by default
        
        case ALU_OP is
            when "00000" =>  -- NOP
                -- No operation, output remains default
                result <= (others => '0');
                -- NOP does not update flags
                
            when "00010" =>  -- SETC
                -- Set carry flag
                result <= (others => '0');
                carry_out <= '1';
                update_c <= '1';  -- Only update carry flag
                
            when "00011" =>  -- NOT
                -- Bitwise NOT
                result <= not operand1;
                update_z <= '1';  -- Update zero flag
                update_n <= '1';  -- Update negative flag
                
            when "00100" =>  -- INC
                -- Increment
                result_unsigned <= A_unsigned + 1;
                result <= std_logic_vector(result_unsigned(31 downto 0));
                carry_out <= result_unsigned(32);
                update_z <= '1';  -- Update zero flag
                update_n <= '1';  -- Update negative flag
                update_c <= '1';  -- Update carry flag
                
            when "00111" =>  -- MOV
                -- Move (pass B to output)
                result <= operand2;
                update_z <= '0';  -- MOV does not update flags
                update_n <= '0';
                update_c <= '0';
                
            when "01001" =>  -- ADD
                -- Add A and B
                result_unsigned <= A_unsigned + B_unsigned; 
                result <= std_logic_vector(unsigned(operand1) + unsigned(operand2));
                carry_out <= result_unsigned(32);
                update_z <= '1';  -- Update zero flag
                update_n <= '1';  -- Update negative flag
                update_c <= '1';  -- Update carry flag
                
            when "01010" =>  -- SUB
                -- Subtract B from A
                result <= std_logic_vector(unsigned(operand1) - unsigned(operand2));
                -- Calculate carry for subtraction
                if unsigned(operand1) >= unsigned(operand2) then
                    carry_out <= '0';  -- No borrow needed (A >= B)
                else
                    carry_out <= '1';  -- Borrow needed (A < B)
                end if;
                update_z <= '1';  -- Update zero flag
                update_n <= '1';  -- Update negative flag
                update_c <= '1';  -- Update carry flag
                
            when "01011" =>  -- AND
                -- Bitwise AND
                result <= operand1 and operand2;
                update_z <= '1';  -- Update zero flag
                update_n <= '1';  -- Update negative flag
                
            when "01100" =>  -- IADD
                -- sign-extended immediate add 
                result <= std_logic_vector(unsigned(operand1) + unsigned(imm_sign_extended)); 
                
                -- Check for overflow/carry 
                if (unsigned(operand1) + unsigned(imm_sign_extended)) > x"FFFFFFFF" then 
                    carry_out <= '1';
                else
                    carry_out <= '0';
                end if;
                update_z <= '1';  -- Update zero flag
                update_n <= '1';  -- Update negative flag
                update_c <= '1';  -- Update carry flag
                
            when "10000" | "10001" =>  -- ADDRESS for load/store
                -- Address calculation with proper sign extension 
                result <= std_logic_vector(unsigned(operand1) + unsigned(offset_sign_extended)); 
                -- LDD/STD does not update flags
            
            when "10010" | "10011" | "10100" | "10101" | "10110" | "11000" =>  -- jz/jn/jc/jmp/call/int
                -- Zero-extended immediate for branch targets 
                result <= x"0000" & imm;  -- Immediate value to result
                -- Branch operations don't update flags
                
            when others =>
                -- Undefined operation
                result <= (others => '0');
        end case;
    end process;
    
    -- Calculate flag values
    zero_flag <= '1' when result = x"00000000" else '0';  -- Zero flag
    negative_flag <= result(31);                          -- Negative flag (MSB)
    carry_flag <= carry_out;                              -- Carry flag
    
    -- Assign outputs
    ALU_OUT <= result;
    
    -- Flag update process
    process(zero_flag, negative_flag, carry_flag, update_z, update_n, update_c, current_flags)
        variable new_flags : STD_LOGIC_VECTOR(3 downto 0);
    begin
        -- Start with current flags
        new_flags := current_flags;
        
        -- Update only the flags that should be updated based on the instruction
        if update_z = '1' then
            new_flags(0) := zero_flag;
        end if;
        
        if update_n = '1' then
            new_flags(1) := negative_flag;
        end if;
        
        if update_c = '1' then
            new_flags(2) := carry_flag;
        end if;
        
        new_flags(3) := '0';  -- Reserved bit is always 0
        
        -- Output the updated flags
        CCR <= new_flags;
    end process;
    
    -- Process to update current_flags
    process(result, zero_flag, negative_flag, carry_flag, update_z, update_n, update_c)
    begin
        if update_z = '1' then
            current_flags(0) <= zero_flag;
        end if;
        
        if update_n = '1' then
            current_flags(1) <= negative_flag;
        end if;
        
        if update_c = '1' then
            current_flags(2) <= carry_flag;
        end if;
        
        current_flags(3) <= '0';  -- Reserved bit
    end process;
    
end Behavioral;