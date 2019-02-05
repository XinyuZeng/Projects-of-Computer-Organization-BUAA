`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:14:17 11/29/2017 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
	input cmp_w,
    input [31:0] IR,
    output [1:0] RegDst,
    output ALUSrc,
    output [1:0] Mem2Reg,
    output RegWrite,
    output MemWrite,
    output [1:0] nPC_sel,
    output [1:0] ExtOp,
    output [3:0] ALUOp,
	 output [2:0] bctrl,
	 output [1:0] stype,
	 output [2:0] ltype,
	 output [2:0] XALUOp,
	 output start,
	 output hilo_ctrl,
	 output AO_ctrl
    );
	wire [5:0] op = IR[`op];
	wire [5:0] func = IR[`func];
	wire [4:0] rt = IR[`rt];
	
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
	wire msub = op == 6'b011100;

	wire beq = op ==  6'b000100;
	wire bne = op ==  6'b000101;
	wire blez = op == 6'b000110 && rt == 5'b00000;
	wire bltz = op == 6'b000001 && rt == 5'b00000;
	wire bgez = op == 6'b000001 && rt == 5'b00001;
	wire bgtz = op == 6'b000111 && rt == 5'b00000;
	wire bgezal = op == 6'b000001 && rt == 5'b10001;
	
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
	//以上与AT_Decoder相同
	//cal_r不需改RegDst和RegWrite，要改ALUOp； cal_i不需改ALUSrc和RegWrite，要改ExtOp和ALUOp
	//乘除可能要改的地方：start-乘除指令都要改 
	//			 	  RegDst,RegWrite-mfhi和mflo这种把hi lo的值读到寄存器里的要改  
	//				  XALUOp-改hi lo的值的要改 
	//				  AO_ctrl-mfhi和mflo这种读出hi lo的值的要改
	
	assign start = mult + multu + div + divu + mthi + mtlo + msub;
	
	assign RegDst[1:0] = (jal || bgezal) ? 2'b10 :
						 (cal_r || movz || mfhi || mflo || jalr) ? 2'b01 : 2'b00,	
						 
		   ALUSrc = cal_i || load || store,
	
		   Mem2Reg[1:0] = (jal || bgezal || jalr) ? 2'b10 :
							load ? 2'b01 : 2'b00,
							
		   RegWrite = cal_r || cal_i || load || jal || (bgezal && cmp_w) || jalr ||(movz && cmp_w) || mfhi || mflo,
		   MemWrite = store,
			 
		   nPC_sel[1] = jal || jr || j || jalr,
		   nPC_sel[0] = branch || jr || bgezal || jalr,
			 
		   ExtOp[1:0] = (lui) ? 2'b10 :
						(load || store || addiu || addi || slti || sltiu) ? 2'b01 : 2'b00,
						  
		   ALUOp[3:0] = and_ ? 4'b0011 :
						or_ ? 4'b0010 :
						xor_ ? 4'b0100 :
						nor_ ? 4'b0101 :
						andi ? 4'b0011 :
						xori ? 4'b0100 :
						slt ? 4'b0110 :
						slti ? 4'b0110 :
						sltiu ? 4'b0111 :
						sltu ? 4'b0111 :
						sll ? 4'b1000 :
						sllv ? 4'b1001 :
						srl ? 4'b1010 :
						srlv ? 4'b1011 :
						sra ? 4'b1100 :
						srav ? 4'b1101 :
						ori ? 4'b0010 :
						(sub || subu) ? 4'b0001 : 4'b0000,
						  
		   hilo_ctrl = mflo;
			 
	 
	assign bctrl[2:0] = beq ? `beq :
						bne ? `bne :
						blez ? `blez : 
						bltz ? `bltz :
						(bgez || bgezal) ? `bgez :
						bgtz ? `bgtz :
						movz ? `movz : `beq;
						
	assign stype[1:0] = (sw == 1'b1) ? `sw :
						(sh == 1'b1) ? `sh :
						(sb == 1'b1) ? `sb :
												0;
	assign ltype[2:0] = lw ? `lw :
						lh ? `lh :
						lhu ? `lhu :
						lb ? `lb :
						lbu ? `lbu : `lw;
			
	assign XALUOp[2:0] = mult ? `mult :
						 multu ? `multu :
						 div ? `div :
						 divu ? `divu :
						 mthi ? `mthi :
						 mtlo ? `mtlo : 
						 msub ? `msub : `mult;
	
	assign AO_ctrl = mfhi || mflo;
	///////////////////////end of basic control////////////////////////		 
			 
	wire [4:0] num =  addu ? 5'd1 : 
							subu ? 5'd2 : 
							jr ? 5'd3 : 
							movz ? 5'd4 : 
						   ori ? 5'd5 : 
							lw ? 5'd6 : 
							sw ? 5'd7 : 
							beq ? 5'd8 :
						   lui ? 5'd9 : 
							jal ? 5'd10 : 
							j ? 5'd11 : 
							bgezal ? 5'd12 :
						   addiu ? 5'd13 : 
							sh ? 5'd14 : 
							sb ? 5'd15 : 
							lh ? 5'd16 :
						   lhu ? 5'd17 : 
							lb ? 5'd18 : 
							lbu ? 5'd19 : 
							5'd20;
		/*assign {RegDst, ALUSrc, Mem2Reg, RegWrite, MemWrite, nPC_sel, ExtOp, ALUOp} = 
			({op,func} == {`ifR,`addu_func}) ? 13'b01_0_00_1_0_00_00_00 :
			({op,func} == {`ifR,`subu_func}) ? 13'b0100010000001 :
			({op,func} == {`ifR,`jr_func}) ? 13'b0000000110000 :
			(op == `ori) ? 13'b0010010000010 :
			(op == `lw) ? 13'b0010110000100 :
			(op == `sw) ? 13'b0010001000100 :
			(op == `beq) ? 13'b0000000010001 :
			(op == `lui) ? 13'b0010010001000 :
			(op == `jal) ? 13'b1001010100000 : 
			13'b0000000000 ;*/
	//({op,func} == {`ifR,`addu_func}) ? {`RegDst_rd,`ALUSrc_rt,`Mem2Reg_ALU_Result,`RegWrite_1,`MemWrite_0,`nPC_sel_PC_add_4,`ExtOp_unsigned,`ALUOp_add} :
endmodule
/*
	RegDst: 2'b00: 写rt
			  2'b01:  rd
			  2'b10:  $31
	ALUSrc : 0 : GPR(rt)
				1 : extend_im16
	Mem2Reg : 00: ALU_result
				 01: DM_out
				 10: PC+4
	RegWrite
	MemWrite
	nPC_sel: 00: PC+4
			   01: beq
				10: jal
				11: jr
	Extop: 00: unsigned
			 01: signed
			 10: lui
	ALUOp 00: +
			01: -
			10: |
			11: ?
*/
/*
`define ifR 6'b000000
`define addu_func 6'b100001
`define subu_func 6'b100011
`define jr_func 6'b001000
`define ori 6'b001101
`define lw 6'b100011
`define sw 6'b101011
`define beq 6'b000100
`define lui 6'b001111
`define jal 6'b000011

//RegDst
`define rt 2'b00
`define rd 2'b01
`define ra 2'b10

`define ALUSrc_rt 1'b0
`define ALUSrc_im32 1'b1

`define Mem2Reg_ALU_result 2'b00
`define Mem2Reg_DM_out 2'b01
`define Mem2Reg_PC_add_4 2'b10

`define RegWrite_0 1'b0
`define RegWrite_1 1'b1

`define MemWrite_0 1'b0
`define MemWrite_1 1'b1

`define nPC_sel_PC_add_4 2'b00
`define nPC_sel_beq 2'b01
`define nPC_sel_jal 2'b10
`define nPC_sel_jr 2'b11

`define ExtOp_unsigned 2'b00
`define ExtOp_signed 2'b01
`define ExtOp_lui 2'b10

`define ALUOp_add 2'b00
`define ALUOp_sub 2'b01
`define ALUOp_or 2'b10
`define ALUOp_? 2'b11 */