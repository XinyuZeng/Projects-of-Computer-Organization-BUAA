`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:35 12/12/2017 
// Design Name: 
// Module Name:    EX 
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
module EX(
	input clk,
	input reset,
    input [31:0] IR_E,
    input [1:0] FRSE,
    input [31:0] R_RS_E,
    input [31:0] PC8_M,
    input [31:0] AO_M,
	 input [31:0] M_RD,
    input [1:0] FRTE,
    input [31:0] R_RT_E,
    input [31:0] im32_E,
    output [31:0] ALU_result,
	 output [31:0] MFRTE,
	 output busy_real,
	 output [31:0] XALU_result
    );
	
	wire [3:0] ALUOp;
	wire [2:0] XALUOp;
	wire start, busy, hilo_ctrl, AO_ctrl;
	wire [31:0] HI;
	wire [31:0] LO;
	wire [31:0] ALU_result_origin;
	assign busy_real = busy || start;
	
	Controller func_ctrl_E(
		.IR(IR_E),
		.ALUOp(ALUOp),
		.ALUSrc(ALUSrc),
		.XALUOp(XALUOp),
		.start(start),
		.hilo_ctrl(hilo_ctrl),
		.AO_ctrl(AO_ctrl)
	 );
	 wire [31:0] MFRSE;
	 MUX4_32 MUX_MFRSE(
		FRSE,				//来自控制层
		R_RS_E,//
		M_RD,//
		PC8_M,//
		AO_M,//
		MFRSE
	 );
	 MUX4_32 MUX_MFRTE(
		FRTE,				//来自控制层
		R_RT_E, //
		M_RD,//
		PC8_M,//
		AO_M,//
		MFRTE
	 );
	 wire [31:0] ALUSrcB;
	 MUX2_32 MUX_ALUSrcB(	// 控制ALU的B运算数
		ALUSrc, 		//
		MFRTE, 		//
		im32_E, 		//扩展后的im32
		ALUSrcB
	 ); 
	 ALU alu(
		.ALUOp(ALUOp), //
		.im5(IR_E[10:6]),
		.A(MFRSE), //
		.B(ALUSrcB), //
		.C(ALU_result_origin)
	 );
	 
	 XALU xalu(
    .clk(clk),
    .reset(reset),
	.XALUOp(XALUOp),
    .A(MFRSE),
	.B(ALUSrcB),
    .start(start),
    .HI(HI),
    .LO(LO),
    .busy(busy)
    );
	
	MUX2_32 MUX_HILO(
		hilo_ctrl,
		HI,
		LO,
		XALU_result
	);
	
	assign ALU_result = AO_ctrl ? XALU_result : ALU_result_origin;

endmodule
