`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:50:08 12/13/2017 
// Design Name: 
// Module Name:    AT_Decoder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "head.v"
module AT_Decoder(
	input cmp_d,
    input [31:0] IR_D,
    output Tuse_rs0,
    output Tuse_rs1,
    output Tuse_rt0,
    output Tuse_rt1,
    output Tuse_rt2,
    output [4:0] A1,
    output [4:0] A2,
    output reg [4:0] A3,
    output reg [1:0] Res,
	output Dchengchu
    );
///////////////////////////ATTENTION!!!!!!请确认指令编码，Tuse, Res, A3, (Dchengchu)均已填写//////////////////////////////
	wire [5:0] op = IR_D[`op];
	wire [5:0] func = IR_D[`func];
	wire [4:0] rt = IR_D[`rt];
	
	wire ifR = op==6'b000000;
	
	wire add = ifR && func == 6'b100000;
	wire sub = ifR && func == 6'b100010;
	wire addu = ifR && func == 6'b100001;
	wire subu = ifR && func == 6'b100011;
	wire jr = ifR && func == 6'b001000;
	wire movz = ifR && func == 6'b001010;
	wire mult = ifR && func == 6'b011000;
	wire multu = ifR && func == 6'b011001;
	wire div = ifR && func == 6'b011010;
	wire divu = ifR && func == 6'b011011;
	wire mfhi = ifR && func == 6'b010000;
	wire mflo = ifR && func == 6'b010010;
	wire mthi = ifR && func == 6'b010001;
	wire mtlo = ifR && func == 6'b010011;
	wire and_ = ifR && func == 6'b100100;	//attention
	wire or_ = ifR && func == 6'b100101;
	wire xor_ = ifR && func == 6'b100110;
	wire nor_ = ifR && func == 6'b100111;
	wire slt = ifR && func == 6'b101010;
	wire sltu = ifR && func == 6'b101011;
	wire sll = ifR && func == 6'b000000;
	wire sllv = ifR && func == 6'b000100;
	wire srl = ifR && func == 6'b000010;
	wire srlv = ifR && func == 6'b000110;
	wire sra = ifR && func == 6'b000011;
	wire srav = ifR && func == 6'b000111;
	wire jalr = ifR && func == 6'b001001;
	
	wire ori = op == 6'b001101;
	wire lui = op == 6'b001111;
	wire addiu = op == 6'b001001;
	wire addi = op == 6'b001000;
	wire andi = op == 6'b001100;	
	wire xori = op == 6'b001110;
	wire slti = op == 6'b001010;
	wire sltiu = op == 6'b001011;

	wire beq = op ==  6'b000100;
	wire bne = op ==  6'b000101;
	wire blez = op == 6'b000110 && rt == 5'b00000;
	wire bltz = op == 6'b000001 && rt == 5'b00000;
	wire bgez = op == 6'b000001 && rt == 5'b00001;
	wire bgtz = op == 6'b000111 && rt == 5'b00000;
	wire bgezal = op == 6'b000001 && rt == 5'b10001;
	wire msub = op == 6'b011100;
	
	wire jal = op == 6'b000011;
	wire j = op == 6'b000010;
	
	wire sw = op == 6'b101011;
	wire sh = op == 6'b101001;
	wire sb = op == 6'b101000;
	wire lw = op == 6'b100011;
	wire lh = op == 6'b100001;
	wire lhu = op == 6'b100101;
	wire lb = op == 6'b100000;
	wire lbu = op == 6'b100100;
	
	wire shift = sll || sllv || srl || srlv || sra || srav;
	wire cal_r = add || addu || sub || subu ||  and_ || or_ || xor_ || nor_ || slt || sltu || shift;
	wire cal_i = ori || lui || addiu || addi || andi || xori || slti || sltiu;
	wire store = sw || sh || sb;
	wire load = lw || lh || lhu || lb || lbu;
	wire branch = beq || bne || blez || bgtz || bltz || bgez;
	//从此往上和Controller一样
	//属于cal_r和cal_i的指令底下就不用改了
	//乘除可能要改的地方：Tuse-写入类指令 Res,A3-读出类指令 Dchengchu-!所有!
	
	wire branch_noz = beq + bne;
	wire branch_z = blez + bgtz + bltz + bgez;	///////////注意这里和controller就不一样了！！！！/////////////
	
	//以下为有Tuse的指令需要改的东西
	assign Tuse_rs0 = branch + jr + bgezal + jalr;
	assign Tuse_rs1 = cal_r + cal_i + load + store + movz + mult + multu + div + divu + mthi + mtlo + msub;
	assign Tuse_rt0 = branch_noz + movz;
	assign Tuse_rt1 = cal_r + mult + multu + div + divu + msub;
	assign Tuse_rt2 = store;

	assign A1 = IR_D[`rs];
	assign A2 = IR_D[`rt];
	
	assign Dchengchu = mult + multu + div + divu + mfhi + mflo + mthi + mtlo + msub;
	
	//以下为有Tnew的指令需要改的东西 Res and A3
	always @* begin
		if(cal_r || cal_i || (movz && cmp_d) || mfhi || mflo) 
			Res <= `ALU;
		else if(load) 
			Res <= `DM;
		else if(jal || (bgezal && cmp_d) || jalr) 
			Res <= `PC8;
		else 
			Res <= `NW;

		if(jal || (bgezal && cmp_d))
			A3 <= 5'b11111;
		else if(cal_r|| (movz && cmp_d) || mfhi || mflo || jalr)
			A3 <= IR_D[`rd];
		else 
			A3 <= IR_D[`rt];
		//else
		//	A3 <= 5'b11110;
	end
endmodule