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
// \   \  /  \    Filename    : DSP_A_B_DATA.v 
//  \___\/\___\
//
///////////////////////////////////////////////////////////////////////////////
//  Revision:
//     12/18/13 - Initial Version. 
//  End Revision:
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps 

`celldefine

module DSP_A_B_DATA
#(
  `ifdef XIL_TIMING
  parameter LOC = "UNPLACED",  
  `endif
  parameter integer ACASCREG = 1,
  parameter integer AREG = 1,
  parameter A_INPUT = "DIRECT",
  parameter integer BCASCREG = 1,
  parameter integer BREG = 1,
  parameter B_INPUT = "DIRECT",
  parameter [0:0] IS_CLK_INVERTED = 1'b0,
  parameter [0:0] IS_RSTA_INVERTED = 1'b0,
  parameter [0:0] IS_RSTB_INVERTED = 1'b0
) (
  output [26:0] A1_DATA,
  output [26:0] A2_DATA,
  output [29:0] ACOUT,
  output [29:0] A_ALU,
  output [17:0] B1_DATA,
  output [17:0] B2_DATA,
  output [17:0] BCOUT,
  output [17:0] B_ALU,

  input [29:0] A,
  input [29:0] ACIN,
  input [17:0] B,
  input [17:0] BCIN,
  input CEA1,
  input CEA2,
  input CEB1,
  input CEB2,
  input CLK,
  input RSTA,
  input RSTB
);
  
// define constants
  localparam MODULE_NAME = "DSP_A_B_DATA";
  localparam in_delay    = 0;
  localparam out_delay   = 0;
  localparam inclk_delay    = 0;
  localparam outclk_delay   = 0;

// Parameter encodings and registers
// logic depends on ACASCREG, AREG encoding the same
  localparam ACASCREG_0 = 1;
  localparam ACASCREG_1 = 0;
  localparam ACASCREG_2 = 2;
  localparam AREG_0 = 1;
  localparam AREG_1 = 0;
  localparam AREG_2 = 2;
  localparam A_INPUT_CASCADE = 1;
  localparam A_INPUT_DIRECT = 0;
  localparam BCASCREG_0 = 1;
  localparam BCASCREG_1 = 0;
  localparam BCASCREG_2 = 2;
  localparam BREG_0 = 1;
  localparam BREG_1 = 0;
  localparam BREG_2 = 2;
  localparam B_INPUT_CASCADE = 1;
  localparam B_INPUT_DIRECT  = 0;

  `ifndef XIL_DR
  localparam [1:0] ACASCREG_REG = ACASCREG;
  localparam [1:0] AREG_REG = AREG;
  localparam [56:1] A_INPUT_REG = A_INPUT;
  localparam [1:0] BCASCREG_REG = BCASCREG;
  localparam [1:0] BREG_REG = BREG;
  localparam [56:1] B_INPUT_REG = B_INPUT;
  localparam [0:0] IS_CLK_INVERTED_REG = IS_CLK_INVERTED;
  localparam [0:0] IS_RSTA_INVERTED_REG = IS_RSTA_INVERTED;
  localparam [0:0] IS_RSTB_INVERTED_REG = IS_RSTB_INVERTED;
  `endif
  wire [1:0] ACASCREG_BIN;
  wire [1:0] AREG_BIN;
  wire A_INPUT_BIN;
  wire [1:0] BCASCREG_BIN;
  wire [1:0] BREG_BIN;
  wire B_INPUT_BIN;
  wire IS_CLK_INVERTED_BIN;
  wire IS_RSTA_INVERTED_BIN;
  wire IS_RSTB_INVERTED_BIN;

  tri0 glblGSR = 1'b0;

  `ifdef XIL_TIMING
  reg notifier;
  `endif

  reg trig_attr = 1'b0;
  reg attr_err = 1'b0;
  
// include dynamic registers - XILINX test only
  `ifdef XIL_DR
  `include "DSP_A_B_DATA_dr.v"
  `endif

  wire [17:0] B1_DATA_out;
  wire [17:0] B2_DATA_out;
  wire [17:0] BCOUT_out;
  wire [17:0] B_ALU_out;
  wire [26:0] A1_DATA_out;
  wire [26:0] A2_DATA_out;
  wire [29:0] ACOUT_out;
  wire [29:0] A_ALU_out;

  wire [17:0] B1_DATA_delay;
  wire [17:0] B2_DATA_delay;
  wire [17:0] BCOUT_delay;
  wire [17:0] B_ALU_delay;
  wire [26:0] A1_DATA_delay;
  wire [26:0] A2_DATA_delay;
  wire [29:0] ACOUT_delay;
  wire [29:0] A_ALU_delay;

  wire CEA1_in;
  wire CEA2_in;
  wire CEB1_in;
  wire CEB2_in;
  wire CLK_in;
  wire RSTA_in;
  wire RSTB_in;
  wire [17:0] BCIN_in;
  wire [17:0] B_in;
  wire [29:0] ACIN_in;
  wire [29:0] A_in;

  wire CEA1_delay;
  wire CEA2_delay;
  wire CEB1_delay;
  wire CEB2_delay;
  wire CLK_delay;
  wire RSTA_delay;
  wire RSTB_delay;
  wire [17:0] BCIN_delay;
  wire [17:0] B_delay;
  wire [29:0] ACIN_delay;
  wire [29:0] A_delay;
  
  wire [29:0] A_ACIN_mux;
  wire [29:0] A1_reg_mux;
  wire [29:0] A2_reg_mux;
  reg [29:0] A1_reg = 30'b0;
  reg [29:0] A2_reg = 30'b0;
  wire [17:0] B_BCIN_mux;
  wire [17:0] B1_reg_mux;
  wire [17:0] B2_reg_mux;
  reg [17:0] B1_reg = 18'b0;
  reg [17:0] B2_reg = 18'b0;
  wire CLK_areg1;
  wire CLK_areg2;
  wire CLK_breg1;
  wire CLK_breg2;

