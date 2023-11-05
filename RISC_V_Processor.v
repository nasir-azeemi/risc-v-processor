module RISC_V_Processor
(
input clk, reset
);
	wire [63:0] PC_In;
	wire [63:0] PC_Out;
	wire [63:0] PC_Out_buffer1;
	wire [63:0] PC_Out_buffer2;

	wire [31:0] Ins;
	wire [31:0] Ins_buffer;
	
	wire [63:0] adj_ins;
	wire [63:0] branch_address;
	wire [6:0] opcode;
 	wire [2:0] funct3;
 	wire [4:0] rs1;
 	wire [4:0] rs2;
	wire [4:0] rd;
 	wire [4:0] rs1_buffer;
 	wire [4:0] rs2_buffer;
	wire [4:0] rd_buffer;
 	wire [6:0] funct7;
	wire [63:0] writedata;
	
	wire [63:0] readdata1;
    wire [63:0] readdata2;
	wire [63:0] readdata1_buffer;
    wire [63:0] readdata2_buffer;

	wire [63:0] readdata;
	wire [1:0] aluop;
	wire [1:0] aluop_buffer;
	
	wire branch, memread, memtoreg, memwrite, alusrc, regwrite;
	wire branch_bf, memread_bf, memtoreg_bf, memwrite_bf, alusrc_bf, regwrite_bf;
	wire [0:2] mbuffer;
	wire [0:1] wbbuffer;
	wire alusrc_buffer;
	wire [63:0] val_a;
	wire [63:0] val_b;
	wire [63:0] result;
	wire zero;
	wire [3:0] operation;
	wire [63:0] imm_shift;
	wire is_branch;

	wire [63:0] imm64;
	wire [63:0] imm64_buffer;
	wire [11:0] imm12;
	wire [3:0] funct_buffer;
	
	assign is_branch = zero && branch;
	assign val_a = readdata1_buffer;
	assign {branch_bf, memwrite_bf, memread_bf} = mbuffer;
	assign {memtoreg_bf, regwrite_bf} = wbbuffer;

	Program_Counter pc
	(
		.clk(clk), 
		.reset(reset), 
		.PC_In(PC_In), 
		.PC_Out(PC_Out)
	);

	Instruction_Memory im
	(
		.Inst_Address(PC_Out),
		.Instruction(Ins)
	);

	adder64 add1
	(
		.a(PC_Out),
		.b(64'd4),
		.sum(adj_ins)
	);

	IFID buffer1
	(
		.clk(clk),
		.pc_buffer_in(PC_Out),
		.instruction_buffer_in(Ins),
		.instruction_buffer_out(Ins_buffer),
		.pc_buffer_out(PC_Out_buffer1)
	);

	parser ins_parser
	(	
		.ins(Ins_buffer),
		.opcode(opcode),
		.rd(rd),
		.funct3(funct3),
		.rs1(rs1),
		.rs2(rs2),
		.funct7(funct7)
	);

	control_unit cu
	(
		.Opcode(opcode),
		.ALUOp(aluop),
		.Branch(branch),
		.MemRead(memread),
		.MemtoReg(memtoreg),
		.MemWrite(memwrite),
		.ALUSrc(alusrc),
		.RegWrite(regwrite)
	);

	imm_gen Imm_Gen
	(
		.ins(Ins_buffer),
		.imm_data(imm64),
		.imm_data12(imm12)
	);

	IDEX buffer2
	(
		.clk(clk),
		.pc_buffer_in(PC_Out_buffer1), 
		
		.readData1_buffer_in(readdata1), 
		.readData2_buffer_in(readdata2), 
		
		.immData_buffer_in(imm64),
		
		.rs1_buffer_in(rs1),
		.rs2_buffer_in(rs2),
		.rd_buffer_in(rd),
		
		.funct_buffer_in({Ins_buffer[30], Ins_buffer[14:12]}),
		.mBuffer_in({branch, memwrite, memread}),
		.wbBuffer_in({memtoreg, regwrite}),
		.aluOp_in(aluop),
		.aluSrc_in(alusrc),
		
		.pc_buffer_out(PC_Out_buffer2), 
		
		.readData1_buffer_out(readdata1_buffer), 
		.readData2_buffer_out(readdata2_buffer), 
		
		.immData_buffer_out(imm64_buffer),
		
		.rs1_buffer_out(rs1_buffer),
		.rs2_buffer_out(rs2_buffer),
		.rd_buffer_out(rd_buffer),
		
		.funct_buffer_out(funct_buffer),
		.mBuffer_out(mbuffer),
		.wbBuffer_out(wbbuffer),
		.aluOp_out(aluop_buffer),
		.aluSrc_out(alusrc_buffer)		
	);
	
	adder64 add2
	(
		.a(PC_Out_buffer2),
		.b(imm64_buffer),
		.sum(branch_address)
	);

	mul2x1 mux1
	(
		.sel(alusrc_bf),
		.a(readdata2_buffer),
		.b(imm64_buffer),
		.data_out(val_b)
	);

	ALU_Control alu_con
	(
		.Funct( funct_buffer ), // {Ins_buffer[30], Ins_buffer[14], Ins_buffer[13], Ins_buffer[12]} ),
		.ALUOp(aluop_buffer),
		.Operation(operation)
	);

	alu_64bit_mul ALU
	(
		.a(val_a),
		.b(val_b),
		.aluop(operation),
		.res(result),
		.zero(zero)
	);

	mul2x1 mux3
	(
		.sel(memtoreg_bf),
		.a(result),
		.b(readdata),
		.data_out(writedata)
	);

	registerFile reg_file
	(
		.rs1(rs1_buffer),
		.rs2(rs2_buffer),
		.rd(rd_buffer),
		.WriteData(writedata_bf),
		.ReadData1(readdata1_buffer),
		.ReadData2(readdata2_buffer),
		.clk(clk),
		.reset(reset),
		.RegWrite(regwrite_bf)
	);

	mul2x1 mux2
	(
		.sel(is_branch),
		.a(adj_ins),
		.b(branch_address),
		.data_out(PC_In)
	);

	Data_Memory data_mem
	(
		.Mem_Addr(result),
		.Write_Data(readdata2_buffer),
		.MemWrite(memwrite_bf),
		.MemRead(memread_bf),
		.clk(clk),
		.Read_Data(readdata)
	);
		
	always @(posedge clk) 
		begin
			$monitor("PC_In = ", PC_In, ", PC_Out = ", PC_Out, ", Instruction = %b", Ins_buffer,
			", Opcode = %b", opcode, ", Funct3 = %b", funct3, ", rs1 = %d", rs1, ", rs2 = %d",
			rs2, ", rd = %d", rd);/*, ", funct7 = %b", funct7, ", ALUOp = %b", aluop, 
			", imm_value = ", imm64, ", Operation = %b", operation, ", val_a = ", 
			val_a, ", val_b = ", val_b, ", result = ", result, ", alusrc = %b", alusrc,
			" RegWrite = ", regwrite, " MemtoReg = ", memtoreg, " MemRead = ", 
			memread, " readdata = ", readdata, " is_branch = ", is_branch, " zero = ", zero,
			" ReadData1 = ", readdata1, " ReadData2 = ", readdata2);*/
		end
endmodule	