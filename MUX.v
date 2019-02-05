`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:58:21 11/29/2017 
// Design Name: 
// Module Name:    MUX 
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
module MUX2_32(
		input sel,
		input [31:0] a1,
		input [31:0] a2,
		output [31:0] c
    );

	assign c = sel ? a2 : a1;			//ATTENTION HERE !!!!!!!!!!!1
	
endmodule

module MUX4_32(
		input [1:0] sel,
		input [31:0] a1,a2,a3,a4,
		output [31:0] c
    );

	assign c = (sel==0) ? a1 : 
				  (sel==2'b01) ? a2 : 
				  (sel==2'b10) ? a3 :
				  a4;
	
endmodule

module MUX4_5(
		input [1:0] sel,
		input [4:0] a1,a2,a3,a4,
		output [4:0] c
    );

	assign c = (sel==0) ? a1 : 
				  (sel==2'b01) ? a2 : 
				  (sel==2'b10) ? a3 :
				  a4;
	
endmodule