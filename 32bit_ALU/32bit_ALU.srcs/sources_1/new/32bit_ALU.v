`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 13:20:31
// Design Name: 
// Module Name: 32bit_ALU
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

module alu_32bit(
    input [31:0] a, b,      // 32-bit input operands
    input [2:0] opcode,     // 3-bit operation selection code
    output reg [31:0] result, // 32-bit output result
    output zero             // Zero flag, high when result is 0
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
    // This combinational logic block calculates the result based on the opcode.
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
            default:  result = 32'h00000000; // Default to 0 if opcode is unknown
        endcase
    end

    // --- Zero Flag Logic ---
    // This wire is asserted (goes to '1') only when the result is all zeros.
    // It's a continuous assignment, so 'zero' will always reflect the state of 'result'.
    assign zero = (result == 32'h00000000);

endmodule

