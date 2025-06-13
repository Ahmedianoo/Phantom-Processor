	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.NUMERIC_STD.ALL;

	entity PiplinedProcessor is
		 Port (
			  clk        : in STD_LOGIC;
			  rst        : in STD_LOGIC;
		 
			  -- I/O ports
			  in_port    : in STD_LOGIC_VECTOR(31 downto 0);
			  out_port   : out STD_LOGIC_VECTOR(31 downto 0)
		 );
	end PiplinedProcessor;

	architecture Structural of PiplinedProcessor is
		
		 
		-- Component declarations:
		
		-- PC_new
		-- Instruction Memory
		
		-- Fetch/DEC register
		
		-- Decode Stage (Controller, Hazard_Detection_Unit, RegsiterFile)
		
		-- DEC/EX register
		
		-- Forwarding Unit
		-- ALU
		-- CCR
		
		-- EX/MEM register
		
		-- Memory
		-- Stack
		
		-- MEM/WB register
		
		-- Writeback
		
		
		-- Fetch
		-- PC_New
		component PC_New is
		Port 
		(
			clk                   : in STD_LOGIC;
			rst                   : in STD_LOGIC;
			stall                 : in STD_LOGIC;  -- Hazard detection
			branch                : in STD_LOGIC;  -- From EX stage
			in_from_CCR           : in STD_LOGIC_VECTOR(3 downto 0);
			in_J_SC               : in STD_LOGIC_VECTOR(1 downto 0);
			Call                  : in STD_LOGIC;
			branch_addr           : in STD_LOGIC_VECTOR(31 downto 0); -- From ALU
			RTI                   : in std_logic;
			Return_flag           : in std_logic;
			Interrupt             : in std_logic;
			PC_loaded_from_memory : in STD_LOGIC_VECTOR(31 downto 0);
		  
			PC                    : out STD_LOGIC_VECTOR(31 downto 0)
		);
		end component;
		
		
		-- Instruction Memory
		component InstructionMemory is
		Port 
		(        
			PC 		  : in STD_LOGIC_VECTOR (11 downto 0); 
			data_bus : out STD_LOGIC_VECTOR ( 31 downto 0)
		  
		);
		end component;
		
		
		-- Fetch/Dec register
		component FetchDecode
		Port (
			clk            : in  STD_LOGIC;
			rst            : in  STD_LOGIC;
			en             : in  STD_LOGIC;
			Pc_in          : in  STD_LOGIC_VECTOR(31 downto 0);
			Instruction_In : in  STD_LOGIC_VECTOR(31 downto 0);
			Interrupt_In   : in  STD_LOGIC;

			Pc             : out STD_LOGIC_VECTOR(31 downto 0);
			Rsrc1          : out STD_LOGIC_VECTOR(2 downto 0);
			Rsrc2          : out STD_LOGIC_VECTOR(2 downto 0);
			Interrupt      : out STD_LOGIC;
			Instruction    : out STD_LOGIC_VECTOR(31 downto 0)
		);
	end component;
		 
		-- Decode
        -- COntrol unit
		component Controller is
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
	    end component;
        

        -- Hazard Detection Unit
       


        -- Register File
        component Reg is
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
        end component;

		 
		 -- DEC/EX register
		component DecodeExecute
    Port (
        clk            : in  STD_LOGIC;
        rst            : in  STD_LOGIC;
        enable         : in  STD_LOGIC;

        Pc_In          : in  STD_LOGIC_VECTOR(31 downto 0);
        Read_Addr1_In  : in  STD_LOGIC_VECTOR(2 downto 0);
        Read_Addr2_In  : in  STD_LOGIC_VECTOR(2 downto 0);
        Interrupt_In   : in  STD_LOGIC;
        Rd_Addr_In     : in  STD_LOGIC_VECTOR(2 downto 0);
        Imm_Offset_In  : in  STD_LOGIC_VECTOR(15 downto 0);
        Rsrc1_Data_In  : in  STD_LOGIC_VECTOR(31 downto 0);
        Rsrc2_Data_In  : in  STD_LOGIC_VECTOR(31 downto 0);
        Swap_In        : in  STD_LOGIC;
        Set_Carry_In   : in  STD_LOGIC;
        Sp_Inc_In      : in  STD_LOGIC;
        Sp_Dec_In      : in  STD_LOGIC;
        Sp_Enable_In   : in  STD_LOGIC;
        RTI_In         : in  STD_LOGIC;
        Return_Signal_In : in  STD_LOGIC;
        Call_In        : in  STD_LOGIC;
        ALU_Srcl_In    : in  STD_LOGIC;
        Branch_In      : in  STD_LOGIC;
        Mem_Read_In    : in  STD_LOGIC;
        Reg_Write_In   : in  STD_LOGIC;
        Update_Flag_In : in  STD_LOGIC;
        IN_Port_In     : in  STD_LOGIC;
        Mem_Write_In   : in  STD_LOGIC;
        J_SC_In        : in  STD_LOGIC_VECTOR(1 downto 0);
        Opcode_In      : in  STD_LOGIC_VECTOR(4 downto 0);
        DM_In          : in  STD_LOGIC;
        Out_Port_In    : in  STD_LOGIC;

        Mem_Read       : out STD_LOGIC;
        Interrupt      : out STD_LOGIC;
        Reg1_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Swap           : out STD_LOGIC;
        Rsrc1          : out STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2          : out STD_LOGIC_VECTOR(2 downto 0);
        Rd             : out STD_LOGIC_VECTOR(2 downto 0);
        Reg_Write      : out STD_LOGIC;
        IN_Port        : out STD_LOGIC;
        Pc             : out STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry      : out STD_LOGIC;
        Sp_Inc         : out STD_LOGIC;
        Sp_Dec         : out STD_LOGIC;
        Sp_Enable      : out STD_LOGIC;
        RTI            : out STD_LOGIC;
        Return_Signal  : out STD_LOGIC;
        Call           : out STD_LOGIC;
        ALU_Srcl       : out STD_LOGIC;
        Branch         : out STD_LOGIC;
        Update_Flag    : out STD_LOGIC;
        Mem_Write      : out STD_LOGIC;
        J_SC           : out STD_LOGIC_VECTOR(1 downto 0);
        ALU_SLC        : out STD_LOGIC_VECTOR(4 downto 0);
        DM             : out STD_LOGIC;
        Imm_Offset     : out STD_LOGIC_VECTOR(15 downto 0);
        Out_Port       : out STD_LOGIC
    );