// input output assignments
  assign #(out_delay) A1_DATA = A1_DATA_delay;
  assign #(out_delay) A2_DATA = A2_DATA_delay;
  assign #(out_delay) ACOUT = ACOUT_delay;
  assign #(out_delay) A_ALU = A_ALU_delay;
  assign #(out_delay) B1_DATA = B1_DATA_delay;
  assign #(out_delay) B2_DATA = B2_DATA_delay;
  assign #(out_delay) BCOUT = BCOUT_delay;
  assign #(out_delay) B_ALU = B_ALU_delay;


  assign #(inclk_delay) CLK_delay = CLK;

  assign #(in_delay) ACIN_delay = ACIN;
  assign #(in_delay) A_delay = A;
  assign #(in_delay) BCIN_delay = BCIN;
  assign #(in_delay) B_delay = B;
  assign #(in_delay) CEA1_delay = CEA1;
  assign #(in_delay) CEA2_delay = CEA2;
  assign #(in_delay) CEB1_delay = CEB1;
  assign #(in_delay) CEB2_delay = CEB2;
  assign #(in_delay) RSTA_delay = RSTA;
  assign #(in_delay) RSTB_delay = RSTB;



  assign A1_DATA_delay = A1_DATA_out;
  assign A2_DATA_delay = A2_DATA_out;
  assign ACOUT_delay = ACOUT_out;
  assign A_ALU_delay = A_ALU_out;
  assign B1_DATA_delay = B1_DATA_out;
  assign B2_DATA_delay = B2_DATA_out;
  assign BCOUT_delay = BCOUT_out;
  assign B_ALU_delay = B_ALU_out;

  assign ACIN_in = ACIN_delay;
  assign A_in = A_delay;
  assign BCIN_in = BCIN_delay;
  assign B_in = B_delay;
  assign CEA1_in = CEA1_delay;
  assign CEA2_in = CEA2_delay;
  assign CEB1_in = CEB1_delay;
  assign CEB2_in = CEB2_delay;
  assign CLK_areg1  = (AREG_BIN == AREG_0)           ? 1'b0 : CLK_delay ^ IS_CLK_INVERTED_BIN;
  assign CLK_areg2  = (AREG_BIN == AREG_0)           ? 1'b0 : CLK_delay ^ IS_CLK_INVERTED_BIN;
  assign CLK_breg1  = (BREG_BIN == BREG_0)           ? 1'b0 : CLK_delay ^ IS_CLK_INVERTED_BIN;
  assign CLK_breg2  = (BREG_BIN == BREG_0)           ? 1'b0 : CLK_delay ^ IS_CLK_INVERTED_BIN;
  assign RSTA_in = RSTA_delay ^ IS_RSTA_INVERTED_BIN;
  assign RSTB_in = RSTB_delay ^ IS_RSTB_INVERTED_BIN;

  initial begin
  `ifndef XIL_TIMING
  $display("ERROR: SIMPRIM primitive %s instance %m is not intended for direct instantiation in RTL or functional netlists. This primitive is only available in the SIMPRIM library for implemented netlists, please ensure you are pointing to the SIMPRIM library.", MODULE_NAME);
  `endif
