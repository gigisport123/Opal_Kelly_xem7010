`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 9, 2024
// Description: read from FPGA to PC
//////////////////////////////////////////////////////////////////////////////////


module read_to_PC #(parameter N = 800, M = 300) (
    input wire rst,
    input wire read_en,
    input wire ti_clk,
    input wire [6*N-1:0] mem,
    output reg [15:0] data_out,
    output reg empty
    );
    
    reg [15:0] data_out_next;
    reg [$clog2(M)+1:0] cnt, cnt_next;
    reg [6*N-1:0] mem_buff;
    reg [6*N-1:0] mem_buff_2;
    reg empty_buff;
    
//    always@* begin
//        if (cnt == 0) empty = 1;
//        else empty = 0;
//    end
    
    always@* begin
        if (cnt == 0) empty_buff = 1;
        else empty_buff = 0;
    end
    
    always@* begin
        if (cnt == 0) cnt_next = cnt;
        else cnt_next = cnt - 1;
    end
    
    always@* begin
        data_out_next = mem_buff_2[16*cnt-1 -: 16];
    end
    
    always@(posedge ti_clk or posedge rst) begin
        if (rst) 
            cnt <= M;
        else if (read_en)
            cnt <= cnt_next;
    end
    
    always@(posedge ti_clk) begin
        data_out <= data_out_next;
    end
    
    always@(posedge ti_clk) begin
        mem_buff <= mem;
        mem_buff_2 <= mem_buff;
    end
    
    always@(posedge ti_clk) begin
        empty <= empty_buff;
    end
    
endmodule
