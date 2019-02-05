`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:03:17 12/21/2017 
// Design Name: 
// Module Name:    BE 
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
module BE(
    input [1:0] addr10,
    input [1:0] stype,
    output [3:0] be
    );

	assign be = (stype == `sw) ? 4'b1111 :
			      (stype == `sh) && (addr10 == 2'b00) ? 4'b0011 :
					(stype == `sh) && (addr10 == 2'b10) ? 4'b1100 :
					(stype == `sb) && (addr10 == 2'b00) ? 4'b0001 :
					(stype == `sb) && (addr10 == 2'b01) ? 4'b0010 :
					(stype == `sb) && (addr10 == 2'b10) ? 4'b0100 :
					(stype == `sb) && (addr10 == 2'b11) ? 4'b1000 : 4'b1111;
	
endmodule
