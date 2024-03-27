`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 18, 2024
// Description: fsm for clock domain of "read from FIFO to PC"
//////////////////////////////////////////////////////////////////////////////////

`define RESET 2'b00
`define FIFO_out_WAIT 2'b01
`define FIFO_out_READ 2'b10

module fifo_to_PC_fsm(
    input wire rst,
    input wire clk,
    input wire fifo_empty,
    input wire [5:0] rd_data_cnt,
    output wire PC_trigger
    );
    
    reg [1:0] state;
    reg [1:0] state_next;
    
//    wire PC_trigger_next;
    
    always@* begin
        case (state)
            `RESET: state_next = `FIFO_out_WAIT;
            `FIFO_out_WAIT: state_next = (rd_data_cnt == 6'b111111) ? `FIFO_out_READ : `FIFO_out_WAIT;
            `FIFO_out_READ: state_next = (fifo_empty) ? `FIFO_out_WAIT : `FIFO_out_READ;
            default: state_next = state;
        endcase
    end
    
//    assign PC_trigger_next = (rd_data_cnt == 6'b111111);
    assign PC_trigger = (rd_data_cnt == 6'b111111);

    
    always@(posedge clk or posedge rst) begin
        if (rst) state <= 0;
        else state <= state_next;
    end
    
//    always@(posedge clk) begin
//        PC_trigger <= PC_trigger_next;
//    end
    
endmodule
