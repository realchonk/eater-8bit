module program_counter(
	inout [3:0] data,
	
	input clk,
	input rst,
	input co,		// Program Counter Out
	input j,			// Jump
	input ce			// Increment
);

reg [3:0] pc = 0;

always@ (posedge clk, posedge rst)
begin
	if (rst) pc <= 4'b0;
	else if (j) pc <= data;
	else if (ce) pc <= pc + 1'b1;
end

assign data = co ? pc : 4'bz;

endmodule