end component;

		 
		 
		 -- Forwarding Unit
		component Forwarding_Unit is
  port(
    -- Input registers from Decode/Execute stage
    D_EX_rs1      : in std_logic_vector(2 downto 0);
    D_EX_rs2      : in std_logic_vector(2 downto 0);
    
    -- Destination registers from Execute/Memory and Memory/Writeback stages
    EX_M_rd       : in std_logic_vector(2 downto 0);
    M_WB_rd       : in std_logic_vector(2 downto 0);
    
    -- Register write enable signals
    EX_M_RegWrite : in std_logic;
    M_WB_RegWrite : in std_logic;
    
    -- Input data signals (as shown in the diagram)
    M_WB_Rd_data  : in std_logic_vector(31 downto 0);
    EX_M_Rd_data  : in std_logic_vector(31 downto 0);
    Rarc1_data    : in std_logic_vector(31 downto 0);
    Rarc2_Data    : in std_logic_vector(31 downto 0);
    Rarc1_addr    : in std_logic_vector(2 downto 0);
    Rarc2_addr    : in std_logic_vector(2 downto 0);
    Immediate     : in std_logic_vector(15 downto 0);
    
    -- Immediate selection control
    IMM_Sel       : in std_logic;  -- Signal to select immediate value
    
    -- Output control signals (as shown in the diagram)

    -- Output operands (as shown in the diagram)
    Operand1      : out std_logic_vector(31 downto 0);
    Operand2      : out std_logic_vector(31 downto 0)
  );
end component Forwarding_Unit;
		 
		 -- ALU
		 component ALU is
		 Port 
		 (
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
		end component;
		
		
		-- CCR
		component CCR is
		port 
		(
			  clk              : in std_logic;
			  reset            : in std_logic;
			  update_flag      : in std_logic;
			  Carry_in         : in std_logic;
			  Return_flags     : in std_logic_vector(3 downto 0);
			  RTI_Restore_flags: in std_logic;
			  CCR_out          : out std_logic_vector(3 downto 0);
			  CCR_in           : in std_logic_vector(3 downto 0)
		);
		end component;
		
				 
		 -- EX/MEM register
		 component ExecuteMemory
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        enable          : in  STD_LOGIC;
        Mem_Read_In        : in STD_LOGIC;
        Interrupt_In       : in STD_LOGIC;
        ALU_Result_In      : in STD_LOGIC_VECTOR(31 downto 0);
          Sp_Load_In         : in STD_LOGIC_vector(11 downto 0);
        Swap_In            : in STD_LOGIC;
        Rsrc1_In           : in STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2_In           : in STD_LOGIC_VECTOR(2 downto 0);
        Rd_In              : in STD_LOGIC_VECTOR(2 downto 0);
        Reg1_Data_In       : in STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data_In       : in STD_LOGIC_VECTOR(31 downto 0);
        Reg_Write_In       : in STD_LOGIC;
        IN_Port_In         : in STD_LOGIC;
        Pc_In              : in STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry_In       : in STD_LOGIC;
        Sp_Inc_In          : in STD_LOGIC;
        Sp_Dec_In          : in STD_LOGIC;
        Sp_Enable_In       : in STD_LOGIC;
        Branch_In          : in STD_LOGIC;
        Update_Flag_In     : in STD_LOGIC;
        Mem_Write_In       : in STD_LOGIC;
        RTI_In             : in STD_LOGIC;
        Return_Signal_In   : in STD_LOGIC;
        DM_IN              : in STD_LOGIC;
        Imm_Offset_In      : in STD_LOGIC_VECTOR(15 downto 0);
        Out_Port_In        : in STD_LOGIC;
        call_In            : in STD_LOGIC;
        RTI            : out STD_LOGIC;
        Mem_Read       : out STD_LOGIC;
        Return_Signal  : out STD_LOGIC;
        Mem_Write      : out STD_LOGIC;
        ALU_Result     : out STD_LOGIC_VECTOR(31 downto 0);
        Sp_Load        : out STD_LOGIC_VECTOR( 11 downto 0);
        Rsrc1          : out STD_LOGIC_VECTOR(2 downto 0);
        Rsrc2          : out STD_LOGIC_VECTOR(2 downto 0);
        Rd             : out STD_LOGIC_VECTOR(2 downto 0);
        Pc             : out STD_LOGIC_VECTOR(31 downto 0);
        Set_Carry      : out STD_LOGIC;
        Sp_Inc         : out STD_LOGIC;
        Sp_Dec         : out STD_LOGIC;
        Sp_Enable      : out STD_LOGIC;
        Branch         : out STD_LOGIC;
        Update_Flag    : out STD_LOGIC;
        Reg1_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Reg2_Data      : out STD_LOGIC_VECTOR(31 downto 0);
        Swap           : out STD_LOGIC;
        Reg_Write      : out STD_LOGIC;
        IN_Port        : out STD_LOGIC;
        DM_Addr        : out STD_LOGIC;
        Index          : out STD_LOGIC_VECTOR(15 downto 0);
        Out_Port       : out STD_LOGIC;
		call_out        : out STD_LOGIC
    );
end component;

		 
		 
		 -- Memory
		 
