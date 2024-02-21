`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 18, 2024
// Description: fsm for clock domain of "write from DUT to FIFO"
//////////////////////////////////////////////////////////////////////////////////

`define RESET 2'b00
`define FIFO_in_WRITE 2'b01
`define FIFO_in_WAIT 2'b10

module DUT_to_FIFO_fsm (
//    input wire rst,
    input wire clk,
    input wire [5:0] wr_data_cnt,
    input wire fifo_full,
    output reg write_en
    );
    
    reg [1:0] state;
    reg [1:0] state_next;
    
    always@* begin
        case (state)
            `RESET: state_next = (fifo_full == 0) ? `FIFO_in_WRITE : `RESET;
            `FIFO_in_WRITE: state_next = (fifo_full == 1) ? `FIFO_in_WAIT : `FIFO_in_WRITE;
            `FIFO_in_WAIT:  state_next = (wr_data_cnt == 0) ? `FIFO_in_WRITE : `FIFO_in_WAIT;
            default: state_next = state;
        endcase
    end
    
    always@* begin
        write_en = (state == `FIFO_in_WRITE) ? 1'b1 : 1'b0;
    end
    
    always@(posedge clk) begin
        if ((fifo_full == 1) && (wr_data_cnt == 0)) state <= `RESET;
        else state <= state_next;
    end

endmodule    