module IDEX
(
	input clk, input [63:0] pcbufferin, readData1bufferin, readData2bufferin, immDatabufferin, input [4:0] rs1bufferin, rs2bufferin, rdbufferin, input [3:0] functbufferin, input [2:0] mBufferin, input [1:0] wbBufferin, aluOpin, input aluSrcin,

	output reg [63:0] pcbufferout, readData1bufferout, readData2bufferout, immDatabufferout,
	output reg [4:0] rs1bufferout, rs2bufferout, rdbufferout,
	output reg [3:0] functbufferout,
	output reg [2:0] mBufferout,
	output reg [1:0] wbBufferout, aluOpout,
	output reg aluSrcout
);

always @(posedge clk)
begin
	 rdbufferout = rdbufferin;
	 functbufferout = functbufferin;
	 mBufferout = mBufferin;
	 wbBufferout = wbBufferin;
	 aluOpout = aluOpin;
	 aluSrcout = aluSrcin;
	 pcbufferout = pcbufferin;
	 readData1bufferout = readData1bufferin;
	 readData2bufferout = readData2bufferin;
	 immDatabufferout = immDatabufferin;
	 rs1bufferout = rs1bufferin;
	 rs2bufferout = rs2bufferin;
end

endmodule