component Memory IS
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
END component;
		 
		 
		 -- Stack
		 component stack_pointer is
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
		end component;
		
				 
		 -- MEM/WB register
		 component MemoryWrite is
			  Port (
				  clk          : in  STD_LOGIC;
				  rst          : in  STD_LOGIC;
				  en       : in  STD_LOGIC;

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
				  Out_Port       : out STD_LOGIC
						  );
		 end component;
		 
		 
		 
		 --Writeback_ports
		 component Writeback_ports is
		 Port (
				  ----------------------------------inputs-------------------------------	
				  clk        		   : in STD_logic;
				  --rst        		: in STD_logic;
				  In_port  				: in STD_LOGIC_VECTOR (31 downto 0);
				  Memory_data  		: in STD_LOGIC_VECTOR (31 downto 0);
				  Alu_result  			: in STD_LOGIC_VECTOR (31 downto 0);
				  Memory_read_flag   : in STD_logic;
				  
				  

				  read_data1  			: in STD_LOGIC_VECTOR (31 downto 0);
				  read_data2  			: in STD_LOGIC_VECTOR (31 downto 0);
				  swap_flag        	: in STD_logic;--reg_Write2 flag
				  
				  reg_write1_flag    : in STD_logic;
				  
				  read_address1  : in STD_LOGIC_VECTOR (2 downto 0);
				  read_address2  : in STD_LOGIC_VECTOR (2 downto 0);
				  dst_address_in : in STD_LOGIC_VECTOR (2 downto 0);
				  
				  in_port_flag   : in STD_logic;
				  out_port_flag  : in STD_logic;
				  
				  
				  ----------------------------------outputs-------------------------------
				  Output_port  		: out STD_LOGIC_VECTOR (31 downto 0);---d
				  
				  Write_data1  		: out STD_LOGIC_VECTOR (31 downto 0);---d
				  Write_data2  		: out STD_LOGIC_VECTOR (31 downto 0);---d
				  
				  Write_address1  : out STD_LOGIC_VECTOR (2 downto 0);
				  Write_address2  : out STD_LOGIC_VECTOR (2 downto 0);
				  --dst_address     : out STD_LOGIC_VECTOR (2 downto 0);
				  
				  we1   		 : out STD_logic;
				  we2_swap   : out STD_logic
		 
		 );
		 end component;
		 

         --Hazard Detection Unit
         component Hazard_Detection_Unit is
			  Port (
					FD_RS1 : in std_logic_vector(2 downto 0);
                    FD_RS2 : in std_logic_vector(2 downto 0);
                    D_Ex_rd : in std_logic_vector(2 downto 0);
                    D_EX_Mem_Read: in std_logic;
                    D_EX_Mem_Write: in std_logic;
                    Data_interface_needed: in std_logic;
                    Branch_Taken: in std_logic;
                    -- Outputs
                    Stall: out std_logic_vector(1 downto 0);
                    Flush: out std_logic_vector(1 downto 0)
			  );
		 end component;

		 --Fetch stage
         signal instruction_from_instruction_memory : STD_LOGIC_VECTOR(31 downto 0);
		 -- Pipeline register signals
		 -- IF/ID signals
		 signal if_pc_out          : STD_LOGIC_VECTOR(31 downto 0);
		 signal if_instr_out       : STD_LOGIC_VECTOR(31 downto 0);
		 signal if_interrupt_out   : STD_LOGIC;
         
         --Controller
        signal Controller_J_SC_In           : STD_LOGIC_VECTOR(1 downto 0); --
		signal Controller_Swap_In           : STD_LOGIC; --
        signal Controller_Set_Carry_In      : STD_LOGIC;--
        signal Controller_Sp_Inc_In         : STD_LOGIC;--
        signal Controller_Sp_Dec_In         : STD_LOGIC;--
        signal Controller_Sp_Enable_In      : STD_LOGIC;--
        signal Controller_Return_Signal_In  : STD_LOGIC;--
        signal Controller_Call_In           : STD_LOGIC;--
        signal Controller_ALU_Srcl_In       : STD_LOGIC;
        signal Controller_Branch_In         : STD_LOGIC;--
        signal Controller_Mem_Read_In       : STD_LOGIC;--
        signal Controller_Reg_Write_In      : STD_LOGIC;--
        signal Controller_Update_Flag_In    : STD_LOGIC;--
        signal Controller_IN_Port_In        : STD_LOGIC;--
        signal Controller_Mem_Write_In      : STD_LOGIC;--
        signal Controller_DM_In             : STD_LOGIC;--
        signal Controller_Jump              : STD_LOGIC;--
        signal Controller_OutPort           : STD_LOGIC;--
        signal Controller_Halt              : STD_LOGIC;--
        signal Controller_Immediate_Value_signal : STD_LOGIC;--
        signal Controller_FlagsSave         : STD_LOGIC;--
        signal Controller_FlagsRestore      : STD_LOGIC;--
        signal Controller_IntAck            : STD_LOGIC;--
        signal Controller_MemToReg          : STD_LOGIC;--
        
        -- Register File signals
        signal wb_reg_write     : STD_LOGIC;
        signal ctrl_swap        : STD_LOGIC;
        signal swap_enable      : STD_LOGIC;
        signal swap_reg_addr    : STD_LOGIC_VECTOR(2 downto 0);
        signal reg_rs1_addr     : STD_LOGIC_VECTOR(2 downto 0);
        signal reg_rd_addr      : STD_LOGIC_VECTOR(2 downto 0);
        signal reg_rs2_addr     : STD_LOGIC_VECTOR(2 downto 0);
        signal write_data       : STD_LOGIC_VECTOR(31 downto 0);
        signal swap_data        : STD_LOGIC_VECTOR(31 downto 0);
        signal read_data1       : STD_LOGIC_VECTOR(31 downto 0);
        signal read_data2       : STD_LOGIC_VECTOR(31 downto 0);
        signal wb_reg_addr     : STD_LOGIC_VECTOR(2 downto 0);

		 -- ID/EX signals
		 signal id_pc_out          : STD_LOGIC_VECTOR(31 downto 0);
		 signal id_rsrc1_out       : STD_LOGIC_VECTOR(2 downto 0);
		 signal id_rsrc2_out       : STD_LOGIC_VECTOR(2 downto 0);
		 signal id_rd_out          : STD_LOGIC_VECTOR(2 downto 0);
		 signal id_imm_offset_out  : STD_LOGIC_VECTOR(15 downto 0);
		 signal id_rsrc1_data_out  : STD_LOGIC_VECTOR(31 downto 0);
		 signal id_rsrc2_data_out  : STD_LOGIC_VECTOR(31 downto 0);
		 signal id_swap_out        : STD_LOGIC;
		 signal id_set_carry_out   : STD_LOGIC;
		 signal id_sp_inc_out      : STD_LOGIC;
		 signal id_sp_dec_out      : STD_LOGIC;
		 signal id_sp_enable_out   : STD_LOGIC;
		 signal id_rti_out         : STD_LOGIC;
		 signal id_return_sig_out  : STD_LOGIC;
		 signal id_call_out        : STD_LOGIC;
		 signal id_alu_srcl_out    : STD_LOGIC;
         signal id_interrupt_out     : STD_LOGIC;
		 signal id_branch_out      : STD_LOGIC;
		 signal id_mem_read_out    : STD_LOGIC;
		 signal id_reg_write_out   : STD_LOGIC;
		 signal id_update_flag_out : STD_LOGIC;
		 signal id_in_port_out     : STD_LOGIC;
		 signal id_mem_write_out   : STD_LOGIC;
		 signal id_j_sc_out        : STD_LOGIC_VECTOR(1 downto 0);
		 signal id_alu_slc_out     : STD_LOGIC_VECTOR(4 downto 0);
		 signal id_dm_out          : STD_LOGIC;
		--  signal  in_port_signal    :std_logic;  
		--  signal  out_port_signal   :std_logic;
     
		 
		 -- EX/MEM signals
		 signal ex_mem_rti_out         : STD_LOGIC;
		 signal ex_mem_read_out    : STD_LOGIC;
		 signal ex_return_sig_out  : STD_LOGIC;
		 signal ex_mem_write_out   : STD_LOGIC;
		 signal ex_alu_result_out  : STD_LOGIC_VECTOR(31 downto 0);
		 signal ex_sp_load_out     : STD_LOGIC_VECTOR(11 downto 0);
		 signal ex_rsrc1_out       : STD_LOGIC_VECTOR(2 downto 0);
		 signal ex_rsrc2_out       : STD_LOGIC_VECTOR(2 downto 0);
		 signal ex_rd_out          : STD_LOGIC_VECTOR(2 downto 0);
		 signal ex_pc_out          : STD_LOGIC_VECTOR(31 downto 0);
		 signal ex_set_carry_out   : STD_LOGIC;
		 signal ex_sp_inc_out      : STD_LOGIC;
		 signal ex_sp_dec_out      : STD_LOGIC;
		 signal ex_sp_enable_out   : STD_LOGIC;
		 signal ex_branch_out      : STD_LOGIC;
		 signal ex_update_flag_out : STD_LOGIC;
		 signal ex_reg1_data_out   : STD_LOGIC_VECTOR(31 downto 0);
		 signal ex_reg2_data_out   : STD_LOGIC_VECTOR(31 downto 0);
		 signal ex_swap_out        : STD_LOGIC;
		 signal ex_reg_write_out   : STD_LOGIC;
		 signal ex_in_port_out     : STD_LOGIC;
		 signal ex_dm_addr_out     : STD_LOGIC;
		 signal ex_index_out       : STD_LOGIC_VECTOR(15 downto 0);
		 signal ex_out_port_out	   : STD_LOGIC;
		 signal  ex_call_out		: STD_LOGIC;
		 signal alu_a              : std_logic_vector(31 downto 0);
		 signal alu_b              : std_logic_vector(31 downto 0);
		 ---CCR signals
         signal ccr_from_CCR_out            : std_logic_vector(3 downto 0);
         signal CCR_from_Alu      : std_logic_vector(3 downto 0);
         --Forwarding signals
        signal D_EX_rs1        : STD_LOGIC_VECTOR(2 downto 0);
        signal D_EX_rs2        : STD_LOGIC_VECTOR(2 downto 0);
        signal EX_M_rd         : STD_LOGIC_VECTOR(2 downto 0);
        signal M_WB_rd         : STD_LOGIC_VECTOR(2 downto 0);
        signal EX_M_RegWrite   : STD_LOGIC;
        signal M_WB_RegWrite   : STD_LOGIC;
        signal M_WB_Rd_data    : STD_LOGIC_VECTOR(31 downto 0);
        signal EX_M_Rd_data    : STD_LOGIC_VECTOR(31 downto 0);
        signal Rarc1_data      : STD_LOGIC_VECTOR(31 downto 0);
        signal Rarc2_Data      : STD_LOGIC_VECTOR(31 downto 0);
        signal Immediate       : STD_LOGIC_VECTOR(15 downto 0);
        signal IMM_Sel         : STD_LOGIC;
        signal Operand1        : STD_LOGIC_VECTOR(31 downto 0);
        signal Operand2        : STD_LOGIC_VECTOR(31 downto 0);
        
                -- MEM/WB signals
		 signal mw_read_data_out   : STD_LOGIC_VECTOR(31 downto 0);
		 signal mw_alu_result_out  : STD_LOGIC_VECTOR(31 downto 0);
		 signal mw_Rd					: STD_LOGIC_VECTOR(2 downto 0);	
		 signal mw_reg1_addr_out   : STD_LOGIC_VECTOR(2 downto 0);
		 signal mw_reg2_addr_out   : STD_LOGIC_VECTOR(2 downto 0);
		 signal mw_mem_read_out    : STD_LOGIC;
		 signal mw_reg1_data_out   : STD_LOGIC_VECTOR(31 downto 0);
		 signal mw_reg2_data_out   : STD_LOGIC_VECTOR(31 downto 0);
		 signal mw_swap_out        : STD_LOGIC;
		 signal mw_in_port_out     : STD_LOGIC;
		 signal mw_out_port_out     : STD_LOGIC;
		 signal mw_reg_write_out  : STD_LOGIC;
		 signal  Read_data_memory    : STD_LOGIC_VECTOR(31 downto 0);
		 signal  Pc_plus_flags : STD_LOGIC_VECTOR(31 downto 0);
		 
 
		 
		
		--  signal halt               : STD_LOGIC;
		--  signal jz                 : STD_LOGIC;
		--  signal jn                 : STD_LOGIC;
		--  signal jc                 : STD_LOGIC;
		--  signal int_ack            : STD_LOGIC;
		--  signal flags_save         : STD_LOGIC;
		--  signal flags_restore      : STD_LOGIC;
		 
		 -- Hazard detection signals
		 signal stall              : STD_LOGIC_VECTOR(1 downto 0);
		 signal flush              : STD_LOGIC_VECTOR(1 downto 0);
         signal ex_mem_read_sig    : STD_LOGIC;
         signal ex_mem_write_sig   : STD_LOGIC;
         signal data_hazard_needed_sig : STD_LOGIC;
         signal branch_taken_sig : STD_LOGIC;
		 
		 -- Forwarding signals
		 signal forward_rs1        : STD_LOGIC_VECTOR(1 downto 0);
		 signal forward_rs2        : STD_LOGIC_VECTOR(1 downto 0);
		 
		 -- ALU signals
		 signal alu_result         : STD_LOGIC_VECTOR(31 downto 0);
		--  signal alu_zero           : STD_LOGIC;
		--  signal alu_neg            : STD_LOGIC;
		--  signal alu_carry          : STD_LOGIC;
		 signal in_J_SC           : STD_LOGIC_VECTOR(1 downto 0); 
		 -- Register file signals
		 signal reg_data_out1      : STD_LOGIC_VECTOR(31 downto 0);
		 signal reg_data_out2      : STD_LOGIC_VECTOR(31 downto 0);
		 signal rs1_addr_FD       : STD_LOGIC_VECTOR(2 downto 0);
         signal rs2_addr_FD       : STD_LOGIC_VECTOR(2 downto 0);
		 -- Program counter signals
		 signal pc_in              : STD_LOGIC_VECTOR(31 downto 0);
		 signal pc_out             : STD_LOGIC_VECTOR(31 downto 0);
		 signal pc_enable          : STD_LOGIC;
		 signal  PC_loaded_from_memory : STD_LOGIC_VECTOR(31 downto 0);
		 -- Stack pointer signals
		 signal sp_out             : STD_LOGIC_VECTOR(11 downto 0);
		 
		 -- Flag register signals
		 signal zero_flag          : STD_LOGIC;
		 signal neg_flag           : STD_LOGIC;
		 signal carry_flag         : STD_LOGIC;
		 
		 
		 
		 --Write back and ports signals
		 
		--signal wr_Output_port     :  STD_LOGIC_VECTOR (31 downto 0);
		signal wr_Write_data1     :  STD_LOGIC_VECTOR (31 downto 0);
		signal wr_Write_data2     :  STD_LOGIC_VECTOR (31 downto 0);
		signal wr_Write_address1  :  STD_LOGIC_VECTOR (2 downto 0);
		signal wr_Write_address2  :  STD_LOGIC_VECTOR (2 downto 0);
		signal wr_we1   		 	  :  STD_logic;
		signal wr_we2_swap  		  :  STD_logic;
		signal id_out		  :  STD_LOGIC;	
		 --sp_enable
		signal sp_enable_or:	std_logic;
		 
         --PC_new signals
       signal branch_addr_se : STD_LOGIC_VECTOR(31 downto 0);
       signal en2 : STD_LOGIC;
	   --
	   signal muxed_OutPort          : std_logic;
		signal muxed_Swap             : std_logic;
		signal muxed_Set_Carry        : std_logic;
		signal muxed_Sp_Inc           : std_logic;
		signal muxed_Sp_Dec           : std_logic;
		signal muxed_Sp_Enable        : std_logic;
		signal muxed_Return_Signal    : std_logic;
		signal muxed_Call             : std_logic;
		signal muxed_ALU_Srcl         : std_logic;
		signal muxed_Branch           : std_logic;
		signal muxed_Mem_Read         : std_logic;
		signal muxed_Reg_Write        : std_logic;
		signal muxed_Update_Flag      : std_logic;
		signal muxed_IN_Port          : std_logic;
		signal muxed_Mem_Write        : std_logic;
		signal muxed_J_SC             : std_logic_vector(1 downto 0);
		signal muxed_DM               : std_logic;

	begin
		 --Pipeline registers
		 -- Instruction Fetch/Decode Stage
         branch_addr_se <= (15 downto 0 => id_imm_offset_out(15)) & id_imm_offset_out;

         ProgramCounter:PC_New 
        Port map 
        (
        clk=>clk,
        rst=>rst,
        call=>id_call_out,                  
        stall=>stall(0),                 
        branch=>id_branch_out,              
        in_from_CCR=>ccr_from_CCR_out,          
        in_J_SC=> id_j_sc_out,              
        branch_addr => branch_addr_se,
      
        RTI=>ex_mem_rti_out,                 
        Return_flag=>id_return_sig_out ,          
        Interrupt=>id_interrupt_out,
        PC_loaded_from_memory=> Read_data_memory,
        PC=>pc_out                   
        );
        InstructionMemory_inst: InstructionMemory
         port map(
            PC => pc_out(11 downto 0),
            data_bus => instruction_from_instruction_memory
        );

      
		 FD_Stage: FetchDecode
		 port map(
			  clk            => clk,
			  rst            => flush(0),
			  en             => '1',
			  Pc_in          => pc_out,
			  Instruction_In => instruction_from_instruction_memory,
			  Interrupt_In   => '0',  -- TODO: Connect interrupt signal
			  Pc             => if_pc_out,
			  Rsrc1          => rs1_addr_FD,  -- Connected directly to register file
			  Rsrc2          => rs2_addr_FD,  -- Connected directly to register file
			  Interrupt      => if_interrupt_out,
			  Instruction    => if_instr_out
		 );
        
        
        Controller_inst : Controller
        port map (
            opcode => if_instr_out(31 downto 27),
            
            -- Execution control
            RegWrite => Controller_Reg_Write_In,
            immediate_Value_signal => Controller_Immediate_Value_signal,
            
            -- Memory control
            MemRead => Controller_Mem_Read_In,
            DM_address => Controller_DM_In,
            MemWrite => Controller_Mem_Write_In,
            MemToReg => Controller_MemToReg,
            
            -- Stack control
            Sp_Inc => Controller_Sp_Inc_In,
            Sp_Dec => Controller_Sp_Dec_In,
            Sp_Enable => Controller_Sp_Enable_In,
            
            -- Flow control
            Branch => Controller_Branch_In,
            Jump => Controller_Jump,
            Call => Controller_Call_In,
            ReturnSig => Controller_Return_Signal_In,
            
            -- Flag control
            Set_Carry => Controller_Set_Carry_In,
            Update_Flag => Controller_Update_Flag_In,
            
            -- Special operations
            Swap => Controller_Swap_In,
            
            -- I/O control
            OutPort => Controller_OutPort,
            InPort => Controller_IN_Port_In,
            
            -- System control
            Halt => Controller_Halt,
            
            -- Jump conditions
            J_SC => Controller_J_SC_In,
            
            -- Interrupt control
            IntAck => Controller_IntAck,
            FlagsSave => Controller_FlagsSave,
            FlagsRestore => Controller_FlagsRestore
        );

		-- Control signals mux based on flush(1)
