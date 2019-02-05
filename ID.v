`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:38 12/12/2017 
// Design Name: 
// Module Name:    ID 
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
module ID(
    input clk,
    input reset,
    input [31:0] IR_D,
    input [31:0] PC4_D,
	input [31:0] PC8_W2D,
    input RegWrite,
    input [4:0] RegAddr,
    input [31:0] RegData,
    input [1:0] FRSD,
    input [1:0] FRTD,
    input [31:0] PC8_M,
    input [31:0] AO_M,
    input [31:0] M_RD,
    output [1:0] nPC_sel,
    output [31:0] MFRSD,
    output [31:0] MFRTD,
    output cmp,
    output [31:0] im32
    );
	wire [4:0] rs = IR_D[25:21],
			  rt = IR_D[20:16];
			  
	//wire [31:0] RegAddr, RegData, GPR_rs, GPR_rt, DM_out;
	wire [1:0] ExtOp;
	wire [31:0] GPR_rs, GPR_rt;
	wire [2:0] bctrl;
	Controller func_ctrl_D(
		.IR(IR_D),
		.nPC_sel(nPC_sel),
		.ExtOp(ExtOp),
		.bctrl(bctrl)
	 );
	 
	 GRF grf(
		.clk(clk),
		.PC_add_4(PC4_D),
		.PC8_W2D(PC8_W2D),
		.WE_GRF(RegWrite),
		.reset(reset),
		.A1(rs), .A2(rt), .A3(RegAddr),
		.WD(RegData),
		.RD1(GPR_rs), .RD2(GPR_rt)
    );
	 
	// wire [31:0] PC8_M, AO_M, M_RD, MFRSD, MFRTD;
	 MUX4_32 MUX_MFRSD(
		FRSD,
		GPR_rs,
		M_RD,
		PC8_M,
		AO_M,
		MFRSD
	);

	 MUX4_32 MUX_MFRTD(
		FRTD,
		GPR_rt,
		M_RD,
		PC8_M,
		AO_M,
		MFRTD
	);
	
	 CMP cmpu(bctrl,MFRSD,MFRTD,cmp);
	 
	 EXT ext(IR_D[15:0], ExtOp, im32);

endmodule
