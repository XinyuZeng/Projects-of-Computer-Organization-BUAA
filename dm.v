`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:48:46 11/27/2017 
// Design Name: 
// Module Name:    dm 
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
module DM(
    input clk,
    input reset,
	 input [3:0] be,
	 input [1:0] stype,
	 input MemWrite,
	 input [31:0] PC_add_8,
	 input [31:0] addr,		// display用
	 input [31:0] MemData,
    input [13:2] MemAddr,
    output [31:0] Dataout
    );
	
	reg [31:0] mem [4096:0];
	reg [31:0] cnt;
	integer i;
	
	assign Dataout = mem[MemAddr];

	initial begin
		for(i=0;i<1024;i=i+1)
			mem[i] <= 0;
		cnt <= 0;
	end
	
	always @(posedge clk) begin
		cnt <= cnt + 1;
		if(reset) begin
			for(i=0;i<1024;i=i+1) begin
				mem[i] <= 0;
			end
		end
		
		else if(MemWrite) begin
			if(stype == `sw) begin
				if(be[0]==1) mem[MemAddr][7:0] = MemData[7:0];
				if(be[1]==1) mem[MemAddr][15:8] = MemData[15:8];
				if(be[2]==1) mem[MemAddr][23:16] = MemData[23:16];
				if(be[3]==1) mem[MemAddr][31:24] = MemData[31:24];
				$display("%d@%h: *%h <= %h", $time, PC_add_8-8, {addr[31:2],{2{1'b0}}},mem[MemAddr]);//display的是首地址
			end
			else if(stype == `sh) begin
				if(be[0]==1) mem[MemAddr][7:0] = MemData[7:0];
				if(be[1]==1) mem[MemAddr][15:8] = MemData[15:8];
				if(be[2]==1) mem[MemAddr][23:16] = MemData[7:0];
				if(be[3]==1) mem[MemAddr][31:24] = MemData[15:8];
				$display("%d@%h: *%h <= %h", $time, PC_add_8-8, {addr[31:2],{2{1'b0}}},mem[MemAddr]);//display的是首地址
			end
			else if(stype == `sb) begin
				if(be[0]==1) mem[MemAddr][7:0] = MemData[7:0];
				if(be[1]==1) mem[MemAddr][15:8] = MemData[7:0];
				if(be[2]==1) mem[MemAddr][23:16] = MemData[7:0];
				if(be[3]==1) mem[MemAddr][31:24] = MemData[7:0];
				$display("%d@%h: *%h <= %h", $time, PC_add_8-8, {addr[31:2],{2{1'b0}}},mem[MemAddr]);//display的是首地址
			end
		end
	end
	    /* else if(MemWrite) begin
			$display("%d@%h: *%h <= %h", $time, PC_add_8-8, addr,MemData);
			mem[MemAddr] <= MemData;
		end*/ //$display("%d@%h: *%h <= %h", $time, PC_add_8-8, addr,MemData);mem[MemAddr] <= MemData;
		
		/*原始方法
			else if(sb) begin
				$display("@%h: *%h <= %h",PC_add_8-8, addr,MemData[7:0]);
				case(addr[1:0]) 
					2'b00:mem[MemAddr]] <= {mem[MemAddr][31:8], MemData[7:0]};
					2'b01:mem[MemAddr] <= {mem[MemAddr][31:16], MemData[7:0], mem[MemAddr][7:0]};
					2'b10:mem[MemAddr] <= {mem[MemAddr][31:24], MemData[7:0], mem[MemAddr][15:0]};
					2'b11:mem[MemAddr] <= {MemData[7:0], mem[MemAddr][23:0]};
				endcase
			end
		*/
		
endmodule
