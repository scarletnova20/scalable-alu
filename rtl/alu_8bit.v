`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:  alu_8bit
// Description:  8-bit ALU wrapper. Instantiates the parameterized alu module
//               with WIDTH = 8 for use in 8-bit datapaths.
//////////////////////////////////////////////////////////////////////////////////

module alu_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input  [2:0] opcode,
    output [7:0] result,
    output       zero
);

    alu #(.WIDTH(8)) u_alu (
        .a      (a),
        .b      (b),
        .opcode (opcode),
        .result (result),
        .zero   (zero)
    );

endmodule
