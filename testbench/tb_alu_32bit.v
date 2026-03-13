`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:  tb_alu_32bit
// Description:  Testbench for the 32-bit ALU. Verifies all seven ALU operations
//               including edge cases such as overflow, underflow, zero-flag
//               assertion, and full-width boundary values.
//////////////////////////////////////////////////////////////////////////////////

module tb_alu_32bit;

    // --- Testbench Signals ---
    reg  [31:0] a, b;
    reg  [2:0]  opcode;
    wire [31:0] result;
    wire        zero;

    // --- DUT Instantiation ---
    alu_32bit uut (
        .a      (a),
        .b      (b),
        .opcode (opcode),
        .result (result),
        .zero   (zero)
    );

    // --- Opcode Definitions ---
    localparam OP_ADD    = 3'b000;
    localparam OP_SUB    = 3'b001;
    localparam OP_AND    = 3'b010;
    localparam OP_OR     = 3'b011;
    localparam OP_XOR    = 3'b100;
    localparam OP_NOT_A  = 3'b101;
    localparam OP_PASS_B = 3'b110;

    // --- Test Sequence ---
    integer pass_count;
    integer fail_count;

    task check;
        input [31:0] expected;
        input expected_zero;
        begin
            if (result !== expected || zero !== expected_zero) begin
                $display("  FAIL: a=%h b=%h op=%b | result=%h (exp %h) zero=%b (exp %b)",
                         a, b, opcode, result, expected, zero, expected_zero);
                fail_count = fail_count + 1;
            end else begin
                $display("  PASS: a=%h b=%h op=%b | result=%h zero=%b",
                         a, b, opcode, result, zero);
                pass_count = pass_count + 1;
            end
        end
    endtask

    initial begin
        pass_count = 0;
        fail_count = 0;

        $display("============================================");
        $display(" 32-bit ALU Testbench");
        $display("============================================");

        // --- ADD Tests ---
        $display("\n[ADD]");
        opcode = OP_ADD; a = 32'h00000005; b = 32'h0000000A; #10;
        check(32'h0000000F, 1'b0);

        opcode = OP_ADD; a = 32'hFFFFFFFF; b = 32'h00000001; #10;  // Overflow
        check(32'h00000000, 1'b1);

        opcode = OP_ADD; a = 32'h80000000; b = 32'h80000000; #10;  // Signed overflow
        check(32'h00000000, 1'b1);

        // --- SUB Tests ---
        $display("\n[SUB]");
        opcode = OP_SUB; a = 32'h00000010; b = 32'h00000007; #10;
        check(32'h00000009, 1'b0);

        opcode = OP_SUB; a = 32'hAAAAAAAA; b = 32'hAAAAAAAA; #10;  // Zero flag
        check(32'h00000000, 1'b1);

        opcode = OP_SUB; a = 32'h00000000; b = 32'h00000001; #10;  // Underflow
        check(32'hFFFFFFFF, 1'b0);

        // --- AND Tests ---
        $display("\n[AND]");
        opcode = OP_AND; a = 32'hFFFF0000; b = 32'h00FFFF00; #10;
        check(32'h00FF0000, 1'b0);

        opcode = OP_AND; a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; #10;  // Disjoint
        check(32'h00000000, 1'b1);

        // --- OR Tests ---
        $display("\n[OR]");
        opcode = OP_OR; a = 32'hFFFF0000; b = 32'h00FFFF00; #10;
        check(32'hFFFFFF00, 1'b0);

        opcode = OP_OR; a = 32'h00000000; b = 32'h00000000; #10;
        check(32'h00000000, 1'b1);

        // --- XOR Tests ---
        $display("\n[XOR]");
        opcode = OP_XOR; a = 32'hFFFFFFFF; b = 32'h0F0F0F0F; #10;
        check(32'hF0F0F0F0, 1'b0);

        opcode = OP_XOR; a = 32'hDEADBEEF; b = 32'hDEADBEEF; #10;  // Same -> zero
        check(32'h00000000, 1'b1);

        // --- NOT A Tests ---
        $display("\n[NOT A]");
        opcode = OP_NOT_A; a = 32'hFFFF0000; b = 32'h00000000; #10;
        check(32'h0000FFFF, 1'b0);

        opcode = OP_NOT_A; a = 32'hFFFFFFFF; b = 32'h00000000; #10;
        check(32'h00000000, 1'b1);

        // --- PASS B Tests ---
        $display("\n[PASS B]");
        opcode = OP_PASS_B; a = 32'h00000000; b = 32'h12345678; #10;
        check(32'h12345678, 1'b0);

        opcode = OP_PASS_B; a = 32'hFFFFFFFF; b = 32'h00000000; #10;
        check(32'h00000000, 1'b1);

        // --- Default Opcode ---
        $display("\n[DEFAULT]");
        opcode = 3'b111; a = 32'hFFFFFFFF; b = 32'hFFFFFFFF; #10;
        check(32'h00000000, 1'b1);

        // --- Summary ---
        $display("\n============================================");
        $display(" Results: %0d passed, %0d failed", pass_count, fail_count);
        $display("============================================");
        $finish;
    end

endmodule
