`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:32:44 12/11/2017 
// Design Name: 
// Module Name:    R_Pipe 
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
module PipeR_IF_ID(
    input clk,
    input reset,
    input stall,
    input [31:0] IR,
    input [31:0] ADD4,
    output reg [31:0] IR_D,
    output reg [31:0] PC4_D,
    output reg [31:0] PC8_D
    );
	
	integer i;
	
	initial begin
		for(i=0;i<32;i=i+1) begin
			IR_D[i] <= 0;
			PC4_D[i] <= 0;
			PC8_D[i] <=0;
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			IR_D <= 0;
			PC4_D <= 0;
			PC8_D <=0;
		end
		
		else if(stall)begin
			IR_D <= IR_D;
			PC4_D <= PC4_D;
			PC8_D <= PC8_D;
		end
		else begin
			IR_D <= IR;
			PC4_D <= ADD4;
			PC8_D <= ADD4+4;
		end
	end

endmodule

module PipeR_ID_EX(
	input cmp,
		input clk,
		input reset,
		inout [31:0] IR_D,
		input [31:0] PC8_D,
		input [31:0] MFRSD,
		input [31:0] MFRTD,
		input [31:0] im32,
		output reg [31:0] IR_E,
		output reg [31:0] PC8_E,
		output reg [31:0] R_RS_E,
		output reg [31:0] R_RT_E,
		output reg [31:0] im32_E,
		output reg cmp_e
	);
	
	integer i;
	
	initial begin
		for(i=0;i<32;i=i+1) begin
			IR_E[i] <= 0;
			PC8_E[i] <= 0;
			R_RS_E[i] <= 0;
			R_RT_E[i] <= 0;
			im32_E[i] <= 0;
			cmp_e <= 0;
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			IR_E <= 0;
			PC8_E <= 0;
			R_RS_E <= 0;
			R_RT_E <= 0;
			im32_E <= 0;
			cmp_e <= 0;
		end
		
		else begin
			IR_E <= IR_D;
			PC8_E <= PC8_D;
			R_RS_E <= MFRSD;
			R_RT_E <= MFRTD;
			im32_E <= im32;
			cmp_e <= cmp;
		end
	end
	
endmodule

module PipeR_EX_MEM(
		input cmp_e,
		input clk,
		input reset,
		input [31:0] IR_E,
		input [31:0] PC8_E,
		input [31:0] ALUout,
		input [31:0] XALUout,
		input [31:0] MFRTE,
		output reg [31:0] IR_M,
		output reg [31:0] PC8_M,
		output reg [31:0] AO_M,
		output reg [31:0] XAO_M,
		output reg [31:0] MFRTE_M,
		output reg cmp_m
	);
	
	integer i;
	
	initial begin
		for(i=0;i<32;i=i+1) begin
			IR_M[i] <= 0;
			PC8_M[i] <= 0;
			AO_M[i] <= 0;
			XAO_M[i] <= 0;
			MFRTE_M[i] <= 0;
			cmp_m <= 0;
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			IR_M <= 0;
			PC8_M <= 0;
			AO_M <= 0;
			XAO_M[i] <= 0;
			MFRTE_M <= 0;
			cmp_m <= 0;
		end
		
		else begin
			IR_M <= IR_E;
			PC8_M <= PC8_E;
			AO_M <= ALUout;
			XAO_M <= XALUout;
			MFRTE_M <= MFRTE;
			cmp_m <= cmp_e;
		end
	end
	
endmodule

module PipeR_MEM_WB(
		input [31:0] XAO_M,
		input cmp_m,
		input clk,
		input reset,
		inout [31:0] IR_M,
		input [31:0] PC8_M,
		input [31:0] ALUout_M,
		input [31:0] DM_out,
		output reg [31:0] IR_W,
		output reg [31:0] PC8_W,
		output reg [31:0] ALUout_W,
		output reg [31:0] DM_W,
		output reg cmp_w,
		output reg [31:0] XAO_W
	);
	
	integer i;
	
	initial begin
		for(i=0;i<32;i=i+1) begin
			IR_W[i] <= 0;
			PC8_W[i] <= 0;
			ALUout_W[i] <= 0;
			DM_W[i] <= 0;
			cmp_w <= 0;
			XAO_W[i] <= 0;
		end
	end
	
	always @(posedge clk) begin
		if(reset) begin
			IR_W <= 0;
			PC8_W <= 0;
			ALUout_W <= 0;
			DM_W <= 0;
			cmp_w <= 0;
			XAO_W <= 0;
		end
		
		else begin
			IR_W <= IR_M;
			PC8_W <= PC8_M;
			ALUout_W <= ALUout_M;
			DM_W <= DM_out;
			cmp_w <= cmp_m;
			XAO_W <= XAO_M;
		end
	end
	
endmodule

module ControlPipeE(
	input clk,
	input reset,
	input [1:0] Res,
	input [4:0] A1,
	input [4:0] A2,
	input [4:0] A3,
	output reg [1:0] Res_E,
	output reg [4:0] A1_E,
	output reg [4:0] A2_E,
	output reg [4:0] A3_E
	);
	
	always @(posedge clk) begin
		if (reset) begin
			// reset
			Res_E <= 0;
			A1_E <= 0;
			A2_E <= 0;
			A3_E <= 0;
		end
		else begin
			Res_E <= Res;
			A1_E <= A1;
			A2_E <= A2;
			A3_E <= A3;
		end
	end

endmodule

module ControlPipeM(
	input clk,
	input reset,
	input [1:0] Res_E,
	input [4:0] A1_E,
	input [4:0] A2_E,
	input [4:0] A3_E,
	output reg [1:0] Res_M,
	output reg [4:0] A1_M,
	output reg [4:0] A2_M,
	output reg [4:0] A3_M
	);
	
	always @(posedge clk) begin
		if (reset) begin
			// reset
			Res_M <= 0;
			A1_M <= 0;
			A2_M <= 0;
			A3_M <= 0;
		end
		else begin
			Res_M <= Res_E;
			A1_M <= A1_E;
			A2_M <= A2_E;
			A3_M <= A3_E;
		end
	end

endmodule

module ControlPipeW(
	input clk,
	input reset,
	input [1:0] Res_M,
	input [4:0] A1_M,
	input [4:0] A2_M,
	input [4:0] A3_M,
	output reg [1:0] Res_W,
	output reg [4:0] A1_W,
	output reg [4:0] A2_W,
	output reg [4:0] A3_W
	);
	
	always @(posedge clk) begin
		if (reset) begin
			// reset
			Res_W <= 0;
			A1_W <= 0;
			A2_W <= 0;
			A3_W <= 0;
		end
		else begin
			Res_W <= Res_M;
			A1_W <= A1_M;
			A2_W <= A2_M;
			A3_W <= A3_M;
		end
	end

endmodule