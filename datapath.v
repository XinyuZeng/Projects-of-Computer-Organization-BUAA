`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:48:11 11/27/2017 
// Design Name: 
// Module Name:    datapath 
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
module datapath(
	input clk,
	input reset,
    input disable_PC,
    input stall_IF_ID,
    input reset_ID_EX,
    input [1:0] FRSD,
    input [1:0] FRTD,
    input [1:0] FRSE,
    input [1:0] FRTE,
    input [1:0] FRTM,
    output [31:0] IR_D,
	 output cmp,
	 output busy_real
    );
	
	 wire [31:0]instr, ALU_result, XALU_result, PC_add_4, im32, DM_out, PC8_W2D;
	 wire [25:0] im26;
	 wire [4:0] rs, rt, rd, im5, RegAddr;
	 wire [1:0] nPC_sel;
	 //wire cmp;
	
	wire [31:0] PC4_D, PC8_D;
	wire [31:0] IR_E, PC8_E, R_RS_E, R_RT_E, im32_E;
	wire [31:0] IR_M, PC8_M, AO_M, 	MFRSD, MFRTD, MFRTE, MFRTM, R_RT_M;
	wire [31:0] IR_W, PC8_W, AO_W, DM_W, M_RD;
	wire [31:0] XAO_M, XAO_W;
	
	 IFU ifu(
	 .nPC_sel(nPC_sel),
	 .disable_PC(disable_PC),
	 .cmp(cmp),
    .im26(IR_D[25:0]),
    .MFRSD(MFRSD),
    .clk(clk),
    .reset(reset),
    .instr(instr),
    .PC_add_4(PC_add_4)
    );
	 
	 
	 PipeR_IF_ID pipeR_IF_ID(
		.clk(clk),
		.reset(reset),
		.stall(stall_IF_ID),			//
		.IR(instr),
		.ADD4(PC_add_4),
		.IR_D(IR_D),
		.PC4_D(PC4_D),
		.PC8_D(PC8_D)
	 );
	 
	 ID id(
    .clk(clk),
    .reset(reset),
    .IR_D(IR_D),
    .PC4_D(PC4_D),
	.PC8_W2D(PC8_W2D),
    .RegWrite(RegWrite),
    .RegAddr(RegAddr),
    .RegData(M_RD),				//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    .FRSD(FRSD),
    .FRTD(FRTD),
    .PC8_M(PC8_M),
    .AO_M(AO_M),
    .M_RD(M_RD),
    .nPC_sel(nPC_sel),
    .MFRSD(MFRSD),
    .MFRTD(MFRTD),
    .cmp(cmp),
    .im32(im32)
    );
	
	wire reset_ID_EX_intotal = reset || reset_ID_EX;
	 PipeR_ID_EX pipeR_ID_EX(
		.cmp(cmp),
		.clk(clk),
		.reset(reset_ID_EX_intotal),
		.IR_D(IR_D),
		.PC8_D(PC8_D),
		.MFRSD(MFRSD),
		.MFRTD(MFRTD),
		.im32(im32),
		.IR_E(IR_E),
		.PC8_E(PC8_E),
		.R_RS_E(R_RS_E),
		.R_RT_E(R_RT_E),
		.im32_E(im32_E),
		.cmp_e(cmp_e)
	 );
	 
	EX ex(
		clk, reset, IR_E,FRSE,R_RS_E,PC8_M,AO_M,M_RD,FRTE,R_RT_E,im32_E,
		ALU_result,MFRTE, busy_real, XALU_result
	);
	
	PipeR_EX_MEM pipeR_EX_MEM(
		.cmp_e(cmp_e),
		.clk(clk),
		.reset(reset),
		.IR_E(IR_E),
		.PC8_E(PC8_E),
		.ALUout(ALU_result),
		.XALUout(XALU_result),
		.MFRTE(MFRTE),
		.IR_M(IR_M),
		.PC8_M(PC8_M),
		.AO_M(AO_M),
		.XAO_M(XAO_M),
		.MFRTE_M(R_RT_M),
		.cmp_m(cmp_m)
	);
	 
	MEM mem(
		IR_M, FRTM, R_RT_M, M_RD, clk, reset, PC8_M, AO_M, 
		DM_out
	);
	
	PipeR_MEM_WB pipeR_MEM_WB(
		XAO_M, cmp_m,clk, reset, IR_M, PC8_M, AO_M, DM_out, 
		IR_W, PC8_W, AO_W, DM_W,cmp_w, XAO_W
	);
	 
	WB wb(
		XAO_W, cmp_w,IR_W,AO_W,DM_W, PC8_W,
		RegAddr,M_RD, RegWrite, PC8_W2D
	);
	
endmodule