process(flush, Controller_OutPort, Controller_Swap_In, Controller_Set_Carry_In, 
        Controller_Sp_Inc_In, Controller_SP_DEC_IN, Controller_Sp_Enable_In, 
        Controller_Return_Signal_In, Controller_Call_In, Controller_ALU_Srcl_In, 
        Controller_Branch_In, Controller_Mem_Read_In, Controller_Reg_Write_In, 
        Controller_Update_Flag_In, Controller_IN_Port_In, Controller_Mem_Write_In, 
        Controller_J_SC_In, Controller_DM_In)
begin
    -- Default: pass through the controller signals
    muxed_OutPort       <= Controller_OutPort;
    muxed_Swap          <= Controller_Swap_In;
    muxed_Set_Carry     <= Controller_Set_Carry_In;
    muxed_Sp_Inc        <= Controller_Sp_Inc_In;
    muxed_Sp_Dec        <= Controller_SP_DEC_IN;
    muxed_Sp_Enable     <= Controller_Sp_Enable_In;
    muxed_Return_Signal <= Controller_Return_Signal_In;
    muxed_Call          <= Controller_Call_In;  -- Note: Fixed from the original where this was incorrectly mapped
    muxed_ALU_Srcl      <= Controller_ALU_Srcl_In;
    muxed_Branch        <= Controller_Branch_In;
    muxed_Mem_Read      <= Controller_Mem_Read_In;
    muxed_Reg_Write     <= Controller_Reg_Write_In;
    muxed_Update_Flag   <= Controller_Update_Flag_In;
    muxed_IN_Port       <= Controller_IN_Port_In;
    muxed_Mem_Write     <= Controller_Mem_Write_In;
    muxed_J_SC          <= Controller_J_SC_In;
    muxed_DM            <= Controller_DM_In;
    
    -- When flush(1) is '1', zero out all control signals
    if flush(1) = '1' then
        muxed_OutPort       <= '0';
        muxed_Swap          <= '0';
        muxed_Set_Carry     <= '0';
        muxed_Sp_Inc        <= '0';
        muxed_Sp_Dec        <= '0';
        muxed_Sp_Enable     <= '0';
        muxed_Return_Signal <= '0';
        muxed_Call          <= '0';
        muxed_ALU_Srcl      <= '0';
        muxed_Branch        <= '0';
        muxed_Mem_Read      <= '0';
        muxed_Reg_Write     <= '0';
        muxed_Update_Flag   <= '0';
        muxed_IN_Port       <= '0';
        muxed_Mem_Write     <= '0';
        muxed_J_SC          <= "00";
        muxed_DM            <= '0';
    end if;
