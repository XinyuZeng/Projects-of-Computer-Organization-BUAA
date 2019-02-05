`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:46:26 12/13/2017 
// Design Name: 
// Module Name:    FourController 
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
module FourController(
	input busy_real,
	input cmp_d,
    input [31:0] IR_D,
    input clk,
    input reset,
    output disable_PC,
    output stall_IF_ID,
    output reset_ID_EX,
    output [1:0] FRSD,
    output [1:0] FRTD,
    output [1:0] FRSE,
    output [1:0] FRTE,
    output [1:0] FRTM
    );
    
    wire Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1, Tuse_rt2;
    wire [4:0] A1, A2, A3, A1_E, A2_E, A3_E, A1_M, A2_M, A3_M, A1_W, A2_W, A3_W;
    wire [1:0] Res, Res_E, Res_M, Res_W;
	wire Dchengchu;
	
    AT_Decoder at_decoder(cmp_d, IR_D, Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1, Tuse_rt2, A1, A2, A3, Res, Dchengchu);

    wire reset_ctrlpipeE = reset || reset_ID_EX;    ///ATTENTION!!!!!!!!!
    ControlPipeE controlpipeE(
		clk, reset_ctrlpipeE, Res, A1, A2, A3, 
		Res_E, A1_E, A2_E, A3_E
	);

    ControlPipeM controlpipeM(
		clk, reset, Res_E, A1_E, A2_E, A3_E, 
		Res_M, A1_M, A2_M, A3_M
	);

    ControlPipeW controlpipeW(
		clk, reset, Res_M, A1_M, A2_M, A3_M, 
		Res_W, A1_W, A2_W, A3_W
	);

    wire Stall_Data;
    StallDetect stalldetect(Dchengchu, busy_real,Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1, Tuse_rt2, A1, A2, A3_E, A3_M, A3_W, Res_E, Res_M, Res_W, Stall_Data);

    StallControl stallcontrol(Stall_Data, disable_PC, stall_IF_ID, reset_ID_EX);

    ForwardControl forwardcontrol(A1, A2, A1_E, A2_E, A2_M, A3_E, A3_M, A3_W, Res_E, Res_M, Res_W, FRSD, FRTD, FRSE, FRTE, FRTM);
    
endmodule