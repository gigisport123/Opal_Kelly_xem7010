`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/11/2024 07:49:34 PM
// Design Name: 
// Module Name: clock_div
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


module clock_div(
    input wire rst,
    input wire clk,         // 200MHz FPGA clock
    output reg clk_50MHz,   // generated 50MHz clock
    output reg clk_25MHz    // generated 25MHz clock
    );
    
    reg clk_100MHz;
    
    always@(posedge clk or posedge rst) begin
        if (rst) clk_100MHz <= 0;
        else clk_100MHz <= ~clk_100MHz;
    end
    
    always@(posedge clk_100MHz or posedge rst) begin
        if (rst) clk_50MHz <= 0;
        else clk_50MHz <= ~clk_50MHz;
    end
    
    always@(posedge clk_50MHz or posedge rst) begin
        clk_25MHz <= ~clk_25MHz;
    end   
    
endmodule
