library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg is

    generic(
        address_bits : integer := 3; 
        word_width   : integer := 32   
    );
	 
    port(
        clk          : in std_logic;
        rst          : in std_logic;
		  we1           : in std_logic;
        address_sel_sw  : in std_logic;  
		  we2_swap      : in std_logic;
		  
        write_address_1   : in std_logic_vector(address_bits-1 downto 0);
		  write_address_2   : in std_logic_vector(address_bits-1 downto 0);
		  
        read_address_1   : in std_logic_vector(address_bits-1 downto 0);
        read_address2_1  : in std_logic_vector(address_bits-1 downto 0);
		  read_address2_2  : in std_logic_vector(address_bits-1 downto 0);
		  
        data_in_1      : in std_logic_vector(word_width-1 downto 0);
		  data_in_2      : in std_logic_vector(word_width-1 downto 0);
		  
        data_out1    : out std_logic_vector(word_width-1 downto 0);
        data_out2    : out std_logic_vector(word_width-1 downto 0)
    );
	 
end entity Reg;



architecture behavioral of Reg is

    type reg_array is array (0 to (2**address_bits)-1) of std_logic_vector(word_width-1 downto 0);
    signal REGISTERS : reg_array;
	 signal read_address1: std_logic_vector(address_bits-1 downto 0);
	 signal read_address2: std_logic_vector(address_bits-1 downto 0);
	 

begin

    process(clk, rst)
    begin
	 
        if rst = '1' then
            
            for i in 0 to (2**address_bits)-1 loop
				
                REGISTERS(i) <= (others => '0');
					 
            end loop;
				

        elsif rising_edge(clk) then
		  
            if we1 = '1' and we2_swap = '1' then
				
                REGISTERS(to_integer(unsigned(write_address_1))) <= data_in_1;
					 REGISTERS(to_integer(unsigned(write_address_2))) <= data_in_2;
				
				elsif	 we1 = '1' then
					 REGISTERS(to_integer(unsigned(write_address_1))) <= data_in_1;
			 
            end if;
				
				if address_sel_sw = '0' then
				read_address1 <= read_address_1;
				read_address2 <= read_address2_1;

				else
				
				read_address1 <= read_address2_2;
				read_address2 <= read_address_1;
				
				end if;
				
        end if;
    end process;
	 
	 
	
	 
    data_out1 <= REGISTERS(to_integer(unsigned(read_address1)));
    data_out2 <= REGISTERS(to_integer(unsigned(read_address2)));

end architecture behavioral;
