# Scalable Multi-Bit ALU Architecture

> Parameterized 8-bit, 16-bit, and 32-bit ALU designs in Verilog supporting parallel arithmetic and bitwise logical operations, with RTL modules optimized for bit-width scaling and full behavioral simulation coverage.

---

## Overview

This project implements a **scalable Arithmetic Logic Unit (ALU)** in Verilog, designed to execute parallel arithmetic and bitwise logical operations across multiple bit-widths. The architecture uses parameterized RTL modules to allow seamless scaling from 8-bit to 16-bit to 32-bit datapaths, making it suitable for integration into high-frequency processor pipelines.

All designs were developed and simulated using **Vivado**, achieving 100% behavioral simulation accuracy across all operational states.

---

## Features

- Parameterized RTL modules for seamless 8-bit, 16-bit, and 32-bit scaling
- Parallel arithmetic operations — Addition, Subtraction, Multiplication
- Bitwise logical operations — AND, OR, XOR, NOT
- Optimized datapath routing for core instruction execution
- Rigorous testbenches validating edge cases and corner conditions
- 100% behavioral simulation accuracy across all operational states
- Minimized gate-level propagation delay for high-frequency processor integration

---

## Repository Structure

```
scalable-alu/
├── alu8bit/          # 8-bit ALU RTL design and simulation files
├── alu_16bit/        # 16-bit ALU RTL design and simulation files
├── 32bit_ALU/        # 32-bit ALU RTL design and simulation files
├── rtl/              # Parameterized top-level RTL modules
├── testbench/        # Testbenches for functional verification
└── README.md
```

---

## Tools & Technologies

| Tool / Language | Purpose |
|---|---|
| Verilog HDL | RTL design and implementation |
| Vivado (Xilinx) | Synthesis, simulation, and timing analysis |
| Testbenches | Functional and behavioral verification |

---

## Supported Operations

| Operation | Type |
|---|---|
| Addition | Arithmetic |
| Subtraction | Arithmetic |
| Multiplication | Arithmetic |
| AND | Bitwise Logical |
| OR | Bitwise Logical |
| XOR | Bitwise Logical |
| NOT | Bitwise Logical |

---

## Getting Started

### Prerequisites
- Xilinx Vivado (2020.x or later recommended)
- Basic knowledge of Verilog / HDL simulation

### Running the Simulation

1. Clone the repository:
   ```bash
   git clone https://github.com/scarletnova20/scalable-alu.git
   cd scalable-alu
   ```

2. Open **Vivado** and create a new project.

3. Add the RTL source files from the relevant folder (`alu8bit/`, `alu_16bit/`, or `32bit_ALU/`).

4. Add the corresponding testbench from the `testbench/` folder.

5. Run **Behavioral Simulation** to verify functionality.

---

## Simulation Results

- **Behavioral Simulation Accuracy:** 100% across all operational states
- **Bit-widths Verified:** 8-bit, 16-bit, 32-bit
- **Edge Cases Covered:** Overflow, zero result, max value inputs, bitwise boundary conditions
- **Propagation Delay:** Minimized via optimized datapath routing

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Author

**Hriddhima Saraswat**  
[GitHub](https://github.com/scarletnova20)
