`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 16, 2024
// Description: test top level fsm with fifo
//////////////////////////////////////////////////////////////////////////////////


module FIFO_top_tb();
    
    reg rst;
    reg clk_2fs;
    reg ti_clk;
    reg [5:0] DUT_data_in;
    reg PC_read_en;
    wire [15:0] pipe_data_out;
//    wire [1:0] state;                   // monitor state for debugging
//    wire [2:0] cnt_write_fifo_debug;    // debug for write fifo cnt
//    wire [1:0] cnt_read_fifo_debug;     // debug for read fifo cnt
    wire PC_trigger;
//    wire fifo_full;
//    wire [5:0] wr_data_count;
//    wire [5:0] rd_data_count;
//    wire [47:0] FIFO_din;
//    wire [47:0] FIFO_dout;
//    wire fifo_rd_en;
//    wire fifo_wr_en;
    
FIFO_top U_FIFO_top(
    .rst (rst),
    .clk_2fs (clk_2fs),
    .ti_clk (ti_clk),
    .DUT_data_in (DUT_data_in),
    .PC_read_en (PC_read_en),
    .pipe_data_out (pipe_data_out),
//    .state (state),              // monitor state for debugging
//    .cnt_write_fifo_debug (cnt_write_fifo_debug),   // debug for write fifo cnt
//    .cnt_read_fifo_debug (cnt_read_fifo_debug), // debug for read fifo cnt
    .PC_trigger (PC_trigger)
//    .fifo_full (fifo_full),                      // debug for fifo full
//    .wr_data_count (wr_data_count),
//    .rd_data_count (rd_data_count),
//    .FIFO_din (FIFO_din),               // debug: FIFO input data
//    .FIFO_dout (FIFO_dout),              // debug: FIFO output data
//    .fifo_rd_en (fifo_rd_en),           // debug: FIFO read enable
//    .fifo_wr_en (fifo_wr_en)            // debug: FIFO write enable
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
    DUT_data_in = 6'b111110;
    PC_read_en = 0;
end

//initial begin
//    # (125*100) DUT_data_in = 6'b111111;
//    # (125*50) DUT_data_in = 6'b011000;
//end

initial begin
    # 100
    rst = 1;
    # 1000
    rst = 0;
end

initial begin
    # 200
    wait (PC_trigger) PC_read_en = 1;
end    

//initial begin    
//    # (100*30) PC_read_en = 1;
//end

endmodule
