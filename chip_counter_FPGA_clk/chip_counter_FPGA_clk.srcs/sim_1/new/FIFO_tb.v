`timescale 0.1ns / 1ps


module FIFO_tb();
    
    reg rst;
    reg clk_2fs;
    reg ti_clk;
    reg [47:0] FIFO_din;
    reg fifo_wr_en;
    reg fifo_rd_en;
    wire [47:0] FIFO_dout;
    wire fifo_full;
    wire fifo_empty;
    wire [5:0] wr_data_count;
    wire [5:0] rd_data_count;
    
xil_fifo_w48_d63 U_FIFO (
    .rst (rst),
    .wr_clk (clk_2fs),
    .rd_clk (ti_clk),
    .din (FIFO_din),
    .wr_en (fifo_wr_en),
    .rd_en (fifo_rd_en),
    .dout (FIFO_dout),
    .full (fifo_full), 
    .empty (fifo_empty), 
    .rd_data_count (rd_data_count),
    .wr_data_count (wr_data_count),
    .wr_rst_busy (),
    .rd_rst_busy ()
);

initial begin
    forever #125 clk_2fs = ~clk_2fs;    // 40MHz clock, period 25ns
end

initial begin
    forever #100 ti_clk = ~ti_clk;      // 50MHz clock, period 20ns
end
// to mimic 48MHz ti_clk (DUT_clock is 40MHz)

/* asynchronous clock freq @ 48MHz
for simulation, use @50MHz (period = 20ns)
*/

initial begin
    rst = 0;
    clk_2fs = 1;
    ti_clk = 1;
    fifo_wr_en = 0;
    fifo_rd_en = 0;
    FIFO_din = 48'b000000001111111100000000111111110000000011111100;
end

initial begin
    # 100
    rst = 1;
    # 1000
    rst = 0;
end

endmodule
