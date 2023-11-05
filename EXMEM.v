module EXMEM(
	input clk, zero_in,
	input [63:0] branch_in, aluResult_in, forwardB_in,
	input [4:0] rd_in,
	input [2:0] mBuffer_in,
	input [1:0] wbBuffer_in,
	output reg zero_out,
	output reg [63:0] branch_out, aluResult_out, forwardB_out,
	output reg [4:0] rd_out,
	output reg [2:0] mBuffer_out,
	output reg [1:0] wbBuffer_out
);

always @(posedge clk)
begin
	zero_out = zero_in;
	branch_out = branch_in;
	aluResult_out = aluResult_in;
	forwardB_out = forwardB_in;
	rd_out = rd_in;
	mBuffer_out = mBuffer_in;
	wbBuffer_out = wbBuffer_in;
end

endmodule