//  $finish;
  #1;
  trig_attr = ~trig_attr;
  end

  assign ACASCREG_BIN =
    (ACASCREG_REG == 1) ? ACASCREG_1 :
    (ACASCREG_REG == 0) ? ACASCREG_0 :
    (ACASCREG_REG == 2) ? ACASCREG_2 :
     ACASCREG_1;

  assign AREG_BIN =
    (AREG_REG == 1) ? AREG_1 :
    (AREG_REG == 0) ? AREG_0 :
    (AREG_REG == 2) ? AREG_2 :
     AREG_1;

  assign A_INPUT_BIN = 
    (A_INPUT_REG == "DIRECT") ? A_INPUT_DIRECT :
    (A_INPUT_REG == "CASCADE") ? A_INPUT_CASCADE :
    A_INPUT_DIRECT;

  assign BCASCREG_BIN =
    (BCASCREG_REG == 1) ? BCASCREG_1 :
    (BCASCREG_REG == 0) ? BCASCREG_0 :
    (BCASCREG_REG == 2) ? BCASCREG_2 :
     BCASCREG_1;

  assign BREG_BIN =
    (BREG_REG == 1) ? BREG_1 :
    (BREG_REG == 0) ? BREG_0 :
    (BREG_REG == 2) ? BREG_2 :
     BREG_1;

  assign B_INPUT_BIN =
    (B_INPUT_REG == "DIRECT") ? B_INPUT_DIRECT :
    (B_INPUT_REG == "CASCADE") ? B_INPUT_CASCADE :
     B_INPUT_DIRECT;

  assign IS_CLK_INVERTED_BIN = IS_CLK_INVERTED_REG;

  assign IS_RSTA_INVERTED_BIN = IS_RSTA_INVERTED_REG;

  assign IS_RSTB_INVERTED_BIN = IS_RSTB_INVERTED_REG;


  always @ (trig_attr) begin
    #1;
//-------- A_INPUT check
    if ((A_INPUT_REG != "DIRECT") &&
        (A_INPUT_REG != "CASCADE")) begin
        $display("Attribute Syntax Error : The attribute A_INPUT on %s instance %m is set to %s.  Legal values for this attribute are DIRECT or CASCADE.", MODULE_NAME, A_INPUT_REG);
        attr_err = 1'b1;
    end

//-------- B_INPUT check
    if ((B_INPUT_REG != "DIRECT") &&
        (B_INPUT_REG != "CASCADE")) begin
        $display("Attribute Syntax Error : The attribute B_INPUT on %s instance %m is set to %s.  Legal values for this attribute are DIRECT or CASCADE.", MODULE_NAME, B_INPUT_REG);
        attr_err = 1'b1;
    end

//-------- ACASCREG check
    if ((ACASCREG_REG != 0) && (ACASCREG_REG != 1) && (ACASCREG_REG != 2))
    begin
      $display("Attribute Syntax Error : The attribute ACASCREG on %s instance %m is set to %d.  Legal values for this attribute are 0 to 2.", MODULE_NAME, ACASCREG_REG);
      attr_err = 1'b1;
    end

//-------- ACASCREG vs AREG check
    case (AREG_REG)
      0, 1 : if(AREG_REG != ACASCREG_REG) begin
        $display("Attribute Syntax Error : The attribute ACASCREG  on %s instance %m is set to %d.  ACASCREG has to be set to %d when attribute AREG = %d.", MODULE_NAME, ACASCREG_REG, AREG_REG, AREG_REG);
        attr_err = 1'b1;
        end
      2 : if(ACASCREG_REG == 0) begin
        $display("Attribute Syntax Error : The attribute ACASCREG  on %s instance %m is set to %d.  ACASCREG has to be set to either 2 or 1 when attribute AREG = %d.", MODULE_NAME, ACASCREG_REG, AREG_REG);
        attr_err = 1'b1;
        end
      default : begin
        $display("Attribute Syntax Error : The attribute AREG on %s instance %m is set to %d.  Legal values for this attribute are 0, 1 or 2.", MODULE_NAME, AREG_REG);
        attr_err = 1'b1;
        end
    endcase

