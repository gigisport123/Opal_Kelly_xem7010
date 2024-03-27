`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2024 05:56:13 PM
// Design Name: 
// Module Name: clk_mux
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

`define RESET 2'b00
`define WRITE_to_FPGA 2'b01
`define READ_to_PC 2'b10
`define STOP 2'b11

module clk_mux(
    input wire DUT_clk,
    input wire ti_clk,
    input wire [1:0] state,
    output reg mux_clk
);

always@* begin
    if (state == `READ_to_PC) mux_clk = ti_clk;
    else mux_clk = DUT_clk;
end

endmodule
