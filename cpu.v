// If defined, empty cycles are skipped
`define ENABLE_T_OPTIM

module cpu(
	output [7:0] HEX0,
	output [7:0] HEX1,
	output [7:0] HEX2,
	output [9:0] LEDR,
	input [9:0] SW,
	
	output hlt_out,
	input clk,
	input rst
);

// Main System Bus
wire [7:0] bus;

reg [2:0] T = 0;
wire T_rst;

// Flags
reg carry, zero;

// Control Wires
wire a_wr, a_en;
wire b_wr, b_en;
wire ir_wr, ir_en;
wire alu_en, alu_su, alu_co, alu_zo;
wire ram_en, ram_wr;
wire mar_wr;
wire pc_co, pc_j, pc_ce;
wire sseg_wr;
wire hlt;

// Other Wires
wire [3:0] ram_addr;
wire [7:0] alu_a;
wire [7:0] alu_b;
wire [3:0] instr_opcode;
wire [15:0] control_word;

assign LEDR[7:0] = bus;
assign LEDR[8] = clk;
assign LEDR[9] = hlt;
assign hlt_out = hlt;
assign b_en = 1'b0;

assign hlt		= control_word[0];
assign mar_wr	= control_word[1];
assign ram_wr	= control_word[2];
assign ram_en	= control_word[3];
assign ir_wr	= control_word[4];
assign ir_en	= control_word[5];
assign a_wr		= control_word[6];
assign a_en		= control_word[7];
assign alu_en	= control_word[8];
assign alu_su	= control_word[9];
assign b_wr		= control_word[10];
assign sseg_wr	= control_word[11];
assign pc_ce	= control_word[12];
assign pc_co	= control_word[13];
assign pc_j		= control_word[14];
assign T_rst	= control_word[15];

// Register A
register reg_a(
	.data(bus),
	.data_alu(alu_a),
	.clk(clk),
	.rst(rst),
	.wr(a_wr),
	.en(a_en)
);

// Register B
register reg_b(
	.data(bus),
	.data_alu(alu_b),
	.clk(clk),
	.rst(rst),
	.wr(b_wr),
	.en(b_en)
);

// Instruction Register
instr_reg ir(
	.data(bus),
	.instr_out(instr_opcode),
	.clk(clk),
	.rst(rst),
	.wr(ir_wr),
	.en(ir_en)
);

// Arithmetic/Logic Unit
alu add_sub(
	.a_in(alu_a),
	.b_in(alu_b),
	.alu_out(bus),
	.en(alu_en),
	.su(alu_su),
	.carry_out(alu_co),
	.zero_out(alu_zo)
);

// Memory Address Register
memory_addr_reg mar(
	.addr_in(bus[3:0]),
	.addr_out(ram_addr),
	.clk(clk),
	.rst(rst),
	.wr(mar_wr)
);

// 16 byte Memory
ram mem(
	.addr_in(ram_addr),
	.data(bus),
	.clk(clk),
	.en(ram_en),
	.wr(ram_wr)
);

// Program Counter (4 bits)
program_counter pc(
	.data(bus[3:0]),
	.clk(clk),
	.rst(rst),
	.co(pc_co),
	.j(pc_j),
	.ce(pc_ce)
);

// 7 Segment Controller
sseg_controller sseg(
	.value_in(bus),
	.HEX0(HEX0),
	.HEX1(HEX1),
	.HEX2(HEX2),
	.clk(clk),
	.rst(rst),
	.wr(sseg_wr)
);

microcode_rom mc(
	.instr(instr_opcode),
	.state(T),
	.control_word_out(control_word),
	.carry_in(carry),
	.zero_in(zero)
);

always@ (negedge clk, posedge rst)
begin
	if (rst) T <= 3'b0;
`ifdef ENABLE_T_OPTIM
	else if (T_rst || T == 3'd4) T <= 3'b0;
`else
	else if (T == 3'd4) T <= 3'b0;
`endif
	else T <= T + 3'b1;
end

always@ (posedge clk)
begin
	if (alu_en)
	begin
		carry <= alu_co;
		zero <= alu_zo;
	end
end

endmodule
