`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/16/2024 10:56:54 AM
// Design Name: 
// Module Name: DUT_to_FIFO_tb
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


module DUT_to_FIFO_tb();

    reg write_en;
    reg [5:0] data;
    reg clk;
    wire [47:0] dout;
    wire data_ready;
    wire [2:0] cnt;
    
DUT_to_FIFO U_DUT_to_FIFO (
    .write_en (write_en),
    .data (data),
    .clk (clk),
    .dout (dout),
    .data_ready (data_ready),
    .cnt (cnt)
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
    
    #250 data = 6'b000110;
    #250 data = 6'b000110;
    #250 data = 6'b000110;
    #250 data = 6'b000110;
    #250 data = 6'b000110;
    #250 data = 6'b000110;
    #250 data = 6'b000111;
    #250 data = 6'b000111;
end   
    

endmodule
