module instr_reg(
	inout [7:0] data,
	output [3:0] instr_out,
	
	input clk,
	input rst,
	input wr,
	input en
);

reg [7:0] value;

always@ (posedge clk, posedge rst)
begin
	if (rst) value <= 8'b0;
	else if (wr) value <= data;
end

assign data = en ? (8'b0 | value[3:0]) : 8'bz;
assign instr_out = value[7:4];

endmodule
