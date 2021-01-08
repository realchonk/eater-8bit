module clock_controller(
	input clk_base,
	input step,
	input step_en,
	input hlt,
	input rst,
	
	output clk_out
);

parameter DIVISOR = 2;

wire clk_div_out;
reg step_en_buf = 1'b1;

clock_divider clk_div(
	.clk_in(clk_base),
	.clk_out(clk_div_out),
	.rst(rst)
);
defparam clk_div.DIVISOR = DIVISOR;

always@ (posedge clk_div_out)	step_en_buf <= step_en;

assign clk_out = !hlt && (step_en_buf ? step : clk_div_out);

endmodule
