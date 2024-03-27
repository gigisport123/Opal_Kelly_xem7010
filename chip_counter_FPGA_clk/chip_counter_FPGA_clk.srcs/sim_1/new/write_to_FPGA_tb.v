`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2024 03:22:49 PM
// Design Name: 
// Module Name: write_to_FPGA_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module write_to_FPGA_tb;

parameter N = 8;

// Inputs
reg write_en;
reg [5:0] data;
reg clk;

// Outputs
wire [6*N-1:0] mem;
wire full;
//wire [6*N-1:0] mem_next;
//wire [6*N-1:0] mem_next_2;
//wire [$clog2(N)-1:0] cnt_next;
//wire [$clog2(N)-1:0] cnt;

write_to_FPGA #(.N(N)) U_write (
    .write_en (write_en),
    .data (data),
    .clk (clk),
    .mem (mem),
    .full (full)
//    .mem_next (mem_next),             // these four lines below for observing debug waveform
//    .mem_next_2 (mem_next_2),
//    .cnt_next (cnt_next),
//    .cnt (cnt)
    );
    
initial begin
    forever #125 clk = ~clk;    // 40MHz clock, period 25ns
end

/* asynchronous clock freq @ 48MHz
for simulation, use @50MHz (period = 20ns)
*/

initial begin
    write_en = 0;
    clk = 1;
    data = 6'b000111;
    
    # (125*10)
    write_en = 1;
end
    

endmodule
