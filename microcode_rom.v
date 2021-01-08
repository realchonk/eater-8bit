module microcode_rom(
	input [3:0] instr,
	input [2:0] state,
	output [15:0] control_word_out,
	input carry_in,
	input zero_in
);

wire [15:0] ucode2 [15:0];
wire [15:0] ucode3 [15:0];
wire [15:0] ucode4 [15:0];

reg [15:0] status;

always @(instr or state)
begin
	case (state)
	3'b000:	status <= 16'b0010_0000_0000_0010; // pc_out, mar_wr
	3'b001:	status <= 16'b0001_0000_0001_1000; // pc_count, ir_wr, ram_en
	3'b010:	status <= ucode2[instr];
	3'b011:	status <= ucode3[instr];
	3'b100:	status <= ucode4[instr];
	default:	status <= 16'b0;
	endcase
end

assign control_word_out = status;

assign ucode2[4'b0000] = 16'b1000_0000_0000_0000;	// NOP
assign ucode2[4'b0001] = 16'b0000_0000_0010_0010;	// LDA	(ir_en, mar_wr)
assign ucode2[4'b0010] = 16'b0000_0000_0010_0010;	// ADD	(ir_en, mar_wr)
assign ucode2[4'b0011] = 16'b0000_0000_0010_0010;	// SUB	(ir_en, mar_wr)
assign ucode2[4'b0100] = 16'b1000_0000_0110_0000;	// LDI	(a_wr, ir_en)
assign ucode2[4'b0101] = 16'b1100_0000_0010_0000;	// JMP	(pc_jmp, ir_en)
assign ucode2[4'b0110] = 16'b0000_0100_0010_0000;	// ADDI	(b_wr, ir_en)
assign ucode2[4'b0111] = 16'b0000_0100_0010_0000;	// SUBI	(b_wr, ir_en)
assign ucode2[4'b1000] = 16'b1000_0000_0010_0000 | (carry_in << 16'd14);	// JC		(pc_jmp = carry_in, ir_en)
assign ucode2[4'b1001] = 16'b1000_0000_0010_0000 | (zero_in  << 16'd14);	// JZ		(pc_jmp =  zero_in, ir_en)
assign ucode2[4'b1010] = 16'b0000_0000_0010_0010;	// CMP	(ir_en, mar_wr)
assign ucode2[4'b1011] = 16'b0000_0100_0010_0000;	// CMPI	(b_wr, ir_en)
assign ucode2[4'b1100] = 16'b0000_0000_0010_0010;	// STA	(ir_en, mar_wr)
assign ucode2[4'b1101] = 16'b1000_0000_0010_0000 | (~carry_in << 16'd14);	// JNC		(pc_jmp = ~carry_in, ir_en)
assign ucode2[4'b1110] = 16'b1000_1000_1000_0000;	// OUT	(a_en, 7seg_en)
assign ucode2[4'b1111] = 16'b1000_0000_0000_0001;	// HLT	(hlt)

assign ucode3[4'b0000] = 16'b0000_0000_0000_0000;	// NOP
assign ucode3[4'b0001] = 16'b1000_0000_0100_1000;	// LDA	(ram_en, a_wr)
assign ucode3[4'b0010] = 16'b0000_0100_0000_1000;	// ADD	(b_wr, ram_en)
assign ucode3[4'b0011] = 16'b0000_0100_0000_1000;	// SUB	(b_wr, ram_en)
assign ucode3[4'b0100] = 16'b0000_0000_0000_0000;	// LDI
assign ucode3[4'b0101] = 16'b0000_0000_0000_0000;	// JMP
assign ucode3[4'b0110] = 16'b1000_0001_0100_0000;	// ADDI	(alu_en, a_wr)
assign ucode3[4'b0111] = 16'b1000_0011_0100_0000;	// SUBI	(alu_su, alu_en, a_wr)
assign ucode3[4'b1000] = 16'b0000_0000_0000_0000;	// JC
assign ucode3[4'b1001] = 16'b0000_0000_0000_0000;	// JZ
assign ucode3[4'b1010] = 16'b0000_0100_0000_1000;	// CMP	(b_wr, ram_en)
assign ucode3[4'b1011] = 16'b1000_0011_0000_0000;	// CMPI	(alu_su, alu_en)
assign ucode3[4'b1100] = 16'b1000_0000_1000_0100;	// STA	(ram_wr, a_en)
assign ucode3[4'b1101] = 16'b0000_0000_0000_0000;	// JNC
assign ucode3[4'b1110] = 16'b0000_0000_0000_0000;	// OUT
assign ucode3[4'b1111] = 16'b0000_0000_0000_0000;	// HLT


assign ucode4[4'b0000] = 16'b0000_0000_0000_0000;	// NOP
assign ucode4[4'b0001] = 16'b0000_0000_0000_0000;	// LDA
assign ucode4[4'b0010] = 16'b1000_0001_0100_0000;	// ADD	(alu_en, a_wr)
assign ucode4[4'b0011] = 16'b1000_0011_0100_0000;	// SUB	(alu_su, alu_en, a_wr)
assign ucode4[4'b0100] = 16'b0000_0000_0000_0000;	// LDI
assign ucode4[4'b0101] = 16'b0000_0000_0000_0000;	// JMP
assign ucode4[4'b0110] = 16'b0000_0000_0000_0000;	// ADDI
assign ucode4[4'b0111] = 16'b0000_0000_0000_0000;	// SUBI
assign ucode4[4'b1000] = 16'b0000_0000_0000_0000;	// JC
assign ucode4[4'b1001] = 16'b0000_0000_0000_0000;	// JZ
assign ucode4[4'b1010] = 16'b1000_0011_0000_0000;	// CMP
assign ucode4[4'b1011] = 16'b0000_0000_0000_0000;	// CMPI
assign ucode4[4'b1100] = 16'b0000_0000_0000_0000;	// STA
assign ucode4[4'b1101] = 16'b0000_0000_0000_0000;	// JNC
assign ucode4[4'b1110] = 16'b0000_0000_0000_0000;	// OUT
assign ucode4[4'b1111] = 16'b0000_0000_0000_0000;	// HLT



endmodule
