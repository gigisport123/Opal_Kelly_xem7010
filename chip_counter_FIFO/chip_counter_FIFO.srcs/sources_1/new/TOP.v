`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Name: Yu-Chi Lin
// Date: Feb. 17, 2024
// Description: top level with Opal Kelly End Point Connections
//////////////////////////////////////////////////////////////////////////////////

module TOP(
    input wire [5:0] DUT_data_in,       // input counter bits
    
    // end point connections
    input  wire [7:0]  hi_in,
	output wire [1:0]  hi_out,
	inout  wire [15:0] hi_inout,
	inout  wire        hi_aa,
	output wire        hi_muxsel,  
//	output wire [7:0] led,
	
	// system clock 200MHz LVDS
	input wire sys_clk_p,
	input wire sys_clk_n,
	
	// dubeg generated clock
	output wire clk_fs,
	output wire clk_2fs
    );
   
    wire rst;                    // PC generated 
    wire PC_read_en;             // end point pipeout read enable flag
    wire [15:0] pipe_data_out;   // end point pipeout data
    wire [1:0] state;            // global fsm; connect to LED for debugging
//    wire fifo_full;             // trigger the PC pipeout
    
    wire sys_clk;               // 200MHz sys clock
//    wire clk_fs;                // fs; gnerated from clk wizard
//    wire clk_2fs;               // 2fs; generated from clk wizard
    wire clk_locked;            // unused clk wizard flag

    
    // Opal Kelly Module Interface Connections
    wire        ti_clk;
    wire [30:0] ok1;
    wire [16:0] ok2;
    
    // endpoint connections
    wire [15:0] TrigOut60;
    wire [15:0] WireIn10;
    
    wire [17*2-1:0] ok2x;
    wire PC_trigger;

    // FIFO top 
    FIFO_top U_FIFO_top(
        .rst (rst),
        .clk_2fs (clk_2fs),
        .ti_clk (ti_clk),
        .DUT_data_in (DUT_data_in),
        .PC_read_en (PC_read_en),
        .pipe_data_out (pipe_data_out),
//        .state (state),
//        .fifo_full (fifo_full)        // trigger signal for fifo full
        .PC_trigger (PC_trigger)
    );

    // clk management
    // clk buffer
    IBUFGDS osc_clk(.O(sys_clk), .I(sys_clk_p), .IB(sys_clk_n));
    
    clk_wiz_0 CLK (
        // Clock out ports
        .clk_fs (clk_fs),
        .clk_2fs (clk_2fs),
        // Status and control signals
        .reset(rst),
        .locked(clk_locked),
        // Clock in ports
        .clk_in1 (sys_clk)
     );
    
    // OkHost Interface
    okHost okHI(
	.hi_in(hi_in), .hi_out(hi_out), .hi_inout(hi_inout), .hi_aa(hi_aa), .ti_clk(ti_clk),
	.ok1(ok1), .ok2(ok2));
    
    okWireOR # (.N(2)) wireOR (.ok2(ok2), .ok2s(ok2x));
    
    assign rst = WireIn10[0];
    assign TrigOut60[0] = PC_trigger;
    
//    wire [31:0] pipe_out_32bit;
    
//    assign pipe_out_32bit = {16'b0, pipe_data_out};
    
    // PC send reset signal
    okWireIn ep10 (.ok1(ok1),    .ep_addr(8'h10), .ep_dataout(WireIn10));
    
    // full flag -- to trigger the PC pipeout
    okTriggerOut ep60 (.ok1(ok1), .ok2(ok2x[ 0*17 +: 17 ]), .ep_addr(8'h60), .ep_clk(ti_clk), .ep_trigger(TrigOut60));
    
    // PC pipeout data
    okPipeOut epA0 (.ok1(ok1), .ok2(ok2x[ 1*17 +: 17 ]), .ep_addr(8'ha0), .ep_read(PC_read_en), .ep_datain(pipe_data_out));

//    assign led = state;

endmodule
