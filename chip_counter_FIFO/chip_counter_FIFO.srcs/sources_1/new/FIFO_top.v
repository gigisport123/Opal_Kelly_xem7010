`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 16, 2024
// Description: test top level fsm with fifo
//////////////////////////////////////////////////////////////////////////////////

`define RESET 2'b00
`define WRITE_to_FPGA 2'b01
`define READ_to_PC 2'b10
`define STOP 2'b11

module FIFO_top (
    input wire rst,
    input wire clk_2fs,
    input wire ti_clk,
    input wire [5:0] DUT_data_in,
    input wire PC_read_en,
    output wire [15:0] pipe_data_out,
//    output wire [1:0] state,              // monitor state for debugging
//    output wire [2:0] cnt_write_fifo_debug,   // debug for write fifo cnt
//    output wire [1:0] cnt_read_fifo_debug,// debug for read fifo cnt
//    output wire fifo_full,
    output wire PC_trigger                   // trigger the PC pipeout command
//    output wire [5:0] wr_data_count,
//    output wire [5:0] rd_data_count,
//    output wire [47:0] FIFO_din,            // debug: FIFO input data
//    output wire [47:0] FIFO_dout,            // debug: FIFO output data
//    output wire fifo_wr_en,                 // debug: FIFO input enable
//    output wire fifo_rd_en                  // debug: FIFO output enable
);

    wire [47:0] FIFO_din;
    wire [47:0] FIFO_dout;
    wire fifo_wr_en;
    wire fifo_rd_en;
    wire fifo_full;
    wire fifo_empty;
    wire write_en;
//    wire read_en;
    wire [5:0] wr_data_count;
    wire [5:0] rd_data_count;
    wire [2:0] cnt_write_fifo_debug;
    wire [1:0] cnt_read_fifo_debug;

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


//fsm U_fsm(
//    .rst (rst),
//    .clk (clk_2fs),
//    .full (fifo_full),
//    .empty (fifo_empty),
//    .read_en (read_en),
//    .write_en (write_en),
//    .state (state)
//    );

DUT_to_FIFO_fsm U_DUT_to_FIFO_fsm(
//    .rst (rst),
    .clk (clk_2fs),
    .fifo_full (fifo_full),
    .wr_data_cnt (wr_data_count),
    .write_en (write_en)
    );
  
DUT_to_FIFO U_DUT_to_FIFO(
    .write_en (write_en),
    .data (DUT_data_in),
    .clk (clk_2fs),
    .dout (FIFO_din),
    .data_ready (fifo_wr_en),
    .cnt (cnt_write_fifo_debug)
    );

fifo_to_PC_fsm U_fifo_to_PC_fsm(
    .rst (rst),
    .clk (ti_clk),
    .fifo_empty (fifo_empty),
    .rd_data_cnt (rd_data_count),
    .PC_trigger (PC_trigger)
    );
    
FIFO_to_PC U_FIFO_to_PC(
    .rst (rst),
//    .enable (read_en),
    .read_en (PC_read_en),
    .ti_clk (ti_clk),
    .data_in (FIFO_dout),
    .data_out (pipe_data_out),
    .read_fifo (fifo_rd_en),
    .cnt (cnt_read_fifo_debug)
    );

endmodule