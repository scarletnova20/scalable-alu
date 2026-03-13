`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name:  tb_alu_8bit
// Description:  Testbench for the 8-bit ALU. Verifies all seven ALU operations
//               including edge cases such as overflow, underflow, zero-flag
//               assertion, and boundary operand values (0x00, 0xFF).
//////////////////////////////////////////////////////////////////////////////////

module tb_alu_8bit;

    // --- Testbench Signals ---
    reg  [7:0] a, b;
    reg  [2:0] opcode;
    wire [7:0] result;
    wire       zero;

    // --- DUT Instantiation ---
    alu_8bit uut (
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
        input [7:0] expected;
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
        $display(" 8-bit ALU Testbench");
        $display("============================================");

        // --- ADD Tests ---
        $display("\n[ADD]");
        opcode = OP_ADD; a = 8'h05; b = 8'h0A; #10;
        check(8'h0F, 1'b0);

        opcode = OP_ADD; a = 8'hFF; b = 8'h01; #10;  // Overflow wrap
        check(8'h00, 1'b1);

        opcode = OP_ADD; a = 8'h00; b = 8'h00; #10;  // Zero + Zero
        check(8'h00, 1'b1);

        opcode = OP_ADD; a = 8'h80; b = 8'h80; #10;  // Signed overflow
        check(8'h00, 1'b1);

        // --- SUB Tests ---
        $display("\n[SUB]");
        opcode = OP_SUB; a = 8'h10; b = 8'h07; #10;
        check(8'h09, 1'b0);

        opcode = OP_SUB; a = 8'hAA; b = 8'hAA; #10;  // Zero flag
        check(8'h00, 1'b1);

        opcode = OP_SUB; a = 8'h00; b = 8'h01; #10;  // Underflow wrap
        check(8'hFF, 1'b0);

        // --- AND Tests ---
        $display("\n[AND]");
        opcode = OP_AND; a = 8'hF0; b = 8'h0F; #10;
        check(8'h00, 1'b1);

        opcode = OP_AND; a = 8'hFF; b = 8'hFF; #10;
        check(8'hFF, 1'b0);

        // --- OR Tests ---
        $display("\n[OR]");
        opcode = OP_OR; a = 8'hF0; b = 8'h0F; #10;
        check(8'hFF, 1'b0);

        opcode = OP_OR; a = 8'h00; b = 8'h00; #10;
        check(8'h00, 1'b1);

        // --- XOR Tests ---
        $display("\n[XOR]");
        opcode = OP_XOR; a = 8'hFF; b = 8'h0F; #10;
        check(8'hF0, 1'b0);

        opcode = OP_XOR; a = 8'hAA; b = 8'hAA; #10;  // Same inputs -> zero
        check(8'h00, 1'b1);

        // --- NOT A Tests ---
        $display("\n[NOT A]");
        opcode = OP_NOT_A; a = 8'hFF; b = 8'h00; #10;
        check(8'h00, 1'b1);

        opcode = OP_NOT_A; a = 8'h00; b = 8'h00; #10;
        check(8'hFF, 1'b0);

        // --- PASS B Tests ---
        $display("\n[PASS B]");
        opcode = OP_PASS_B; a = 8'h00; b = 8'h42; #10;
        check(8'h42, 1'b0);

        opcode = OP_PASS_B; a = 8'hFF; b = 8'h00; #10;
        check(8'h00, 1'b1);

        // --- Default Opcode ---
        $display("\n[DEFAULT]");
        opcode = 3'b111; a = 8'hFF; b = 8'hFF; #10;
        check(8'h00, 1'b1);

        // --- Summary ---
        $display("\n============================================");
        $display(" Results: %0d passed, %0d failed", pass_count, fail_count);
        $display("============================================");
        $finish;
    end

endmodule
