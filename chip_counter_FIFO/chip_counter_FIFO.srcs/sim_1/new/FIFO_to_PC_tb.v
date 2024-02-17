`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 16, 2024
// Description: FIFO output to PC
//////////////////////////////////////////////////////////////////////////////////

module FIFO_to_PC_tb();

reg rst;
reg read_en;
reg ti_clk;
reg [47:0] data_in;
wire [15:0] data_out;
wire read_fifo;
wire [1:0] cnt;

FIFO_to_PC U_FIFO_to_PC(
    .rst (rst),
    .read_en (read_en),
    .ti_clk (ti_clk),
    .data_in (data_in),
    .data_out (data_out),
    .read_fifo (read_fifo),
    .cnt (cnt)
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
    data_in = 48'b000011000111000111000111000111000111000111000110;
    
    # 100
    rst = 1;
    # 100
    rst = 0;
    
    # 200
    read_en = 1;
end

 
endmodule
