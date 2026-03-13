`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:  alu_16bit
// Description:  16-bit ALU wrapper. Instantiates the parameterized alu module
//               with WIDTH = 16 for use in 16-bit datapaths.
//////////////////////////////////////////////////////////////////////////////////

module alu_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input  [2:0]  opcode,
    output [15:0] result,
    output        zero
);

    alu #(.WIDTH(16)) u_alu (
        .a      (a),
        .b      (b),
        .opcode (opcode),
        .result (result),
        .zero   (zero)
    );

endmodule
