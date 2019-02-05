`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:30:49 12/13/2017 
// Design Name: 
// Module Name:    StallDetect 
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
	module StallDetect(
	input Dchengchu,
	input busy_real,
    input Tuse_rs0,
    input Tuse_rs1,
    input Tuse_rt0,
    input Tuse_rt1,
    input Tuse_rt2,
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3_E,
    input [4:0] A3_M,
    input [4:0] A3_W,
    input [1:0] Res_E,
    input [1:0] Res_M,
    input [1:0] Res_W,
    output Stall_Data
    );
    
    wire stall_rs0_e1 = Tuse_rs0 && A1 == A3_E && Res_E == `ALU;
    wire stall_rs0_e2 = Tuse_rs0 && A1 == A3_E && Res_E == `DM;
    wire stall_rs0_m2 = Tuse_rs0 && A1 == A3_M && Res_M == `DM;
    wire stall_rs1_e2 = Tuse_rs1 && A1 == A3_E && Res_E == `DM;

    wire stall_rs = A1 == 0 ? 0 : (stall_rs0_e1 || stall_rs0_e2 || stall_rs0_m2 || stall_rs1_e2);

    wire stall_rt0_e1 = Tuse_rt0 && A2 == A3_E && Res_E == `ALU;
    wire stall_rt0_e2 = Tuse_rt0 && A2 == A3_E && Res_E == `DM;
    wire stall_rt0_m2 = Tuse_rt0 && A2 == A3_M && Res_M == `DM;
    wire stall_rt1_e2 = Tuse_rt1 && A2 == A3_E && Res_E == `DM;

    wire stall_rt = A2 == 0 ? 0 : (stall_rt0_e1 || stall_rt0_e2 || stall_rt0_m2 || stall_rt1_e2);

    assign Stall_Data = stall_rs || stall_rt || (Dchengchu && busy_real);

endmodule
