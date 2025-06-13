library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity stack_pointer is
    Port ( 
        -- Control signals
        clk         : in STD_LOGIC;
        rst         : in STD_LOGIC;
        SP_enable   : in STD_LOGIC;
        SP_INC      : in STD_LOGIC;  -- Pop operation
        SP_DEC      : in STD_LOGIC;  -- Push operation
        SP_mem      : in STD_LOGIC_VECTOR(11 downto 0);  -- SP from memory stage
        
        -- Output
        SP_out      : out STD_LOGIC_VECTOR(11 downto 0)
    );
end stack_pointer;

architecture Behavioral of stack_pointer is
    -- Internal signals
    signal SP_reg   : STD_LOGIC_VECTOR(11 downto 0); -- Current SP value
    signal SP_next  : STD_LOGIC_VECTOR(11 downto 0); -- Next SP value
    signal SP_inc_result : STD_LOGIC_VECTOR(11 downto 0); -- SP + 1
    signal SP_dec_result : STD_LOGIC_VECTOR(11 downto 0); -- SP - 1

begin
    -- Calculate increment result (for pop)
    SP_inc_result <= STD_LOGIC_VECTOR(unsigned(SP_reg) + 1);
    
    -- Calculate decrement result (for push)
    SP_dec_result <= STD_LOGIC_VECTOR(unsigned(SP_mem) - 1);
    
  
    process(SP_INC, SP_inc_result)
    begin
       
            if (SP_INC = '1') then
                -- Pop operation: SP = SP + 1
                 SP_out <= SP_inc_result;
            else
                -- Push operation: SP = SP from memory
                 SP_out <= SP_reg;
          
            end if;
      
    end process;
    -- next SP value logic
    process(SP_DEC,Sp_mem,SP_dec_result)
    begin
        if (SP_enable = '1') then
          if (SP_DEC = '1') then
                
                SP_next <= SP_dec_result;
            else
               
                SP_next <= SP_mem;
            end if;
        else
           
            SP_next <= SP_reg;
        end if;
    end process;
    -- Register process
    process(clk, rst)
    begin
        if (rst = '1') then
            SP_reg <= (others => '0');
        elsif rising_edge(clk) then
            SP_reg <= SP_next;
        end if;
    end process;
    
 

    
end Behavioral;