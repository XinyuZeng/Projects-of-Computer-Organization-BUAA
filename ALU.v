`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:29:08 11/29/2017 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
	input [3:0] ALUOp,
	input [4:0] im5,
    input [31:0] A,
    input [31:0] B,
    output reg [31:0] C
    );
	
	//assign zero = A==B;
	
	/*assign C = (ALUOp == `addu) ? (A+B):
				  (ALUOp == `subu) ? (A-B):
				  (ALUOp == `ori) ? (A|B) :
											4'b0000;*/
	always @* begin
		case(ALUOp)
		4'b0000: C <= A + B;
		4'b0001: C <= A - B;
		4'b0010: C <= A | B;
		4'b0011: C <= A & B;
		4'b0100: C <= A ^ B;
		4'b0101: C <= ~(A | B);
		4'b0110: C <= $signed(A) < $signed(B); //slt slti 多加signed了反而不对
		4'b0111: C <= {1'b0,A} < {1'b0,B};		//sltu sltiu
		4'b1000: C <= B << im5;		//sll 
		4'b1001: C <= B << A[4:0]; 	//sllv
		4'b1010: C <= B >> im5; 	//srl
		4'b1011: C <= B >> A[4:0];	//srlv
		4'b1100: C <= $signed(B) >>> im5; 	//sra
		4'b1101: C <= $signed(B) >>> A[4:0]; 	//srav
		default: C <= 0;
		endcase
	end

endmodule
