`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:17:55 12/14/2017 
// Design Name: 
// Module Name:    MEM 
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
module MEM(
    input [31:0] IR_M,
    input [1:0] FRTM,
    input [31:0] R_RT_M,
    input [31:0] M_RD,
    input clk,
    input reset,
    input [31:0] PC8_M,
    input [31:0] AO_M,
    output [31:0] DM_out
    );
	
	wire [31:0] MFRTM;
	wire [1:0] stype;
	wire [3:0] be;
	
	Controller fun_ctrl_M(
		.IR(IR_M),
		.MemWrite(MemWrite),
		.stype(stype)
	 );
	 
	 MUX4_32 MUX_MFRTM(
		FRTM,
		R_RT_M,
		M_RD,
		,
		,
		MFRTM
	 );
	 
	 BE b_e(AO_M[1:0],stype,be);
	 
	 DM dm(
		.clk(clk), 
		.reset(reset), 
		.be(be),
		.stype(stype),
		.MemWrite(MemWrite), 
		.PC_add_8(PC8_M), 		// PC+8，display用
		.addr(AO_M), 			// 写入的完整地址，display用
		.MemData(MFRTM), 			// 写入的数据
		.MemAddr(AO_M[13:2]), //用于执行操作的地址
		.Dataout(DM_out)				//数据输出
	 );	
	
endmodule
