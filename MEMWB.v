module MEMWB
(
	input clk,
	input [63:0] DM_buffer_in,
	input [63:0] aluResult_in,
	input [4:0] rd_in,
	input [1:0] wbBuffer_in,
    
	output reg [63:0] DM_buffer_out,
	output reg [63:0] aluResult_out,
	output reg [4:0] rd_out,
	output reg [1:0] wbBuffer_out
);


    always @(posedge clk)
        begin
            DM_buffer_out = DM_buffer_in;
            aluResult_out = aluResult_in;
            rd_out = rd_in;
            wbBuffer_out = wbBuffer_in;
        end

endmodule
