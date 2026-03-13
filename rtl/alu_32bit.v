`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:  alu_32bit
// Description:  32-bit ALU wrapper. Instantiates the parameterized alu module
//               with WIDTH = 32 for use in 32-bit datapaths.
//////////////////////////////////////////////////////////////////////////////////

module alu_32bit (
    input  [31:0] a,
    input  [31:0] b,
    input  [2:0]  opcode,
    output [31:0] result,
    output        zero
);

    alu #(.WIDTH(32)) u_alu (
        .a      (a),
        .b      (b),
        .opcode (opcode),
        .result (result),
        .zero   (zero)
    );

endmodule
