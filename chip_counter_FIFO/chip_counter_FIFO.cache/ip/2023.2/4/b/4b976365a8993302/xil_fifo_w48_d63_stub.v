// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
// Date        : Sat Feb 17 15:37:59 2024
// Host        : pisterlabNIH running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ xil_fifo_w48_d63_stub.v
// Design      : xil_fifo_w48_d63
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a50tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_9,Vivado 2023.2" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  empty, rd_data_count, wr_data_count, wr_rst_busy, rd_rst_busy)
/* synthesis syn_black_box black_box_pad_pin="rst,din[47:0],wr_en,rd_en,dout[47:0],full,empty,rd_data_count[5:0],wr_data_count[5:0],wr_rst_busy,rd_rst_busy" */
/* synthesis syn_force_seq_prim="wr_clk" */
/* synthesis syn_force_seq_prim="rd_clk" */;
  input rst;
  input wr_clk /* synthesis syn_isclock = 1 */;
  input rd_clk /* synthesis syn_isclock = 1 */;
  input [47:0]din;
  input wr_en;
  input rd_en;
  output [47:0]dout;
  output full;
  output empty;
  output [5:0]rd_data_count;
  output [5:0]wr_data_count;
  output wr_rst_busy;
  output rd_rst_busy;
endmodule
