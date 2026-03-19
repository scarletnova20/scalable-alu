# Scalable Multi-Bit ALU

A parameterized Arithmetic Logic Unit implemented in Verilog, supporting 8-bit, 16-bit, and 32-bit datapaths. The design uses a single parameterized RTL core that scales to arbitrary bit-widths through a configurable `WIDTH` parameter, with thin wrapper modules providing fixed-width interfaces for integration into standard processor datapaths.

Designed and simulated using Xilinx Vivado.

---

## Table of Contents

- [Overview](#overview)
- [Supported Operations](#supported-operations)
- [Architecture](#architecture)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Simulation](#simulation)
- [Extending to Other Bit-Widths](#extending-to-other-bit-widths)
- [Results](#results)

---

## Overview

This project implements a scalable ALU capable of executing parallel arithmetic and bitwise logical operations across multiple bit-widths. The architecture prioritizes:

- **Parameterized design** -- A single RTL core (`alu.v`) with a configurable `WIDTH` parameter enables seamless scaling without code duplication.
- **Optimized datapath routing** -- Pure combinational logic with no clock dependency, minimizing gate-level propagation delay for high-frequency integration.
- **Rigorous verification** -- Dedicated testbenches for each bit-width variant validate all operations, edge cases (overflow, underflow, zero-flag assertion), and boundary values.

---

## Supported Operations

The ALU supports seven operations selected by a 3-bit opcode:

| Opcode | Binary | Operation        | Description                     |
|--------|--------|------------------|---------------------------------|
| 0      | `000`  | ADD              | Unsigned addition (a + b)       |
| 1      | `001`  | SUB              | Unsigned subtraction (a - b)    |
| 2      | `010`  | AND              | Bitwise AND (a & b)             |
| 3      | `011`  | OR               | Bitwise OR (a \| b)             |
| 4      | `100`  | XOR              | Bitwise XOR (a ^ b)             |
| 5      | `101`  | NOT              | Bitwise complement (~a)         |
| 6      | `110`  | PASS B           | Pass operand B to output        |
| 7      | `111`  | Reserved         | Outputs zero (default case)     |

A **zero flag** output is asserted whenever the result equals zero.

---

## Architecture

```
                 +-------------------------------+
                 |         alu #(WIDTH=N)        |
                 |                               |
   a [N-1:0] -->|                               |--> result [N-1:0]
                 |      +------------------+     |
   b [N-1:0] -->|      |   Combinational  |     |--> zero
                 |      |   Logic (case)   |     |
   opcode[2:0]->|      +------------------+     |
                 |                               |
                 +-------------------------------+
```

The parameterized `alu` module is the single source of truth for all ALU logic. Width-specific modules (`alu_8bit`, `alu_16bit`, `alu_32bit`) are thin wrappers that instantiate the core with a fixed `WIDTH` parameter:

```verilog
module alu_8bit (...);
    alu #(.WIDTH(8)) u_alu (
        .a(a), .b(b), .opcode(opcode),
        .result(result), .zero(zero)
    );
endmodule
```

---

## Directory Structure

```
scalable-alu/
|-- rtl/
|   |-- alu.v            # Parameterized N-bit ALU core
|   |-- alu_8bit.v       # 8-bit wrapper
|   |-- alu_16bit.v      # 16-bit wrapper
|   |-- alu_32bit.v      # 32-bit wrapper
|
|-- testbench/
|   |-- tb_alu_8bit.v    # 8-bit testbench
|   |-- tb_alu_16bit.v   # 16-bit testbench
|   |-- tb_alu_32bit.v   # 32-bit testbench
|
|-- docs/
|   |-- architecture.md  # Detailed architecture notes
|
|-- .gitignore
|-- README.md
```

---

## Getting Started

### Prerequisites

- [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html) (2020.2 or later) for synthesis and simulation
- Alternatively, any Verilog simulator such as [Icarus Verilog](http://iverilog.icarus.com/) or ModelSim

### Cloning the Repository

```bash
git clone https://github.com/scarletnova20/scalable-alu.git
cd scalable-alu
```

---

## Simulation

### Using Xilinx Vivado

1. Open Vivado and create a new project.
2. Add the RTL sources from the `rtl/` directory.
3. Add the corresponding testbench from the `testbench/` directory as a simulation source.
4. Run behavioral simulation. The console will display pass/fail results for each test vector.

### Using Icarus Verilog

```bash
# 8-bit ALU
iverilog -o sim_8bit rtl/alu.v rtl/alu_8bit.v testbench/tb_alu_8bit.v
vvp sim_8bit

# 16-bit ALU
iverilog -o sim_16bit rtl/alu.v rtl/alu_16bit.v testbench/tb_alu_16bit.v
vvp sim_16bit

# 32-bit ALU
iverilog -o sim_32bit rtl/alu.v rtl/alu_32bit.v testbench/tb_alu_32bit.v
vvp sim_32bit
```

Each testbench prints a summary of passed and failed test cases at the end of simulation.

---

## Extending to Other Bit-Widths

To add support for a new bit-width (for example, 64-bit):

1. Create a new wrapper module:

```verilog
module alu_64bit (
    input  [63:0] a, b,
    input  [2:0]  opcode,
    output [63:0] result,
    output        zero
);
    alu #(.WIDTH(64)) u_alu (
        .a(a), .b(b), .opcode(opcode),
        .result(result), .zero(zero)
    );
endmodule
```

2. Create a corresponding testbench following the pattern in `testbench/`.

No changes to the core `alu.v` module are required.

---

## Results

- All three ALU variants (8-bit, 16-bit, 32-bit) pass 100% of test vectors across all seven operations.
- Edge cases verified include unsigned overflow/underflow wrapping, zero-flag assertion on equal operands, bitwise operations on boundary values (`0x00`/`0xFF`, `0x0000`/`0xFFFF`, `0x00000000`/`0xFFFFFFFF`), and the default opcode behavior.
- Pure combinational design with no registered outputs ensures minimal propagation delay, suitable for single-cycle datapath integration in high-frequency processor designs.

---

## Tools Used

- **HDL**: Verilog (IEEE 1364-2005)
- **Simulation**: Xilinx Vivado Behavioral Simulation
- **Target Platform**: Xilinx FPGA (design is platform-agnostic)

---

## License

This project is provided for educational and reference purposes.
