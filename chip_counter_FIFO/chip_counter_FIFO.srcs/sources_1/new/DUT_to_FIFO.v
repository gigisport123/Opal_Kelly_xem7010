`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 16, 2024
// Description: write from DUT to FIFO
//////////////////////////////////////////////////////////////////////////////////

module DUT_to_FIFO(
    input wire write_en,
    input wire [5:0] data,
    input wire clk,
    output reg [47:0] dout,
    output reg data_ready,
    output reg [2:0] cnt
    );
    
    reg [2:0] cnt_next;
    reg [47:0] dout_next; 
    
    always@* begin
        dout_next = {dout[41:0], data};
    end
    
    always@* begin
        cnt_next = cnt + 1;
    end
    
    always@* begin
        if (cnt == 3'd0 && write_en) data_ready = 1;
        else data_ready = 0;
    end
    
    always@(posedge clk) begin
        if (!write_en) begin
            dout <= 0;
            cnt <= 0;
        end
        else begin
            dout <= dout_next;
            cnt <= cnt_next;
        end
    end
    
endmodule