end process;
        register_file_inst: Reg
        generic map (
            address_bits => 3,
            word_width => 32
        )
        -- TODOs (done)
        port map (
            clk                => clk,
            rst                => rst,
            we1                => wr_we1,                  -- from WB stage 
            address_sel_sw     => Controller_Swap_In,      -- from CU 
            we2_swap           => wr_we2_swap,             -- from WB stage
            write_address_1    => wr_Write_address1,       -- from WB stage
            write_address_2    => wr_Write_address2,       -- from WB stage
            read_address_1     => if_instr_out(26 downto 24), -- rs1
            read_address2_1    => if_instr_out(23 downto 21), -- rs2
            read_address2_2    => if_instr_out(20 downto 18), -- rd
            data_in_1          => wr_Write_data1,          -- from WB stage
            data_in_2          => wr_Write_data2,          -- from WB stage
            data_out1          => read_data1,
            data_out2          => read_data2
        );


		 -- Decode/Execute Stage
         en2 <= not stall(1);
		-- Now update the DE_Stage port map to use the muxed signals
DE_Stage: DecodeExecute
port map(
    clk             => clk,
    rst             => flush(1),
    enable          => en2,

    -- Inputs from Fetch/Decode
    Pc_In           => if_pc_out,
    Read_Addr1_In   => if_instr_out(26 downto 24),
    Read_Addr2_In   => if_instr_out(23 downto 21),
    Interrupt_In    => if_interrupt_out,
    Rd_Addr_In      => if_instr_out(20 downto 18),
    Imm_Offset_In   => if_instr_out(15 downto 0),
    Rsrc1_Data_In   => read_data1,
    Rsrc2_Data_In   => read_data2,

    -- Control signals in - NOW USING MUXED SIGNALS
    Out_Port_In     => muxed_OutPort,
    Swap_In         => muxed_Swap,
    Set_Carry_In    => muxed_Set_Carry,
    Sp_Inc_In       => muxed_Sp_Inc,
    Sp_Dec_In       => muxed_Sp_Dec,
    Sp_Enable_In    => muxed_Sp_Enable,
    RTI_In          => '0',  -- RTI is already '0'
    Return_Signal_In=> muxed_Return_Signal,
    Call_In         => muxed_Call,
    ALU_Srcl_In     => muxed_ALU_Srcl,
    Branch_In       => muxed_Branch,
    Mem_Read_In     => muxed_Mem_Read,
    Reg_Write_In    => muxed_Reg_Write,
    Update_Flag_In  => muxed_Update_Flag,
    IN_Port_In      => muxed_IN_Port,
    Mem_Write_In    => muxed_Mem_Write,
    J_SC_In         => muxed_J_SC,
    Opcode_In       => if_instr_out(31 downto 27),  -- Opcode typically isn't zeroed
    DM_In           => muxed_DM,

    -- Outputs to Execute/Memory
    Mem_Read        => id_mem_read_out,
    Interrupt       => id_interrupt_out,
    Reg1_Data       => id_rsrc1_data_out,
    Reg2_Data       => id_rsrc2_data_out,
    Swap            => id_swap_out,
    Rsrc1           => id_rsrc1_out,
    Rsrc2           => id_rsrc2_out,
    Rd              => id_rd_out,
    Reg_Write       => id_reg_write_out,
    IN_Port         => id_in_port_out,
    Pc              => id_pc_out,
    Set_Carry       => id_set_carry_out,
    Sp_Inc          => id_sp_inc_out,
    Sp_Dec          => id_sp_dec_out,
    Sp_Enable       => id_sp_enable_out,
    RTI             => id_rti_out,
    Return_Signal   => id_return_sig_out,
    Call            => id_call_out,
    ALU_Srcl        => id_alu_srcl_out,
    Branch          => id_branch_out,
    Update_Flag     => id_update_flag_out,
    Mem_Write       => id_mem_write_out,
    J_SC            => id_j_sc_out,
    ALU_SLC         => id_alu_slc_out,
    DM              => id_dm_out,
    Imm_Offset      => id_imm_offset_out,
    Out_Port        => ID_OUT
);
			
			
			Controller_ALU_Srcl_In <= Controller_Immediate_Value_signal;
			--Flush Logic
			
        --Execute Stage
        -- Forwarding Unit
