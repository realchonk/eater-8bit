module memory_addr_reg(
	input [3:0] addr_in,
	output [3:0] addr_out,
	
	input clk,
	input rst,
	input wr
);

reg [3:0] address;

always@ (posedge clk, posedge rst)
begin
	if (rst) address <= 4'b0;
	else if (wr) address <= addr_in;
end

assign addr_out = address;

endmodule



module ram(
	input [3:0] addr_in,
	inout [7:0] data,
	
	input clk,
	input en,
	input wr
);

reg [7:0] mem[15:0];

always@ (posedge clk)
begin
	if (wr) mem[addr_in] <= data;
end

assign data = en ? mem[addr_in] : 8'bz;

initial
begin
	mem[0] <= 8'b0100_0000;	// LDI 0
	mem[1] <= 8'b0110_0001; // ADDI 1
	mem[2] <= 8'b1000_0101; // JC 5
	mem[3] <= 8'b1110_0000; // OUT
	mem[4] <= 8'b0101_0001; // JMP 1
	mem[5] <= 8'b1111_0000; // HLT

/*
	mem[0] <= 8'b0000_0000; // LDA i
	mem[1] <= 8'b0000_0000; // CMP b
	mem[1] <= 8'b0000_0000; // JNC _
	mem[1] <= 8'b0000_0000; // HLT
	mem[1] <= 8'b0000_0000; // 
	
	mem[12] <= 8'd0;	// i
	mem[13] <= 8'd0;	// r
	mem[14] <= 8'd3	// a
	mem[15] <= 8'd5;	// b*/
end

endmodule
