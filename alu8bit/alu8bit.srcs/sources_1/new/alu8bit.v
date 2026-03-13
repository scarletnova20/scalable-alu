`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 20:04:54
// Design Name: 
// Module Name: alu8bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module alu8bit(
    input [7:0] a, b,      // 8-bit input operands
    input [2:0] opcode,    // 3-bit operation selection code
    output reg [7:0] result, // 8-bit output result
    output reg zero        // Zero flag, high when result is 0
    );

    // --- Opcodes (using localparam for readability) ---
    // These define the operation to be performed by the ALU.
    localparam OP_ADD   = 3'b000; // Addition
    localparam OP_SUB   = 3'b001; // Subtraction
    localparam OP_AND   = 3'b010; // Bitwise AND
    localparam OP_OR    = 3'b011; // Bitwise OR
    localparam OP_XOR   = 3'b100; // Bitwise XOR
    localparam OP_NOT_A = 3'b101; // Bitwise NOT of input 'a'
    localparam OP_PASS_B= 3'b110; // Pass input 'b' to the output

    // --- Core ALU Logic ---
    // This combinational logic block calculates the result and flags based on the opcode.
    // 'always @(*)' ensures the block is evaluated if any of its inputs (a, b, opcode) change.
    always @(*) begin
        // The case statement selects an operation based on the opcode.
        case(opcode)
            OP_ADD:   result = a + b;
            OP_SUB:   result = a - b;
            OP_AND:   result = a & b;
            OP_OR:    result = a | b;
            OP_XOR:   result = a ^ b;
            OP_NOT_A: result = ~a;
            OP_PASS_B:result = b;
            default:  result = 8'h00; // Default to 0 if opcode is unknown
        endcase

        // --- Zero Flag Logic ---
        // This is now calculated procedurally within the same always block.
        zero = (result == 8'h00);
    end

    // The continuous assignment for 'zero' has been removed from here.

endmodule

