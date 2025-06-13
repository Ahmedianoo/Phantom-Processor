library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CCR is
    port (
        clk              : in std_logic;
        reset            : in std_logic;
        update_flag      : in std_logic;
        Carry_in         : in std_logic;
        Return_flags     : in std_logic_vector(3 downto 0);
        RTI_Restore_flags: in std_logic;
        CCR_out          : out std_logic_vector(3 downto 0);
        CCR_in           : in std_logic_vector(3 downto 0)
    );
end entity;

architecture Behavioral of CCR is
    signal CCR_reg : std_logic_vector(3 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            CCR_reg <= (others => '0');  -- Clear on reset
        elsif rising_edge(clk) then
            if RTI_Restore_flags = '1' then
                CCR_reg <= Return_flags;
            elsif update_flag = '1' then
                CCR_reg <= CCR_in;
            end if;

            if Carry_in = '1' then
                CCR_reg(0) <= '1';
            else 
                CCR_reg(0) <= CCR_Reg(0);    
            end if;
        end if;
    end process;

    CCR_out <= CCR_reg;

end architecture Behavioral;
