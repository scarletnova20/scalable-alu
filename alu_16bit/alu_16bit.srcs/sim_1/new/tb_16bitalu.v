`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:      -
// Engineer:     -
// 
// Create Date:  14.10.2025 22:28:00
// Design Name:  16-bit ALU Testbench
// Module Name:  alu_16bit_tb
// Project Name: ALU Performance Comparison
// Target Devices: -
// Tool Versions: 
// Description:  A testbench to verify the functionality of the 16-bit ALU.
//               It tests all defined operations with sample data and displays
//               the results in the console.
//
// Dependencies: alu_16bit.v
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_16bitalu;

    // --- Inputs for the DUT ---
    reg [15:0] a, b;
    reg [2:0] opcode;

    // --- Outputs from the DUT ---
    wire [15:0] result;
    wire zero;

    // --- Instantiate the Device Under Test (DUT) ---
    // This creates an instance of your alu_16bit module and connects the 
    // testbench's regs and wires to its ports.
    alu_16bit uut (
        .a(a), 
        .b(b), 
        .opcode(opcode), 
        .result(result), 
        .zero(zero)
    );
    
    // --- Opcodes (using localparam for readability in testbench) ---
    localparam OP_ADD    = 3'b000;
    localparam OP_SUB    = 3'b001;
    localparam OP_AND    = 3'b010;
    localparam OP_OR     = 3'b011;
    localparam OP_XOR    = 3'b100;
    localparam OP_NOT_A  = 3'b101;
    localparam OP_PASS_B = 3'b110;

    // --- Test Vector Generation ---
    initial begin
        // Use $display to show a header for our test results.
        $display("Time\t Opcode\t A(hex)\t B(hex)\t Result(hex)\t Zero");
        $monitor("%gns\t %b\t %h\t %h\t %h\t %b", $time, opcode, a, b, result, zero);

        // -- Initialize Inputs --
        a = 16'h0000;
        b = 16'h0000;
        opcode = 3'b000;
        #10; // Wait 10ns for signals to settle

        // -- Test Case 1: ADD --
        opcode = OP_ADD;
        a = 16'h0005;
        b = 16'h000A; // Expected result: 15 (0x000F)
        #10;

        // -- Test Case 2: SUB --
        opcode = OP_SUB;
        a = 16'h0010;
        b = 16'h0007; // Expected result: 9 (0x0009)
        #10;
        
        // -- Test Case 3: SUB (for Zero flag) --
        opcode = OP_SUB;
        a = 16'hAAAA;
        b = 16'hAAAA; // Expected result: 0, zero = 1
        #10;

        // -- Test Case 4: AND --
        opcode = OP_AND;
        a = 16'hFF00;
        b = 16'h0FF0; // Expected result: 0x0F00
        #10;

        // -- Test Case 5: OR --
        opcode = OP_OR;
        a = 16'hFF00;
        b = 16'h0FF0; // Expected result: 0xFFF0
        #10;

        // -- Test Case 6: XOR --
        opcode = OP_XOR;
        a = 16'hFFFF;
        b = 16'h0F0F; // Expected result: 0xF0F0
        #10;

        // -- Test Case 7: NOT A --
        opcode = OP_NOT_A;
        a = 16'hFF00; // Expected result: 0x00FF
        // 'b' is ignored in this operation
        #10;

        // -- Test Case 8: PASS B --
        opcode = OP_PASS_B;
        b = 16'h1234; // Expected result: 0x1234
        // 'a' is ignored in this operation
        #10;

        // End the simulation
        $display("Simulation Finished.");
        $finish;
    end
endmodule
