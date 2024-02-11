`timescale 0.1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Jan. 25, 2024
// Description: decode the counter output
//////////////////////////////////////////////////////////////////////////////////


module decode(
    input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,
    input wire [5:0] counter_in,    // input from DUT counter
    input wire clk_sample,
//    input clk_sample,
    output wire clk_double,
    output wire clk_32MHz_check,
    output reg [5:0] counter_P,
    output reg [5:0] counter_N, 	
	output wire        hi_muxsel,  
	output wire [7:0] led
//	input wire sys_clk_p,
//    output reg test
    );

    // Opal Kelly Module Interface Connections
    wire        ti_clk;
    wire [30:0] ok1;
    wire [16:0] ok2;

    reg [5:0] counter_buff;
    
    reg clk_sample_next;
    reg test_next;
    reg [3:0] cnt_tst;
    reg [3:0] cnt_tst_next;
    
    // Endpoint Connections
    wire [31:0] ep20wire;
    wire [31:0] ep21wire;
    wire [31:0] ep22wire;
    
    okHost okHI(
	.hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
	.ok1(ok1), .ok2(ok2));
    
    assign led = 8'b00011100;

    assign hi_muxsel    = 1'b0;
    
//    always@* begin
//        clk_sample_next = ~clk_sample;
//    end
    
//    always@(posedge clk_double) begin
//        clk_sample <= clk_sample_next;
//    end


//    always@* begin
//        if (cnt_tst == 4'b10) begin
//            cnt_tst_next = 4'b0;
//            test_next = ~test;
//        end
//        else begin
//            cnt_tst_next = cnt_tst + 4'b1;
//            test_next = test;
//        end
//    end
    
//    always@(posedge sys_clk_p) begin
//        test <= test_next;
//        cnt_tst <= cnt_tst_next;
//    end
    
//    always@*
//        clk_sample = 1'b1;
    
    always@(posedge clk_double) begin
        counter_buff <= counter_in;
    end
    
    always@(posedge clk_sample) begin
        counter_N <= counter_buff;
    end
    
    always@(negedge clk_sample) begin
        counter_P <= counter_buff;
    end
    
    wire [17*3-1:0] ok2x;
    
    okWireOR # (.N(3)) wireOR (.ok2(ok2), .ok2s(ok2x));
    
    assign ep20wire = counter_in;
    assign ep21wire = counter_P;
    assign ep22wire = counter_N;
    
    okWireOut ep20 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h20), .ep_datain(ep20wire));
    okWireOut ep21 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'h21), .ep_datain(ep21wire));
    okWireOut ep22 (.ok1(ok1), .ok2(ok2x[ 2*17 +: 17 ]), .ep_addr(8'h22), .ep_datain(ep22wire));

    wire clk_reset;
    wire clk_locked;
    
    assign clk_reset = 1'b0;
    
    
    clk_wiz_0 CLK (
    // Clock in ports
      // Clock out ports
      .clk_32M (clk_32MHz_check),
      .clk_64M (clk_double),
      // Status and control signals
      .reset(clk_reset),
      .locked(clk_locked),
      .clk_in1 (clk_sample)
     );
    
endmodule
