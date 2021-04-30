///////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995/2015 Xilinx, Inc.
//  All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//   ____   ___
//  /   /\/   /
// /___/  \  /    Vendor      : Xilinx
// \   \   \/     Version     : 2015.4
//  \   \         Description : Xilinx Formal Library Component
//  /   /         
// /___/   /\     
// \   \  /  \    Filename    : DSP_PREADD.v 
//  \___\/\___\
//
///////////////////////////////////////////////////////////////////////////////
//  Revision:
//     12/17/13 - Initial Version.
//  End Revision:
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps 

`celldefine

module DSP_PREADD
  `ifdef XIL_TIMING
#(
  parameter LOC = "UNPLACED"
)
  `endif
(
  output [26:0] AD,

  input ADDSUB,
  input [26:0] D_DATA,
  input INMODE2,
  input [26:0] PREADD_AB
);
  
// define constants
  localparam MODULE_NAME = "DSP_PREADD";
  localparam in_delay    = 0;
  localparam out_delay   = 0;
  localparam inclk_delay    = 0;
  localparam outclk_delay   = 0;



  tri0 glblGSR = 1'b0;

  reg trig_attr = 1'b0;
  reg attr_err = 1'b0;
  
// include dynamic registers - XILINX test only
  `ifdef XIL_DR
  `include "DSP_PREADD_dr.v"
  `endif

  wire [26:0] AD_out;

  wire [26:0] AD_delay;

  wire ADDSUB_in;
  wire INMODE_2_in;
  wire [26:0] D_DATA_in;
  wire [26:0] PREADD_AB_in;

  wire ADDSUB_delay;
  wire INMODE_2_delay;
  wire [26:0] D_DATA_delay;
  wire [26:0] PREADD_AB_delay;
  
  wire [26:0] D_DATA_mux;

// input output assignments
  assign #(out_delay) AD = AD_delay;


// inputs with no timing checks

  assign #(in_delay) ADDSUB_delay = ADDSUB;
  assign #(in_delay) D_DATA_delay = D_DATA;
  assign #(in_delay) INMODE_2_delay = INMODE2;
  assign #(in_delay) PREADD_AB_delay = PREADD_AB;

  assign AD_delay = AD_out;

  assign ADDSUB_in = ADDSUB_delay;
  assign D_DATA_in = D_DATA_delay;
  assign INMODE_2_in = INMODE_2_delay;
  assign PREADD_AB_in = PREADD_AB_delay;


//*********************************************************
//*** Preaddsub AD
//*********************************************************
  assign D_DATA_mux = INMODE_2_in ? D_DATA_in : 27'b0;
  assign AD_out = ADDSUB_in ? (D_DATA_mux - PREADD_AB_in) : (D_DATA_mux + PREADD_AB_in);

endmodule

`endcelldefine
