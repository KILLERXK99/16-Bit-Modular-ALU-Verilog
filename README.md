# 16-Bit Modular ALU in Verilog

A high-performance, modular 16-bit Arithmetic Logic Unit (ALU) implemented in Verilog HDL. Designed with a clean modular hierarchy, featuring a Carry Lookahead Adder (CLA), comprehensive arithmetic/logical operations, bit-shifting capabilities, and live status flags.

## Features
* **Modular Design:** Independent, reusable sub-modules for arithmetic, logic, and shifting operations.
* **Carry Lookahead Architecture:** 16-bit CLA (`cla16b`) utilizing fast propagate/generate logic to minimize propagation delay.
* **Diverse Instruction Set:** Supports addition, subtraction with/without borrow, increments/decrements, two's complement, bitwise logic (AND, OR, XOR), logical shifts, and rotators (with/without carry).
* **Status Flags:** 5-bit flag register output tracking Carry (`C`), Zero (`Z`), Borrow/Sign (`B`), and Parity (`P`).
* **Simulation Ready:** Includes a complete testbench configured for Quartus Prime and ModelSim.

## Supported Operations (via 4-bit `sel` pin)
| Opcode (`sel`) | Operation | Description |
| :--- | :--- | :--- |
| `4'b0000` | Addition | `in1 + in2` (via CLA) |
| `4'b0001` | Addition with Carry | `in1 + in2 + cin` |
| `4'b0010` | Subtraction | `in1 - in2` |
| `4'b0011` | Subtraction with Borrow | `in1 - in2 - bin` |
| `4'b0100` | Two's Complement | Negates `in1` |
| `4'b0101` | Increment | `in1 + 1` |
| `4'b0110` | Decrement | `in1 - 1` |
| `4'b0111` | Bitwise AND | `in1 & in2` |
| `4'b1000` | Bitwise OR | `in1 \| in2` |
| `4'b1001` | Bitwise XOR | `in1 ^ in2` |
| `4'b1010` | Logical Shift | Shift left/right based on `dir` |
| `4'b1011` | Rotator | Bit rotation without carry |
| `4'b1100` | Rotator with Carry | Bit rotation including `cin` |

## Status Flags Layout (`flags[4:0]`)
* **`flags[4]`**: Carry Out / Overflow indicator
* **`flags[3]`**: Zero Flag (Asserts if output is `16'h0000`)
* **`flags[2]`**: Borrow / Sign status
* **`flags[1]`**: Reserved / Unused (`0`)
* **`flags[0]`**: Parity Flag (Reduction XOR across output bits)

## Future Modifications
* **Signed Overflow (V) Flag:** Implement a dedicated signed overflow flag utilizing the currently unused `flags[1]` bit.
* **Hardware Multiplier & Divider:** Integrate combinational multipliers and sequential divider blocks to expand computational capabilities.
* **Arithmetic Shift Right (SRA):** Add support for sign-extended right shifting for signed numbers.
* **Pipelining:** Insert internal pipeline registers to improve maximum clock frequency for high-speed FPGA applications.
* **Processor Integration:** Scale up the project into a fully functional 16-bit RISC processor datapath complete with a register file and control unit.

## How to Simulate in Quartus Prime / ModelSim
1. Clone the repository and open **Quartus Prime**.
2. Create a new project and add all source files from the `rtl/` and `testbench/` directories.
3. Go to **Assignments > Settings > EDA Tool Settings > Simulation** and select **ModelSim-Altera** or **Questa Intel FPGA**.
4. Under **NativeLink settings**, select **Compile test bench** and point it to `tb_main_alu16`.
5. Run **Tools > Run Simulation Tool > RTL Simulation** to view waveforms and transcript monitor logs.
