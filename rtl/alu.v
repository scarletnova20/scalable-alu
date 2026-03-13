`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:  alu
// Description:  Parameterized N-bit Arithmetic Logic Unit.
//               Supports arithmetic (ADD, SUB) and bitwise logical (AND, OR,
//               XOR, NOT, PASS) operations. The bit-width is configurable via
//               the WIDTH parameter, enabling seamless scaling from 8-bit to
//               arbitrary-width datapaths.
//
// Parameters:   WIDTH - Bit-width of operands and result (default: 8)
//
// Ports:
//   input  [WIDTH-1:0] a, b    - Input operands
//   input  [2:0]       opcode  - Operation selection code
//   output [WIDTH-1:0] result  - Computation result
//   output             zero    - Zero flag (asserted when result == 0)
//////////////////////////////////////////////////////////////////////////////////

module alu #(
    parameter WIDTH = 8
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    input  [2:0]       opcode,
    output reg [WIDTH-1:0] result,
    output             zero
);

    // --- Opcode Definitions ---
    localparam OP_ADD    = 3'b000;  // Addition
    localparam OP_SUB    = 3'b001;  // Subtraction
    localparam OP_AND    = 3'b010;  // Bitwise AND
    localparam OP_OR     = 3'b011;  // Bitwise OR
    localparam OP_XOR    = 3'b100;  // Bitwise XOR
    localparam OP_NOT_A  = 3'b101;  // Bitwise NOT of operand A
    localparam OP_PASS_B = 3'b110;  // Pass operand B to output

    // --- Combinational ALU Logic ---
    always @(*) begin
        case (opcode)
            OP_ADD:    result = a + b;
            OP_SUB:    result = a - b;
            OP_AND:    result = a & b;
            OP_OR:     result = a | b;
            OP_XOR:    result = a ^ b;
            OP_NOT_A:  result = ~a;
            OP_PASS_B: result = b;
            default:   result = {WIDTH{1'b0}};
        endcase
    end

    // --- Zero Flag ---
    assign zero = (result == {WIDTH{1'b0}});

endmodule
