`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:11:01 11/27/2017 
// Design Name: 
// Module Name:    GRF 
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
module GRF(
		input clk,
		input [31:0] PC_add_4,
		input [31:0] PC8_W2D,
		input WE_GRF,
		input reset,
		input [4:0] A1, A2, A3,
		input [31:0] WD,
		output [31:0] RD1, RD2
    );
	
	reg [31:0] regfile [31:0];
	reg [31:0] cnt;
	integer i;
	
	assign RD1 = (A1!=0)?regfile[A1]:0;		//$0”¿‘∂ ‰≥ˆ0
	assign RD2 = (A2!=0)?regfile[A2]:0;		//$0”¿‘∂ ‰≥ˆ0
	
	initial begin
		for(i=0;i<32;i=i+1)
			regfile[i] <= 0;
		cnt <= 0;
	end
	
	always @(posedge clk) begin
		cnt <= cnt + 1;
		if(reset) begin
			for(i=0;i<32;i=i+1) begin
				regfile[i] <= 0;
			end
		end
		
		else if(WE_GRF) begin
			if(A3 != 5'b0) begin
				$display("%d@%h: $%d <= %h", $time, PC8_W2D-8, A3,WD);
				regfile[A3] <= WD;
			end
		end
	end
	
endmodule
