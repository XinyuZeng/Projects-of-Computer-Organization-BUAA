`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:35:36 12/13/2017 
// Design Name: 
// Module Name:    ForwardControl 
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
module ForwardControl(
    input [4:0] A1_D,
    input [4:0] A2_D,
    input [4:0] A1_E,
    input [4:0] A2_E,
    input [4:0] A2_M,
    input [4:0] A3_E,
    input [4:0] A3_M,
    input [4:0] A3_W,
    input [1:0] Res_E,
    input [1:0] Res_M,
    input [1:0] Res_W,
    output [1:0] FRSD,
    output [1:0] FRTD,
    output [1:0] FRSE,
    output [1:0] FRTE,
    output [1:0] FRTM
    );
    
    assign 	FRSD = A1_D == 0 ? 0 :
				A1_D == A3_M && Res_M == `ALU ? `AO_M :
            A1_D == A3_M && Res_M == `PC8 ? `PC8_M :
            A1_D == A3_W && (Res_W == `ALU || Res_W == `DM || Res_W == `PC8) ? `M_RD : 0;

    assign 	FRTD = A2_D == 0 ? 0 :
				A2_D == A3_M && Res_M == `ALU ? `AO_M :
            A2_D == A3_M && Res_M == `PC8 ? `PC8_M :
            A2_D == A3_W && (Res_W == `ALU || Res_W == `DM || Res_W == `PC8) ? `M_RD : 0;

    assign FRSE = A1_E == 0 ? 0 :
			  A1_E == A3_M && Res_M == `ALU ? `AO_M :
           A1_E == A3_M && Res_M == `PC8 ? `PC8_M :
           A1_E == A3_W && (Res_W == `ALU || Res_W == `DM || Res_W == `PC8) ? `M_RD : 0;

    assign FRTE = A2_E == 0 ? 0 :
			  A2_E == A3_M && Res_M == `ALU ? `AO_M :
           A2_E == A3_M && Res_M == `PC8 ? `PC8_M :
           A2_E == A3_W && (Res_W == `ALU || Res_W == `DM || Res_W == `PC8) ? `M_RD : 0;

    assign FRTM = A2_M == 0 ? 0 :
			  A2_M == A3_W && (Res_W == `ALU || Res_W == `DM || Res_W == `PC8) ? `M_RD : 0;

endmodule
