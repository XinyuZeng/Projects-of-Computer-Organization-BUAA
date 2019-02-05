`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:38:15 12/25/2017 
// Design Name: 
// Module Name:    XALU 
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
module XALU(
    input clk,
    input reset,
	input [2:0] XALUOp,
    input [31:0] A,
    input [31:0] B,
    input start,
    output reg [31:0] HI,
    output reg [31:0] LO,
    output busy
    );
	
	reg [3:0] cnt;
	reg [31:0] tempHI;
	reg [31:0] tempLO;
	reg [64:0] temp_test;
	
	assign busy = cnt[3] || cnt[2] || cnt[1] || cnt[0];
	
	initial begin
		HI <= 0;
		LO <= 0;
		cnt <= 0;
	end
	
	always @(posedge clk) begin
		if(reset) begin
			HI <= 0;
			LO <= 0;
			cnt <= 0;
		end
		else begin
			if(start) begin
				case(XALUOp)
				`mult: begin			//ÓÐ·ûºÅ³Ë
					cnt <= 4'h5;
					//{HI,LO} <= $unsigned($unsigned(A) * $unsigned(B));
					{HI,LO} <= $signed(A) * $signed(B);
				end
				`multu: begin			//ÎÞ·ûºÅ³Ë
					cnt <= 4'h5;
					{HI,LO} <= A * B;
				end
				`div: begin				//ÓÐ·ûºÅ³ý
					cnt <= 4'ha;
					if(B==0) begin
						LO <= LO;
						HI <= HI;
					end
					else begin
						LO <= $signed(A) / $signed(B);
						HI <= $signed(A) % $signed(B);
					end
				end
				`divu: begin			//ÎÞ·ûºÅ³ý
					cnt <= 4'ha;
					if(B==0) begin
						LO <= LO;
						HI <= HI;
					end
					else begin
						LO <= A / B;
						HI <= A % B;
					end
				end
				`mthi: begin
					cnt <= 4'h1;
					HI <= A;
				end
				`mtlo: begin
					cnt <= 4'h1;
					LO <= A;
				end
				`msub: begin
					cnt <= 4'h5;
					{HI, LO} <= $signed({HI, LO}) - $signed(A) * $signed(B);
					//temp_test = $signed(A) * $signed(B);
					//{HI, LO} <= {HI, LO} -temp_test;
				end
				endcase
			end
			else if(cnt > 0) begin
				cnt <= cnt - 1;
			end
		end
	end
	
	
endmodule
