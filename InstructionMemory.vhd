--------InstructionMemory
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory is
    Port (        
        PC 		  : in STD_LOGIC_VECTOR (11 downto 0); 
		  data_bus : out STD_LOGIC_VECTOR ( 31 downto 0)
		  
    );
end InstructionMemory;



architecture Behavioral of InstructionMemory is


    type memory_array is array (0 to 4095) of STD_LOGIC_VECTOR(31 downto 0); 
    signal ROM : memory_array := (others => (others => '0'));  

begin
    
    data_bus <= ROM(to_integer(unsigned(PC)));


end Behavioral;


 
