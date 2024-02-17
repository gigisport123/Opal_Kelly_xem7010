`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 15, 2024
// Description: combinational wire out data to aviod clock domain crossing
//////////////////////////////////////////////////////////////////////////////////

module wireout #(parameter N = 800) (
    input wire [6*N-1:0] mem,
    output reg [31:0] out1,
    output reg [31:0] out2,
    output reg [31:0] out3,
    output reg [31:0] out4,
    output reg [31:0] out5,
    output reg [31:0] out6,
    output reg [31:0] out7,
    output reg [31:0] out8,
    output reg [31:0] out9,
    output reg [31:0] out10,
    output reg [31:0] out11,
    output reg [31:0] out12,
    output reg [31:0] out13,
    output reg [31:0] out14,
    output reg [31:0] out15,
    output reg [31:0] out16,
    output reg [31:0] out17,
    output reg [31:0] out18,
    output reg [31:0] out19,
    output reg [31:0] out20,
    output reg [31:0] out21,
    output reg [31:0] out22,
    output reg [31:0] out23,
    output reg [31:0] out24,
    output reg [31:0] out25
    );
    
    always@* begin
        out1 = mem[32*1-1:0];
        out2 = mem[32*2-1:0];
        out3 = mem[32*3-1:0];
        out4 = mem[32*4-1:0];
        out5 = mem[32*5-1:0];
        out6 = mem[32*6-1:0];
        out7 = mem[32*7-1:0];
        out8 = mem[32*8-1:0];
        out9 = mem[32*9-1:0];
        out10 = mem[32*10-1:0];
        out11 = mem[32*11-1:0];
        out12 = mem[32*12-1:0];
        out13 = mem[32*13-1:0];
        out14 = mem[32*14-1:0];
        out15 = mem[32*15-1:0];
        out16 = mem[32*16-1:0];
        out17 = mem[32*17-1:0];
        out18 = mem[32*18-1:0];
        out19 = mem[32*19-1:0];
        out20 = mem[32*20-1:0];
        out21 = mem[32*21-1:0];
        out22 = mem[32*22-1:0];
        out23 = mem[32*23-1:0];
        out24 = mem[32*24-1:0];
        out25 = mem[32*25-1:0];
    end
endmodule
