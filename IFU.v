`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:04:45 11/29/2017 
// Design Name: 
// Module Name:    IFU 
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
	module IFU(
	 input [1:0] nPC_sel,
	 input disable_PC,
	 input cmp,
    input [25:0] im26,
    input [31:0] MFRSD,
    input clk,
    input reset,
    output [31:0] instr,
    output [31:0] PC_add_4
    );
	
	reg [31:0] PC;
	
	initial begin
		PC <= 31'h0000_3000;		//PC初始化
	end
	
	im IM(PC[13:2]-12'b1100_0000_0000,instr);		//im模块 减去了PC初始化的3000
	
	assign PC_add_4 = PC + 4;
	
	always @(posedge clk) begin
		if(reset) begin
			PC <= 31'h0000_3000;
		end
		else if(disable_PC) begin
			PC <= PC;
		end
		else begin
			case(nPC_sel) 
			2'b00: PC <= PC + 4;	//正常
			2'b01: begin			//beq
				if(cmp)
					PC <= PC + {{14{im26[15]}}, im26[15:0], {2{1'b0}}};		//ATTENTION!!!!!!!
				else 
					PC <= PC + 4;
			end
			2'b10: PC <= {PC[31:28], im26, 2'b00};//jal j
			2'b11: PC <= MFRSD;				//jr jalr
			endcase
		end
	end
	
	/*module sign_ext_18to32(
    input [17:0] im,
    output [31:0] S_Ext
    );*/
	//wire [31:0] signext_offset_00;
	//sign_ext_18to32 beq_ext({im[15:0],{2{0}}},signext_offset_00);
	/*wire IM32_beq = {{16{IM16[15]}},IM16}<<2  + PC + 4;
	wire IM32_jal = {{6{1'b0}},instr_index}<<2;
	wire mux2input2;

	
	MUX2_32 MUX1(PC_out, IM32_beq, ifBeqZero, mux2input2);
	MUX4_32 MUX2(PC_out, mux2input2, IM32_jal, alu_result, nPC_sel, mux2pc);*/
	
	//sign_ext_18to32 beqjump({)
endmodule
