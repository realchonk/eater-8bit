module sseg_display(
	input [3:0] digit,
	output reg [7:0] segment
);

always@ (digit)
begin
	case (digit)
	4'd0:		segment <= 8'b1100_0000;
	4'd1:		segment <= 8'b1111_1001;
	4'd2:		segment <= 8'b1010_0100;
	4'd3:		segment <= 8'b1011_0000;
	4'd4:		segment <= 8'b1001_1001;
	4'd5:		segment <= 8'b1001_0010;
	4'd6:		segment <= 8'b1000_0010;
	4'd7:		segment <= 8'b1111_1000;
	4'd8:		segment <= 8'b1000_0000;
	4'd9:		segment <= 8'b1001_0000;
	default:	segment <= 8'b0111_1111;
	endcase
end

endmodule

module sseg_decoder(
	input [7:0] data_in,
	output reg [3:0] digit0,
	output reg [3:0] digit1,
	output reg [3:0] digit2
);

always@ (data_in)
begin
	digit0 <= data_in % 8'd10;
	digit1 <= (data_in / 8'd10) % 8'd10;
	digit2 <= (data_in / 8'd100) % 8'd10;
end

endmodule

module sseg_controller(
	input [7:0] value_in,
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	
	input clk,
	input rst,
	input wr
);

reg [7:0] value = 0;
wire [3:0] digit0;
wire [3:0] digit1;
wire [3:0] digit2;

sseg_decoder dec(
	.data_in(value),
	.digit0(digit0),
	.digit1(digit1),
	.digit2(digit2)
);
sseg_display displ0(
	.digit(digit0),
	.segment(HEX0)
);
sseg_display displ1(
	.digit(digit1),
	.segment(HEX1)
);
sseg_display displ2(
	.digit(digit2),
	.segment(HEX2)
);

always@ (posedge clk, posedge rst)
begin
	if (rst) value <= 8'b0;
	else if (wr) value <= value_in;
end

endmodule
