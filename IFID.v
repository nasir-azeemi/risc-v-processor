module IFID(
	input clk,
	input [63:0] pc_buffer_in,
	input [31:0] instruction_buffer_in,
	output reg [63:0] pc_buffer_out,
	output reg [31:0] instruction_buffer_out
);

always @(posedge clk)
begin
	pc_buffer_out = pc_buffer_in;
	instruction_buffer_out = instruction_buffer_in;
end

endmodule