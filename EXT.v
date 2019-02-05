`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:33:26 11/29/2017 
// Design Name: 
// Module Name:    EXT 
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
module EXT(
    input [15:0] IM16,
    input [1:0] ExtOp,
    output reg [31:0] IM32
    );
	
	always @* begin
		case(ExtOp)
		2'b00: IM32 <= {{16{1'b0}},IM16};			//zero_extend
		2'b01: IM32 <= {{16{IM16[15]}},IM16};		//sign_extend
		2'b10: IM32 <= ({{16{1'b0}},IM16} << 16);	//lui
		endcase
	end

endmodule
