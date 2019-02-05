`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:24:28 12/21/2017 
// Design Name: 
// Module Name:    loadext 
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
module loadext(
    input [1:0] addr10,
    input [31:0] DM_W,
    input [2:0] ltype,
    output [31:0] Dout
    );
	
	assign Dout = (ltype == `lw) ? DM_W :
	
					  (ltype == `lh && addr10[1] == 0) ? {{16{DM_W[15]}},DM_W[15:0]} :
					  (ltype == `lh && addr10[1] == 1) ? {{16{DM_W[31]}},DM_W[31:16]} :
					  
					  (ltype == `lhu && addr10[1] == 0) ? {{16{1'b0}},DM_W[15:0]} :
					  (ltype == `lhu && addr10[1] == 1) ? {{16{1'b0}},DM_W[31:16]} :
					  
					  (ltype == `lb && addr10 == 2'b00) ? {{24{DM_W[7]}},DM_W[7:0]} :
					  (ltype == `lb && addr10 == 2'b01) ? {{24{DM_W[15]}},DM_W[15:8]} :
					  (ltype == `lb && addr10 == 2'b10) ? {{24{DM_W[23]}},DM_W[23:16]} :
					  (ltype == `lb && addr10 == 2'b11) ? {{24{DM_W[31]}},DM_W[31:24]} :
					  
					  (ltype == `lbu && addr10 == 2'b00) ? {{24{1'b0}},DM_W[7:0]} :
					  (ltype == `lbu && addr10 == 2'b01) ? {{24{1'b0}},DM_W[15:8]} :
					  (ltype == `lbu && addr10 == 2'b10) ? {{24{1'b0}},DM_W[23:16]} :
					  (ltype == `lbu && addr10 == 2'b11) ? {{24{1'b0}},DM_W[31:24]} : DM_W;
					  

endmodule
