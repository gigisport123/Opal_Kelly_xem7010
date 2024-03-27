`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2024 04:35:56 PM
// Design Name: 
// Module Name: read_to_PC_tb
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


module read_to_PC_tb;

parameter N = 8;
parameter M = 3;

// Inputs
reg rst;
reg read_en;
reg ti_clk;
reg [6*N-1:0] mem;

// Outputs
wire [15:0] data_out;
wire empty;


read_to_PC #(.N(N), .M(M)) U_read (
    .rst (rst),
    .read_en (read_en),
    .ti_clk (ti_clk),
    .mem (mem),
    .data_out (data_out),
    .empty (empty)
    );
    
initial begin
    forever #100 ti_clk = ~ti_clk;    // 50MHz clock, period 20ns
end
// to mimic 48MHz ti_clk (DUT_clock is 40MHz)

/* asynchronous clock freq @ 48MHz
for simulation, use @50MHz (period = 20ns)
*/

initial begin
    rst = 0;
    read_en = 0;
    ti_clk = 1;
    mem = 48'b000111000111000111000111000111000111000111000111;
    
    # 100
    rst = 1;
    # 100
    rst = 0;
    
    # 200
    read_en = 1;
end

endmodule
