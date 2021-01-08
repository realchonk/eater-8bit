module register(
	inout [7:0] data,
	output [7:0] data_alu,
	
	input clk,
	input rst,
	input wr,
	input en
);
parameter DEFAULT_VALUE = 8'b0;

reg [7:0] value = DEFAULT_VALUE;

always@ (posedge clk, posedge rst)
begin
	if (rst) value <= DEFAULT_VALUE;
	else if (wr) value <= data;
end

assign data = en ? value : 8'bz;
assign data_alu = value;

endmodule
