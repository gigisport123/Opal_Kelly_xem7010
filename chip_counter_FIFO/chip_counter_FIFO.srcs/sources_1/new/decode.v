`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Jan. 25, 2024
// Description: decode the counter output
//////////////////////////////////////////////////////////////////////////////////


module decode #(parameter DEPTH = 16, DATA_WIDTH = 6, N = 800, M = 300) (
    input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,

    input wire [5:0] counter_in,    // input from DUT counter
    input wire clk_in,              // input fs clock from function generator 
    
    // clock debug clk_2fs
    output wire clk_2fs,
    output wire clk_fs,
    
	output wire        hi_muxsel,  
	output wire [7:0] led
    );

    // Opal Kelly Module Interface Connections
    wire        ti_clk;
    wire [30:0] ok1;
    wire [16:0] ok2;
    
    wire clk_reset;
    wire clk_locked;
//    wire clk_fs;
//    wire clk_2fs;
    wire rst;
    wire [1:0] state;
    
    okHost okHI(
	.hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
	.ok1(ok1), .ok2(ok2));
    
//    assign led = state;

    assign hi_muxsel    = 1'b0;
    
    reg [5:0] counter_buff;
    
    always@(posedge clk_2fs) begin
        counter_buff <= counter_in;
    end
  
    clk_wiz_0 CLK (
    // Clock in ports
      // Clock out ports
      .clk_fs (clk_fs),
      .clk_2fs (clk_2fs),
      // Status and control signals
      .reset(rst),
      .locked(clk_locked),
      .clk_in1 (clk_in)
     );
     
    wire write_en;
    wire [6*N-1:0] mem;
    wire full;
    wire empty;
//    wire read_en;
//    wire write_en;
//    wire read_trig;
    wire [15:0] data_out;
//    wire PC_read;
    wire [$clog2(N)-1:0] cnt_write;
  
    wire pipeO_read;
    
    assign led = state;
    
    fsm U_fsm(
    .rst (rst),
    .clk (clk_2fs),
    .full (full),
    .empty (empty),
//    .read_en (read_en),
    .write_en (write_en),
    .state (state)
    );
    
    write_to_FPGA #(.N(N))U_write(
    .write_en (write_en),
    .data (counter_buff) ,
    .clk (clk_2fs),
    .mem (mem),
    .full (full),
    .cnt (cnt_write)
    );   
    
    read_to_PC #(.N(N), .M(M)) U_read(
    .rst (rst),
    .read_en (pipeO_read),
    .ti_clk(ti_clk),
//    .clk (clk_2fs),
    .mem (mem),
//    .read_trig (read_trig),
    .data_out (data_out),
    .empty (empty)
//    .PC_read (PC_read)
    );  
    
        
    // Endpoint Connections
//    wire [31:0] ep20wire;
//    wire [31:0] ep21wire;
//    wire [31:0] ep40wire;
    wire [31:0] TrigOut60;
    wire [31:0] WireIn10;
    

    wire [15:0] pipeO_data;
    
    wire [17*2-1:0] ok2x;
    
    okWireOR # (.N(2)) wireOR (.ok2(ok2), .ok2s(ok2x));
    
//    assign ep20wire = data_out;
    assign rst = WireIn10[0];
//    assign read_trig = ep40wire[1];
//    assign ep21wire = PC_read;
    assign pipeO_data = data_out;
    assign TrigOut60[0] = full;
    
    okWireIn ep10 (.ok1(ok1),    .ep_addr(8'h10), .ep_dataout(WireIn10));
    okTriggerOut ep60 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(ti_clk), .ep_trigger(TrigOut60));
//    okWireOut ep20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(ep20wire));
//    okWireOut ep21 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h21), .ep_datain(ep21wire));   
    okPipeOut epA0 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(pipeO_read), .ep_datain(pipeO_data));
    
    
endmodule
