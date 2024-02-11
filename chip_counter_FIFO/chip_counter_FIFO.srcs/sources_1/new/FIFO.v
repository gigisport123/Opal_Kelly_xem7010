`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 7, 2024
// Description: FIFO interface to take care of counter <--> FPGA <--> PC interface
//////////////////////////////////////////////////////////////////////////////////


module FIFO #(parameter DEPTH = 16, DATA_WIDTH = 6) (
    input wire clk, rst_n,
    input wire w_en, r_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output wire full, empty
    );
    
    reg [$clog2(DEPTH)-1:0] w_ptr, r_ptr;
    reg [DEPTH-1:0] fifo[DEPTH];
    
    // reset FIFO
    always@(posedge clk) begin
        if (!rst_n) begin
            w_ptr <= 0;
            r_ptr <= 0;
            data_out <= 0;
        end 
    end
    
    // To write data to FIFO
    always@(posedge clk) begin
        if(w_en && !full) begin
            fifo[w_ptr] <= data_in;
            w_ptr <= w_ptr + 1;
        end
        else begin
            fifo[w_ptr] <= fifo[w_ptr];
            w_ptr <= w_ptr;
        end
    end
    
    // To read from FIFO
    always@(posedge clk) begin
        if (r_en && !empty) begin
            data_out <= fifo[r_ptr];
            r_ptr <= r_ptr + 1;
        end
        else begin
            data_out <= data_out;
            r_ptr <= r_ptr;
        end
    end
    
    assign full = ((w_ptr+1'b1) == r_ptr);
    assign empty = (w_ptr == r_ptr);

endmodule
