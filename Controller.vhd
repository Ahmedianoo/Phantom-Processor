	-- Controller
	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

	entity Controller is
		Port (
			opcode      : in  STD_LOGIC_VECTOR(4 downto 0);
			-- Execution control
			RegWrite    : out STD_LOGIC;
			      
			immediate_Value_signal: out std_logic;
			
			-- Memory control
			MemRead     : out STD_LOGIC;
			DM_address : out STD_LOGIC;
			MemWrite    : out STD_LOGIC;
			MemToReg    : out STD_LOGIC;
			-- Stack control
			Sp_Inc      : out STD_LOGIC;
			Sp_Dec      : out STD_LOGIC;
			Sp_Enable   : out STD_LOGIC;
			-- Flow control
			Branch      : out STD_LOGIC;
			Jump        : out STD_LOGIC;
			Call        : out STD_LOGIC;
			ReturnSig   : out STD_LOGIC;
			-- Flag control
			Set_Carry   : out STD_LOGIC;
			Update_Flag : out STD_LOGIC;
			-- Special operations
			Swap        : out STD_LOGIC;
			-- I/O control
			OutPort     : out STD_LOGIC;
			InPort      : out STD_LOGIC;
			-- System control
			Halt        : out STD_LOGIC;
			-- Jump conditions
			J_SC	    : out STD_LOGIC_VECTOR(1 downto 0); -- Jump if Set Carry	
			-- Interrupt control
			IntAck      : out STD_LOGIC;
			FlagsSave   : out STD_LOGIC;
			FlagsRestore: out STD_LOGIC
		);
	end Controller;




	architecture Behavioral of Controller is
	begin
		process(opcode)
		begin
			-- Default values
			RegWrite    <= '0';
			   
			MemRead     <= '0';
			MemWrite    <= '0';
			MemToReg    <= '0';
			Sp_Inc      <= '0';
			Sp_Dec      <= '0';
			Sp_Enable   <= '0';
			Branch      <= '0';
			Jump        <= '0';
			Call        <= '0';
			ReturnSig   <= '0';
			Set_Carry   <= '0';
			Update_Flag <= '0';
			Swap        <= '0';
			OutPort     <= '0';
			InPort      <= '0';
			Halt        <= '0';
			J_SC        <= "00";  -- Default no jump condition
			IntAck      <= '0';
			immediate_Value_signal<= '0';
			FlagsSave   <= '0';
			FlagsRestore<= '0';
			DM_address <= '0';

			case opcode is
				-- One Operand Instructions
				when "00000" => -- NOP
					null;  -- PC increments automatically
				
				when "00001" => -- HLT
					Halt <= '1';
				
				when "00010" => -- SETC
					Set_Carry <= '1';
				
				when "00011" => -- NOT Rdst
					RegWrite <= '1';
				 -- NOT operation
					Update_Flag <= '1';
				
				when "00100" => -- INC Rdst
					RegWrite <= '1';
				
					Update_Flag <= '1';
				
				when "00101" => -- OUT Rsrc1
					OutPort <= '1';
				
				when "00110" => -- IN Rdst
					RegWrite <= '1';
					InPort <= '1';
				
				-- Two Operand Instructions
				when "00111" => -- MOV Rdst, Rsrc1
					RegWrite <= '1';
					
				
				when "01000" => -- SWAP Rdst, Rsrc1
					RegWrite <= '1';
					Swap <= '1';
					
				
				when "01001" => -- ADD Rdst, Rsrc1, Rsrc2
					RegWrite <= '1';
					
					Update_Flag <= '1';
				
				when "01010" => -- SUB Rdst, Rsrc1, Rsrc2
					RegWrite <= '1';
				
					Update_Flag <= '1';
				
				when "01011" => -- AND Rdst, Rsrc1, Rsrc2
					RegWrite <= '1';
					
					Update_Flag <= '1';
				
				when "01100" => -- IADD Rdst, Rsrc1, Imm
					RegWrite <= '1';
					
					immediate_Value_signal <= '1';
					
					Update_Flag <= '1';
				
				-- Memory Operations
				when "01101" => -- PUSH Rsrc1
					MemWrite <= '1';
					Sp_Dec <= '1';
					Sp_Enable <= '1';
					DM_address<= '1';
				
				when "01110" => -- POP Rdst
					RegWrite <= '1';
					MemRead <= '1';
					MemToReg <= '1';
					Sp_Inc <= '1';
					Sp_Enable <= '1';
				
				when "01111" => -- LDM Rdst, Imm
					RegWrite <= '1';
					immediate_Value_signal <= '1';  
					
				
				when "10000" => -- LDD Rdst, offset(Rsrc1)
					RegWrite <= '1';
					MemRead <= '1';
					immediate_Value_signal <= '1';
					MemToReg <= '1';
				 -- Use offset
					
				
				when "10001" => -- STD Rsrc1, offset(Rsrc2)
					MemWrite <= '1';
				 	immediate_Value_signal<= '1';
				
				-- Branch and Control Flow
				when "10010" => -- JZ Imm
					Branch <= '1';
					Jump <= '1';
					J_SC <= "00";  -- Jump if Zero
				
				when "10011" => -- JN Imm
					Branch <= '1';
					Jump <= '1';
					J_SC <= "01";  -- Jump if Zero
				
				when "10100" => -- JC Imm
					Branch <= '1';
					Jump <= '1';
					J_SC <= "10";  -- Jump if Zero
				
				when "10101" => -- JMP Imm
					Jump <= '1';
					J_SC <= "11";
				
				when "10110" => -- CALL Imm
					Call <= '1';
					Jump <= '1';
					Sp_Dec <= '1';
					J_SC<= "11";  
					DM_address <= '1';
					Sp_Enable <= '1';
					MemWrite <= '1';
				
				when "10111" => -- RET
					ReturnSig <= '1';
					Sp_Inc <= '1';
					Sp_Enable <= '1';
					MemRead <= '1';
				
				when "11000" => -- INT index
					Call <= '1';
					Sp_Dec <= '1';
					Sp_Enable <= '1';
					DM_address <= '1';
					MemWrite <= '1';
					FlagsSave <= '1';
					IntAck <= '1';
				
				when "11001" => -- RTI
					ReturnSig <= '1';
					Sp_Inc <= '1';
					Sp_Enable <= '1';
					MemRead <= '1';
					FlagsRestore <= '1';
				
				when others => null;
			end case;
		end process;
	end Behavioral;