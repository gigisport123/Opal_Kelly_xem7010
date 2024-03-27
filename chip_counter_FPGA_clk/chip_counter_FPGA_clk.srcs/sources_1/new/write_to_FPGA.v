`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 9, 2024
// Description: write from DUT to FPGA
//////////////////////////////////////////////////////////////////////////////////


module write_to_FPGA #(parameter N = 800) (
    input wire write_en,
    input wire [5:0] data,
    input wire clk,
    output reg [6*N-1:0] mem,
    output reg full         // stay high write to FPGA finish, until it goes to next state
//    output reg [6*N-1:0] mem_next,
//    output reg [6*N-1:0] mem_next_2,
//    output reg [$clog2(N)+1:0] cnt_next,
//    output reg [$clog2(N)+1:0] cnt
    );

    reg [6*N-1:0] mem_next;
    reg [6*N-1:0] mem_next_2;
    reg [$clog2(N)+1:0] cnt_next;       // add 1 bit for memory buffer
    reg [$clog2(N)+1:0] cnt;
    
    always@* begin
        mem_next_2 = {mem_next[6*(N-1)-1:0], data};
//        mem_next_2 = {mem_next << 6, data};
    end 
    
    always@* begin
        if (cnt == N+2) cnt_next = cnt;
        else cnt_next = cnt + 1;
    end
    
    always@* begin
        if (cnt == N+2) full = 1;
        else full = 0;
    end
    
    always@(posedge clk) begin
        if (!write_en) cnt <= 0;
        else cnt <= cnt_next;
    end  
    
    always@(posedge clk) begin
        if (!write_en) begin
            mem <= 0;
            mem_next <= 0;
        end
        else begin
            mem <= mem_next;
            mem_next <= mem_next_2;
        end     
    end

endmodule
