library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Flag_Update is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        update_flag : in  STD_LOGIC;
        zero_flag   : in  STD_LOGIC;
        negative_flag: in  STD_LOGIC;
        carry_flag  : in  STD_LOGIC;
        CCR_out     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end Flag_Update;
architecture Behavioral of Flag_Update is
    signal CCR_reg : STD_LOGIC_VECTOR(3 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            CCR_reg <= (others => '0');  
        elsif rising_edge(clk) then
            if update_flag = '1' then
                CCR_reg(0) <= zero_flag;
                CCR_reg(1) <= negative_flag;
                CCR_reg(2) <= carry_flag;
                CCR_reg(3) <= '0';  -- Reserved bit
            end if;
        end if;
    end process;

    CCR_out <= CCR_reg;

end Behavioral;