//-------- BCASCREG check
    if ((BCASCREG_REG != 0) && (BCASCREG_REG != 1) && (BCASCREG_REG != 2))
    begin
      $display("Attribute Syntax Error : The attribute BCASCREG on %s instance %m is set to %d.  Legal values for this attribute are 0 to 2.", MODULE_NAME, BCASCREG_REG);
      attr_err = 1'b1;
    end

//-------- BCASCREG vs BREG check
    case (BREG_REG)
      0, 1 : if(BREG_REG != BCASCREG_REG) begin
        $display("Attribute Syntax Error : The attribute BCASCREG on %s instance %m is set to %d.  BCASCREG has to be set to %d when attribute BREG = %d.", MODULE_NAME, BCASCREG_REG, BREG_REG, BREG_REG);
        attr_err = 1'b1;
        end
      2 : if(BCASCREG_REG == 0) begin
        $display("Attribute Syntax Error : The attribute BCASCREG on %s instance %m is set to %d.  BCASCREG must be set to either 2 or 1 when attribute BREG = %d.", MODULE_NAME, BCASCREG_REG, BREG_REG);
        attr_err = 1'b1;
        end
      default : begin
        $display("Attribute Syntax Error : The attribute BREG on %s instance %m is set to %d.  Legal values for this attribute are 0, 1 or 2.", MODULE_NAME, BREG_REG);
        attr_err = 1'b1;
        end
    endcase

  if (attr_err == 1'b1) $finish;
  end

//*********************************************************
//*** Input register A with 2 level deep of registers
//*********************************************************

    assign A_ACIN_mux = (A_INPUT_BIN == A_INPUT_CASCADE) ? ACIN_in : A_in;
//    assign CLK_areg1 =  (AREG_BIN == AREG_0) ? 1'b0 : CLK_in;
//    assign CLK_areg2 =  (AREG_BIN == AREG_0) ? 1'b0 : CLK_in;

    always @(posedge CLK_areg1) begin
       if      (RSTA_in || glblGSR) A1_reg <= 30'b0;
       else if (CEA1_in) A1_reg <= A_ACIN_mux;
       end

    assign A1_reg_mux = (AREG_BIN == AREG_2) ? A1_reg : A_ACIN_mux;

    always @(posedge CLK_areg2) begin
       if      (RSTA_in || glblGSR) A2_reg <= 30'b0;
       else if (CEA2_in) A2_reg <= A1_reg_mux;
       end

    assign A2_reg_mux = (AREG_BIN == AREG_0) ? A1_reg_mux : A2_reg;

// assumes encoding the same for ACASCREG and AREG
    assign ACOUT_out = (ACASCREG_BIN == AREG_BIN) ? A2_reg_mux : A1_reg;
    assign A1_DATA_out = A1_reg[26:0];
    assign A2_DATA_out = A2_reg_mux[26:0];
    assign A_ALU_out = A2_reg_mux;


//*********************************************************
//*** Input register B with 2 level deep of registers
//*********************************************************

    assign B_BCIN_mux = (B_INPUT_BIN == B_INPUT_CASCADE) ? BCIN_in : B_in;
//    assign CLK_breg1 =  (BREG_BIN == BREG_0) ? 1'b0 : CLK_in;
//    assign CLK_breg2 =  (BREG_BIN == BREG_0) ? 1'b0 : CLK_in;

    always @(posedge CLK_breg1) begin
       if      (RSTB_in || glblGSR) B1_reg <= 18'b0;
       else if (CEB1_in) B1_reg <= B_BCIN_mux;
       end

    assign B1_reg_mux = (BREG_BIN == BREG_2) ? B1_reg : B_BCIN_mux;

    always @(posedge CLK_breg2) begin
       if      (RSTB_in || glblGSR) B2_reg <= 18'b0;
       else if (CEB2_in) B2_reg <= B1_reg_mux;
       end

    assign B2_reg_mux = (BREG_BIN == BREG_0) ? B1_reg_mux : B2_reg;

// assumes encoding the same for BCASCREG and BREG
    assign BCOUT_out = (BCASCREG_BIN == BREG_BIN) ? B2_reg_mux : B1_reg;
    assign B1_DATA_out = B1_reg;
    assign B2_DATA_out = B2_reg_mux;
    assign B_ALU_out = B2_reg_mux;

endmodule

`endcelldefine
