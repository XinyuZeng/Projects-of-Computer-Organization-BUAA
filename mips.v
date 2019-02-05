`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:18:03 11/27/2017 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	wire disable_PC, stall_IF_ID, reset_ID_EX;
	wire [1:0] FRSD, FRTD, FRSE, FRTE, FRTM;
	wire [31:0] IR_D;
	wire cmp_d, busy_real;

	datapath dp(clk, reset, disable_PC, stall_IF_ID, reset_ID_EX, FRSD, FRTD, FRSE, FRTE, FRTM, IR_D, cmp_d, busy_real);

	FourController fourcontroller(busy_real, cmp_d, IR_D, clk, reset, disable_PC, stall_IF_ID, reset_ID_EX, FRSD, FRTD, FRSE, FRTE, FRTM);
endmodule

/*
	b类型指令：在ALU里加判断信号，引出来给IFU，当控制信号为该指令且判断信号为真时执行同beq的跳转
	sllv,srav,srlv等可变左右移：利用>>/>>>，改ALU
			`srav: begin
					C <= $signed(B) >>> A[4:0];
				end
	sll, sra, srl等移位：在MUX_RegData里加一路，其值为GPR_rt << im26[10:6](在MUX之前加个wire)
			wire [31:0] srl_result = GPR_rt >> im26[10:6];
			 MUX4_32 MUX_RegData(	//控制寄存器堆要写入的数据
				Mem2Reg, 
				ALU_result, //2'b00:运算指令结果
				DM_out, 		//2'b01:load指令结果
				PC_add_4, 	//2'b10:jal将PC+4存入
				srl_result, 
				RegData
			);
	slt,slti,sltiu,sltu：在ALU里加比较判断信号，将slt_judge?32'h0000_0001:0,即ALU_result给RegData。有符号比较$signed($signed(A)<$signed(B))
	sb,sh：需要加控制信号sb/sh，连到DM里，当控制信号为真时，case(addr[1:0])mem[addr[11:2]] <= {mem[11:2][31:8],MemData[7:0]}。注意改display！
			DM内if(sb) begin
				$display("@%h: *%h <= %h",PC_add_4-4, addr,MemData[7:0]);
				case(addr[1:0]) 
					2'b00:mem[addr[11:2]] <= {mem[addr[11:2]][31:8],MemData[7:0]};
					2'b01:mem[addr[11:2]] <= {mem[addr[11:2]][31:16],MemData[7:0],mem[addr[11:2]][7:0]};
					2'b10:mem[addr[11:2]] <= {mem[addr[11:2]][31:24],MemData[7:0],mem[addr[11:2]][15:0]};
					2'b11:mem[addr[11:2]] <= {MemData[7:0],mem[addr[11:2]][23:0]};
				endcase
			end
	lb, lh：改数据通路：wire [31:0] DM_out2 = ALU_result[1] ? {{16{1'b0}},DM_out[31:16]} : {{16{1'b0}},DM_out[15:0]};
				MUX4_32 MUX_RegData(	//控制寄存器堆要写入的数据
					Mem2Reg, 
					ALU_result, //2'b00:运算指令结果
					DM_out2, 		//2'b01:load指令结果
					PC_add_4, 	//2'b10:jal将PC+4存入
					, 
					RegData
				);
	jalr: PC同jr，PC+4存在rd
	j:类jal，不存PC到$31
	
	tips:
	1.写数字必须写位数！！！！
	2.A?B:C A=1时进B，写MUX时尤其需要注意！
	3.端口命名大小写统一……
	4.加新线记得声明！！！！！！！！！！！！！！！！！！！！
*/