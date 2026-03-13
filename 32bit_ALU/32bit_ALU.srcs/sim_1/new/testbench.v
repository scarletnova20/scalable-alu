`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.09.2025 18:59:56
// Design Name: 
// Module Name: testbench
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

`timescale 1ns / 1ps
module testbench;

    // --- Inputs for the DUT ---
    reg [31:0] a, b;
    reg [2:0] opcode;

    // --- Outputs from the DUT ---
    wire [31:0] result;
    wire zero;

    // --- Instantiate the Device Under Test (DUT) ---
    // This creates an instance of your alu_32bit module and connects the 
    // testbench's regs and wires to its ports.
    alu_32bit uut (
        .a(a), 
        .b(b), 
        .opcode(opcode), 
        .result(result), 
        .zero(zero)
    );
    
    // --- Opcodes (using localparam for readability in testbench) ---
    localparam OP_ADD   = 3'b000;
    localparam OP_SUB   = 3'b001;
    localparam OP_AND   = 3'b010;
    localparam OP_OR    = 3'b011;
    localparam OP_XOR   = 3'b100;
    localparam OP_NOT_A = 3'b101;
    localparam OP_PASS_B= 3'b110;

    // --- Test Vector Generation ---
    initial begin
        // Use $display to show a header for our test results.
        $display("Time\t Opcode\t A(hex)\t\t B(hex)\t\t Result(hex)\t Zero");
        $monitor("%gns\t %b\t %h\t %h\t %h\t %b", $time, opcode, a, b, result, zero);

        // -- Initialize Inputs --
        a = 32'h00000000;
        b = 32'h00000000;
        opcode = 3'b000;
        #10; // Wait 10ns for signals to settle

        // -- Test Case 1: ADD --
        opcode = OP_ADD;
        a = 32'h00000005;
        b = 32'h0000000A; // Expected result: 15 (0xF)
        #10;

        // -- Test Case 2: SUB --
        opcode = OP_SUB;
        a = 32'h00000010;
        b = 32'h00000007; // Expected result: 9 (0x9)
        #10;
        
        // -- Test Case 3: SUB (for Zero flag) --
        opcode = OP_SUB;
        a = 32'hAAAAAAAA;
        b = 32'hAAAAAAAA; // Expected result: 0, zero = 1
        #10;

        // -- Test Case 4: AND --
        opcode = OP_AND;
        a = 32'hFFFF0000;
        b = 32'h00FFFF00; // Expected result: 00FF0000
        #10;
        
        // -- Test Case 5: OR --
        opcode = OP_OR;
        a = 32'hFFFF0000;
        b = 32'h00FFFF00; // Expected result: FFFFFF00
        #10;

        // -- Test Case 6: XOR --
        opcode = OP_XOR;
        a = 32'hFFFFFFFF;
        b = 32'h0F0F0F0F; // Expected result: F0F0F0F0
        #10;
        
        // -- Test Case 7: NOT A --
        opcode = OP_NOT_A;
        a = 32'hFFFF0000; // Expected result: 0000FFFF
        // 'b' is ignored in this operation
        #10;

        // -- Test Case 8: PASS B --
        opcode = OP_PASS_B;
        b = 32'h12345678; // Expected result: 12345678
        // 'a' is ignored in this operation
        #10;

        // End the simulation
        $display("Simulation Finished.");
        $finish;
    end

endmodule

