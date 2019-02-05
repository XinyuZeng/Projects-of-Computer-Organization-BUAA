`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:35:44 11/27/2017 
// Design Name: 
// Module Name:    im 
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
module im(
    input [13:2] addr,
    output [31:0] instr
    );
	
	reg [31:0] im_reg [4096:0];
	
	integer i;
	initial begin
		/*for(i=0;i<1024;i=i+1)
			im_reg[i] <= 0;*/
		$readmemh("code.txt", im_reg,0);
		/*for(i=0;i<8;i=i+1)
			$display("im_reg[%d]=%b",i,im_reg[i]);*/
	end
	
	assign instr = im_reg[addr];
endmodule
