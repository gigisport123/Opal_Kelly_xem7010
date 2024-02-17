`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2024 06:50:19 PM
// Design Name: 
// Module Name: clk_gen_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clk_gen_tb;

// inputs
reg clk;
reg rst;

// outputs
wire clk_50MHz;
wire clk_25MHz;

clock_div U_clk_gen(
    .rst (rst),
    .clk (clk),         // 200MHz FPGA clock
    .clk_50MHz (clk_50MHz),   // generated 50MHz clock
    .clk_25MHz (clk_25MHz)   // generated 25MHz clock
    );
    
initial begin
    clk = 0;
    rst = 0;
    #5 rst = 1;
    #5 rst = 0;
    forever #40 clk = ~clk;
end
endmodule