--            Forwarding_Unit_inst: Forwarding_Unit
--             port map(
--                D_EX_rs1 => id_rsrc1_out,
--                D_EX_rs2 => id_rsrc2_out,
--				Rarc1_addr => id_rsrc1_out,
--				Rarc2_addr => id_rsrc2_out,
--                EX_M_rd => EX_M_rd,
--                M_WB_rd => M_WB_rd,
--                EX_M_RegWrite => EX_M_RegWrite,
--                M_WB_RegWrite => M_WB_RegWrite,
--                M_WB_Rd_data => M_WB_Rd_data,
--                EX_M_Rd_data => EX_M_Rd_data,
--                Rarc1_data => id_rsrc1_data_out,
--                Rarc2_Data => id_rsrc2_data_out,
--          
--                Immediate => Immediate,
--                IMM_Sel => IMM_Sel,
--                Operand1 => Operand1,
--                Operand2 => Operand2
--            );
 
             Operand2 <= (31 downto 16 => id_imm_offset_out(15)) & id_imm_offset_out;

            -- ALU
            ALU_inst:ALU
             port map(
                operand1 => id_rsrc1_data_out,
                operand2 => id_rsrc2_data_out,
                ALU_OP => id_alu_slc_out,
                offset =>Operand2(15 downto 0) ,
                Imm => Operand2(15 downto 0), 
                ALU_OUT => alu_result,
                CCR => CCR_from_Alu
            );
        CCR_inst: CCR
         port map(
            clk => clk,
            reset => rst,
            update_flag => id_update_flag_out,
            Carry_in => id_set_carry_out,
            Return_flags =>PC_loaded_from_memory(3 downto 0),
            RTI_Restore_flags =>ex_mem_rti_out,
            CCR_out => CCR_from_CCR_out,
            CCR_in => CCR_from_Alu
        );
		 -- Forwarding Unit
		

		 -- ALU input multiplexers with forwarding
	
		 -- Execute/Memory Stage
		 EM_Stage: ExecuteMemory
		 port map(
			  clk             => clk,
			  rst             => rst,
			  enable          => '1',
			  call_In => id_call_out,
			  -- Inputs from Decode/Execute
			  Mem_Read_In     => id_mem_read_out,
			  Interrupt_In    => '0',  -- TODO: Connect interrupt
			  ALU_Result_In   => alu_result,
			  Sp_Load_In      => ((others => '0') ),  -- TODO: Connect SP load
			  Swap_In         => id_swap_out,
			  Rsrc1_In        => id_rsrc1_out,
			  Rsrc2_In        => id_rsrc2_out,
			  Out_Port_In     => ID_OUT,
			  Rd_In           => id_rd_out,
			  Reg1_Data_In    => id_rsrc1_data_out,
			  Reg2_Data_In    => id_rsrc2_data_out,
			  Reg_Write_In    => id_reg_write_out,
			  IN_Port_In      => id_in_port_out,
			  Pc_In           => id_pc_out,
			  Set_Carry_In    => id_set_carry_out,
			  Sp_Inc_In       => id_sp_inc_out,
			  Sp_Dec_In       => id_sp_dec_out,
			  Sp_Enable_In    => id_sp_enable_out,
			  Branch_In       => id_branch_out,
			  Update_Flag_In  => id_update_flag_out,
			  Mem_Write_In    => id_mem_write_out,
			  RTI_In          => id_mem_write_out,  -- TODO: Connect RTI
			  Return_Signal_In=> id_return_sig_out,
			  DM_IN           => id_dm_out,
			  Imm_Offset_In   => id_imm_offset_out,
			  -- Outputs to Memory/Writeback
			  RTI             => ex_mem_rti_out,
			  Mem_Read        => ex_mem_read_out,
			  Return_Signal   => ex_return_sig_out,
			  Mem_Write       => ex_mem_write_out,
			  ALU_Result      => ex_alu_result_out,
			  Sp_Load         => ex_sp_load_out,
			  Rsrc1           => ex_rsrc1_out,
			   Rsrc2          => ex_rsrc2_out,
			  Rd              => ex_rd_out,
			  Pc              => ex_pc_out,
			  Set_Carry       => ex_set_carry_out,
			  Sp_Inc          => ex_sp_inc_out,
			  Sp_Dec          => ex_sp_dec_out,
			  Sp_Enable       => ex_sp_enable_out,
			  Branch          => ex_branch_out,
			  Update_Flag     => ex_update_flag_out,
			  Reg1_Data       => ex_reg1_data_out,
			  Reg2_Data       => ex_reg2_data_out,
			  Swap            => ex_swap_out,
			  Reg_Write       => ex_reg_write_out,
			  IN_Port         => ex_in_port_out,
			  DM_Addr         => ex_dm_addr_out,
			  Index           => ex_index_out,
			  Out_Port 	   => ex_out_port_out,
			  call_out => ex_call_out
		 );
		 -- Memory/Writeback Stage
		  sp_enable_or<= id_sp_enable_out or ex_sp_enable_out;
		 stack_pointer_inst: stack_pointer
		  port map(
			 clk => clk,
			 rst => rst,
			 SP_enable =>sp_enable_or,
			 SP_INC => id_sp_inc_out,
			 SP_DEC => ex_sp_dec_out,
			 SP_mem => ex_sp_load_out,
			 SP_out => SP_out
		 );
		 Pc_plus_flags<= CCR_from_CCR_out(3 downto 0) &id_pc_out(27 downto 0);
		 Memory_inst:Memory
		 
		  port map(
			 clk => clk,
			 reset => rst,
			 Mem_Read => ex_mem_read_out,
			 Mem_Write => ex_mem_write_out,
			 DM_address => ex_dm_addr_out,
			 ALU_result => ALU_result(11 downto 0),
			 SP_Load => ex_sp_load_out,
			 SP_INC => ex_sp_inc_out,
			 Call => ex_call_out,
			 Rsrc1 => ex_reg1_data_out,
			 PC_Flag_1 => Pc_plus_flags,
			 Read_data => Read_data_memory
		 );
		 MW_Stage: MemoryWrite
		 port map(
			  clk          => clk,
			  rst          => rst,
			  en       => '1',
			  -- Inputs from Execute/Memory
			  Read_Data_In     => Read_data_memory,
			  ALU_Result_In    => ex_alu_result_out,
			  Mem_Read_In      => ex_mem_read_out,
			  Rsrc1_In         => ex_rsrc1_out,
			  Out_Port_In 	   => ex_out_port_out  ,
     		  Rsrc2_In			 => ex_rsrc2_out,	
			  Rd_In            => ex_rd_out,
			  Reg1_Data_In     => ex_reg1_data_out,
			  Reg2_Data_In     => ex_reg2_data_out,
			  Swap_In          => ex_swap_out,
			  Reg_Write_In     => ex_reg_write_out,
			  IN_Port_In       => ex_in_port_out,
--			 
			  -- Outputs to Writeback
			  Read_Data     => mw_read_data_out,
			  ALU_Result    => mw_alu_result_out,
			  Rsrc1     => mw_reg1_addr_out,
			  Rsrc2     => mw_reg2_addr_out,
			  Rd => mw_Rd,
			  Mem_Read      => mw_mem_read_out,
			  Reg1_Data     => mw_reg1_data_out,
			  Reg2_Data     => mw_reg2_data_out,
			  Swap          => mw_swap_out,
			  IN_Port       => mw_in_port_out,
			  Out_Port => mw_out_port_out,
			  Reg_Write    => mw_reg_write_out
		 );
		 
 
		 -- Writeback_ports
		 
		  WB_Ports_Inst : Writeback_ports
        port map (
		  
			  clk => clk,
			  In_port  	=> in_port,
			  Memory_data  => mw_read_data_out,
			  Alu_result  	=> mw_alu_result_out,
			  Memory_read_flag => mw_mem_read_out,
			  
			  

			  read_data1  	=> mw_reg1_data_out,
			  read_data2  	=> mw_reg2_data_out,
			  swap_flag      => mw_swap_out,
			  
			  reg_write1_flag  => mw_reg_write_out,
			   
			  read_address1  => mw_reg1_addr_out,
			  read_address2  => mw_reg2_addr_out,
			  dst_address_in => mw_Rd, 
			  
			  in_port_flag   => mw_in_port_out,
			  out_port_flag  => mw_out_port_out, 
			  
			  
			  ----------------------------------outputs-------------------------------
			  Output_port  	=>	out_port,
			  
			  Write_data1  	=>	wr_Write_data1,
			  Write_data2  	=>	wr_Write_data2,
			  
			  Write_address1  => wr_Write_address1,
			  Write_address2 => wr_Write_address2,
			  
			  we1   		=> wr_we1,
			  we2_swap  => wr_we2_swap 
        );
		  
		  
		 
		 
		 
		 
		 

        -- Hazard Detection Unit
        HD_Stage: Hazard_Detection_Unit
        port map(
            FD_RS1 => rs1_addr_FD,
            FD_RS2 => rs2_addr_FD,
            D_Ex_rd => id_rd_out,
            D_EX_Mem_Read => ex_mem_read_sig,
            D_EX_Mem_Write => ex_mem_write_sig,
            Data_interface_needed => data_hazard_needed_sig,
            Branch_Taken => branch_taken_sig,
            Stall => stall,
            Flush => flush
        );
        -- Next PC Logic
    

	end Structural;