`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 9, 2024
// Description: finite state machine
//              three states: reset, write from DUT to FPGA, read from FPGA to PC
//////////////////////////////////////////////////////////////////////////////////


`define RESET 2'b00
`define WRITE_to_FPGA 2'b01
`define READ_to_PC 2'b10
`define STOP 2'b11

module fsm(
    input wire rst,
    input wire clk,
    input wire full,
    input wire empty,
//    output read_en,
    output write_en,
    output reg [1:0] state
    );
    
    reg [1:0] state_next;
    
    always@* begin
        case (state)
            `RESET: state_next = `WRITE_to_FPGA;
            `WRITE_to_FPGA: state_next = (full) ? `READ_to_PC : `WRITE_to_FPGA;
            `READ_to_PC:    state_next = (empty) ? `STOP : `READ_to_PC;
            `STOP:          state_next = `STOP;
        endcase
    end         
    
//    assign read_en = (state == `WRITE_to_FPGA) ? 1'b1 : 1'b0;
    assign write_en = (state == `WRITE_to_FPGA) ? 1'b1 : 1'b0;            
    
    always@(posedge clk or posedge rst) begin
        if (rst) state <= `RESET;
        else state <= state_next;
    end
    
endmodule
