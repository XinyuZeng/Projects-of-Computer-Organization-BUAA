`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:39:54 12/12/2017 
// Design Name: 
// Module Name:    head 
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
`define op 31:26
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define func 5:0
`define ifR 6'b000000
`define addu_func 6'b100001
`define subu_func 6'b100011
`define jr_func 6'b001000

//Res的值
`define PC8 2'b11
`define DM 2'b10
`define ALU 2'b01
`define NW 2'b00

//转发源
`define AO_M 2'b11
`define PC8_M 2'b10
`define M_RD 2'b01

//BE
`define sw 2'b00
`define sh 2'b01
`define sb 2'b10

//loadext
`define lw 3'b000
`define lh 3'b001
`define lhu 3'b010
`define lb 3'b011
`define lbu 3'b100

//cmp
`define beq 3'b000
`define bne 3'b001
`define blez 3'b010
`define bltz 3'b011
`define bgez 3'b100
`define bgtz 3'b101
`define movz 3'b110

//XALUOp
`define mult 3'b000
`define multu 3'b001
`define div 3'b010
`define divu 3'b011
`define mthi 3'b100
`define mtlo 3'b101
`define msub 3'b110