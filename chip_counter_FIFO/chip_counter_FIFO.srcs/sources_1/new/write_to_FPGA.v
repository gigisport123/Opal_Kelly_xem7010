`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 9, 2024
// Description: write from DUT to FPGA
//////////////////////////////////////////////////////////////////////////////////


module write_to_FPGA #(parameter N = 1000) (
    input wire write_en,
    input wire [5:0] data,
    input wire clk,
    output reg [6*N-1:0] mem,
    output reg full,
    output reg [$clog2(N)-1:0] cnt
    );
    
    reg [6*N-1:0] mem_next;
    reg [$clog2(N)-1:0] cnt_next;
    
    always@* begin
        mem_next = {mem[6*(N-1)-1:0], data};
    end 
    
    always@* begin
        cnt_next = cnt + 1;
    end
    
    always@* begin
        if (cnt == N-1) full = 1;
        else full = 0;
    end
    
    always@(posedge clk) begin
        if (!write_en) cnt <= 0;
        else cnt <= cnt_next;
    end  
    
    always@(posedge clk) begin
        if (!write_en) mem <= 0;
        else mem <= mem_next;
    end

endmodule
