`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 16, 2024
// Description: FIFO output to PC
//////////////////////////////////////////////////////////////////////////////////


module FIFO_to_PC (
    input wire rst,
    input wire enable,
    input wire read_en,
    input wire ti_clk,
    input wire [47:0] data_in,
    output reg [15:0] data_out,
    output reg read_fifo,
    output reg [1:0] cnt
    );
    
    reg [1:0] cnt_next;
    reg [47:0] data, data_next;
    
    always@* begin
        data_out = data_in[16*cnt-1 -: 16];
    end
    
//    always@* begin
//        data_in_next = {data_in[31:0], 16'b0};
//    end
    
    always@* begin
        if (cnt == 1) read_fifo = 1;
        else read_fifo = 0;
    end
    
    always@* begin
        if (cnt == 1) cnt_next = 3;
        else cnt_next = cnt - 1;
    end
    
    always@(posedge ti_clk or posedge rst) begin
        if (rst) cnt <= 3;
        else if (enable && read_en) cnt <= cnt_next;
        else cnt <= cnt;
    end
    
endmodule   