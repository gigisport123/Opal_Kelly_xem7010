`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 9, 2024
// Description: read from FPGA to PC
//////////////////////////////////////////////////////////////////////////////////


module read_to_PC #(parameter N = 1000) (
    input wire read_en,
    input wire ti_clk,
//    input wire clk,
    input wire [6*N-1:0] mem,
//    input wire read_trig,
    output reg [15:0] data_out,
    output reg empty
//    output reg PC_read
    );
    
    reg [15:0] data_out_next;
    reg [$clog2(N)-1:0] cnt, cnt_next;
    
    always@* begin
        if (cnt == 188) empty = 1;
        else empty = 0;
    end
    
    always@* begin
        cnt_next = cnt + 1;
    end
    
    always@* begin
        data_out_next = mem[16*cnt-1 -: 16];
    end
    
    always@(posedge ti_clk) begin
        if (read_en)
            data_out <= data_out_next;
            cnt <= cnt_next;
    end
    
endmodule
