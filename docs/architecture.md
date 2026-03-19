# Architecture Notes

## ALU Block Diagram

```
                +---------------------------+
                |        alu (N-bit)        |
                |                           |
  a [N-1:0] -->|                           |--> result [N-1:0]
                |    +----------------+     |
  b [N-1:0] -->|    |  Combinational |     |--> zero
                |    |  Logic (case)  |     |
  opcode[2:0]->|    +----------------+     |
                |                           |
                +---------------------------+
```

## Opcode Encoding

| Opcode | Binary | Operation            |
|--------|--------|----------------------|
| 0      | 000    | ADD (a + b)          |
| 1      | 001    | SUB (a - b)          |
| 2      | 010    | AND (a & b)          |
| 3      | 011    | OR  (a \| b)         |
| 4      | 100    | XOR (a ^ b)          |
| 5      | 101    | NOT (~a)             |
| 6      | 110    | PASS B (b)           |
| 7      | 111    | Reserved (outputs 0) |

## Parameterization

The core `alu` module uses a Verilog `parameter WIDTH` to set the operand
and result bit-width. The three wrapper modules fix this parameter:

- `alu_8bit`  -> `alu #(.WIDTH(8))`
- `alu_16bit` -> `alu #(.WIDTH(16))`
- `alu_32bit` -> `alu #(.WIDTH(32))`

To add a new width (e.g., 64-bit), create a wrapper that instantiates
`alu #(.WIDTH(64))` with the appropriate port widths.

## Zero Flag

The `zero` output is a continuous assignment that asserts high when
`result == 0`. It updates combinationally with every change to `result`.
