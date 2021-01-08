module alu(
	input [7:0] a_in,
	input [7:0] b_in,
	output [7:0] alu_out,
	
	input en,
	input su,
	output carry_out,
	output zero_out
);

reg [8:0] result;

always@ (a_in or b_in or su)
begin
	if (su) result <= a_in - b_in;
	else result <= a_in + b_in;
end

assign alu_out = en ? result[7:0] : 8'bz;
assign carry_out = result[8];
assign zero_out = !result;

endmodule
