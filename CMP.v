`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:19 12/11/2017 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
	input [2:0] bctrl,
    input [31:0] D1,
    input [31:0] D2,
    output  O
    );

	assign O = (bctrl[2:0] == `beq) ? (D1 == D2) : 
			   (bctrl[2:0] == `bne) ? (D1 != D2) : 
			   (bctrl[2:0] == `blez) ? $signed($signed(D1) <= $signed(0)) : 
			   (bctrl[2:0] == `bltz) ? $signed($signed(D1) < $signed(0)) :
			   (bctrl[2:0] == `bgez) ? $signed($signed(D1) >= $signed(0)) : 
			   (bctrl[2:0] == `bgtz) ? $signed($signed(D1) > $signed(0)) :
			   (bctrl[2:0] == `movz) ? (D2 == 0) : 
			   0 ;							
	
endmodule
