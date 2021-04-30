///////////////////////////////////////////////////////////////////////////////
//  Copyright (c) 1995/2015 Xilinx, Inc.
//  All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//
//   ____   ___
//  /   /\/   / 
// /___/  \  /     Vendor      : Xilinx 
// \   \   \/      Version     : 2015.4
//  \   \          Description : Xilinx Formal Library Component
//  /   /                        
// /___/   /\      Filename    : IBUFE3.v
// \   \  /  \ 
//  \___\/\___\                    
//                                 
///////////////////////////////////////////////////////////////////////////////
//  Revision:
//     01/16/14 - Initial Version.
//     10/20/14 - Removed b'x support (CR 817718).
//  End Revision
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps 

`celldefine

module IBUFE3 #(
  `ifdef XIL_TIMING //Simprim 
  parameter LOC = "UNPLACED",  
  `endif
  parameter IBUF_LOW_PWR = "TRUE",
  parameter IOSTANDARD = "DEFAULT",
  parameter USE_IBUFDISABLE = "FALSE",
  parameter integer SIM_INPUT_BUFFER_OFFSET = 0
)(
  output O,

  input I,
  input IBUFDISABLE,
  input [3:0] OSC,
  input OSC_EN,
  input VREF
);
  
// define constants
  localparam MODULE_NAME = "IBUFE3";
  localparam in_delay    = 0;
  localparam out_delay   = 0;
  localparam inclk_delay    = 0;
  localparam outclk_delay   = 0;

// Parameter encodings and registers
  localparam IBUF_LOW_PWR_FALSE = 1;
  localparam IBUF_LOW_PWR_TRUE = 0;

//  `ifndef XIL_DR
  localparam [40:1] IBUF_LOW_PWR_REG = IBUF_LOW_PWR;
  localparam integer SIM_INPUT_BUFFER_OFFSET_REG = SIM_INPUT_BUFFER_OFFSET;
 // `endif

  wire IBUF_LOW_PWR_BIN;
  wire [5:0] SIM_INPUT_BUFFER_OFFSET_BIN;

  tri0 glblGSR = 1'b0;

  wire O_out;
  reg O_OSC_in;

  wire O_delay;

  wire I_in;
  wire OSC_EN_in;
  wire VREF_in;
  wire [3:0] OSC_in;

  wire I_delay;
  wire OSC_EN_delay;
  wire VREF_delay;
  wire [3:0] OSC_delay;

  
  assign #(out_delay) O = O_delay;
  

// inputs with no timing checks

  assign #(in_delay) I_delay = I;
  assign #(in_delay) OSC_EN_delay = OSC_EN;
  assign #(in_delay) OSC_delay = OSC;
  assign #(in_delay) VREF_delay = VREF;

  assign O_delay = O_out;

  assign I_in = I_delay;
  assign OSC_EN_in = OSC_EN_delay;
  assign OSC_in = OSC_delay;
  assign VREF_in = VREF_delay;

  integer OSC_int = 0;
  
  assign O_out = (OSC_EN_in) ? O_OSC_in : I_in;
  
  always @ (OSC_in or OSC_EN_in) begin
      OSC_int = OSC_in[2:0] * 5;
  if (OSC_in[3] == 1'b0 )
      OSC_int =  -1*OSC_int;
  
   if(OSC_EN_in == 1'b1) begin
    if ((SIM_INPUT_BUFFER_OFFSET_REG + OSC_int) < 0)
        O_OSC_in <= 1'b0;
    else if ((SIM_INPUT_BUFFER_OFFSET_REG + OSC_int) > 0)  
        O_OSC_in <= 1'b1;
    else if ((SIM_INPUT_BUFFER_OFFSET_REG + OSC_int) == 0)
        O_OSC_in <= ~O_OSC_in;
   end
  end
  
  initial begin
    if ((SIM_INPUT_BUFFER_OFFSET_REG + OSC_int)< 0)
        O_OSC_in <= 1'b0;
    else if ((SIM_INPUT_BUFFER_OFFSET_REG + OSC_int) > 0)  
        O_OSC_in <= 1'b1;
    else if ((SIM_INPUT_BUFFER_OFFSET_REG + OSC_int) == 0)
        O_OSC_in <= 1'b0;

  end 

  assign IBUF_LOW_PWR_BIN =
    (IBUF_LOW_PWR_REG == "FALSE") ? IBUF_LOW_PWR_FALSE :
    (IBUF_LOW_PWR_REG == "TRUE")  ? IBUF_LOW_PWR_TRUE  :
    IBUF_LOW_PWR_TRUE;


  assign SIM_INPUT_BUFFER_OFFSET_BIN = SIM_INPUT_BUFFER_OFFSET_REG;

  
endmodule

`endcelldefine
