`timescale 0.1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/14/2024 02:41:13 PM
// Design Name: 
// Module Name: fsm_tb
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

`define RESET 2'b00
`define WRITE_to_FPGA 2'b01
`define READ_to_PC 2'b10
`define STOP 2'b11

module fsm_tb;


// Inputs
reg rst;
reg clk;
reg full;
reg empty;

// Outputs
wire write_en;
wire [1:0] state;


fsm U_fsm(
    .rst (rst),             // external from PC
    .clk (clk),             // 40MHz 2fs DUT clk
    .full (full),           // finished write_to_FPGA
    .empty (empty),         // finished read_to_PC
    .write_en (write_en),   // 1 when in write_to_FPGA state
    .state (state)          // observe state from rst, write_to_FPGA, read_to_PC, stop
    );

initial begin
    forever #125 clk = ~clk;    // 40MHz clock, period 25ns
end

/* asynchronous clock freq @ 48MHz
for simulation, use @50MHz (period = 20ns)
*/

initial begin
    rst = 0;
    clk = 1;
    full = 0;
    empty = 0;
    
    # 100
    rst = 1;
    # 100
    rst = 0;
end

initial begin   
    # (125*10) full = 1;
    # (125*2) full = 0;
    
    # (100*8) empty = 1;
    
end

endmodule
