module clock_divider(
	input clk_in,
	input rst,
	output reg clk_out
);

parameter DIVISOR = 2;
localparam counter_bits = $clog2(DIVISOR + 1)-1;
reg [counter_bits:0] counter;

always@ (posedge clk_in, posedge rst)
begin
	if (rst)
	begin
		counter <= 0;
		clk_out <= 1'b0;
	end
	else
	begin
		counter = counter + 1'b1;
		if (counter == DIVISOR)
		begin
			counter <= 0;
			clk_out <= ~clk_out;
		end
	end
end

endmodule
