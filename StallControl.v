`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:33:31 12/13/2017 
// Design Name: 
// Module Name:    StallControl 
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
module StallControl(
    input Stall_Data,
    output disable_PC,
    output stall_IF_ID,
    output flash_ID_EX
    );

	assign disable_PC = Stall_Data;
	assign stall_IF_ID = Stall_Data;
	assign flash_ID_EX = Stall_Data;
endmodule
