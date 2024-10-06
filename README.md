# Synchronous FIFO Verification

<!-- Add your image here -->
![Project Image]([path/to/image.png](https://github.com/MohamedHussein27/FIFO-Verification/blob/main/Doc/Synchronous%20FIFO%20Verification.pdf))

## Overview

This project involves the verification of a **Synchronous FIFO** design using SystemVerilog. The goal was to ensure the correctness of the design by implementing a comprehensive testbench, including coverage, assertions, and various checks to verify underflow, overflow, and other edge conditions.

### Key Features of the FIFO:
- **FIFO_WIDTH**: Data in/out and memory word width (default: 16)
- **FIFO_DEPTH**: Memory depth (default: 8)

### Ports:

| Port       | Direction | Function                                                                                     |
|------------|-----------|----------------------------------------------------------------------------------------------|
| data_in    | Input     | Write Data: The input data bus used when writing the FIFO.                                    |
| wr_en      | Input     | Write Enable: If the FIFO is not full, asserting this signal causes data to be written in.    |
| rd_en      | Input     | Read Enable: If the FIFO is not empty, asserting this signal causes data to be read out.      |
| clk        | Input     | Clock signal.                                                                                 |
| rst_n      | Input     | Active low asynchronous reset.                                                                |
| data_out   | Output    | Read Data: The sequential output data bus used when reading from the FIFO.                    |
| full       | Output    | Full Flag: Indicates that the FIFO is full.                                                   |
| almostfull | Output    | Almost Full: Indicates that only one more write can be performed before the FIFO is full.     |
| empty      | Output    | Empty Flag: Indicates that the FIFO is empty.                                                 |
| almostempty| Output    | Almost Empty: Indicates that only one more read can be performed before the FIFO is empty.    |
| overflow   | Output    | Indicates that a write request was rejected because the FIFO is full.                        |
| underflow  | Output    | Indicates that a read request was rejected because the FIFO is empty.                        |
| wr_ack     | Output    | Write Acknowledge: Indicates that a write request succeeded.                                  |

### Behavior:
- If both `rd_en` and `wr_en` are high, the FIFO will prioritize writing if empty and reading if full.
- The **FIFO** design includes checks for underflow and overflow conditions.

## Verification Plan

The detailed **Verification Plan** is included in the [Documentation](https://github.com/MohamedHussein27/FIFO-Verification/tree/main/Doc).

### Testbench Flow:

1. The top module generates the clock and passes it to the interface.
2. The testbench (tb) resets the FIFO, randomizes the inputs, and asserts the `test_finished` signal at the end.
3. A **monitor** is used to sample data from the interface, check for correct output, and calculate functional coverage.

### Key Modules:
- **FIFO_transaction**: Handles the transactions for the FIFO operations.
- **FIFO_scoreboard**: Compares the design output with a reference model and counts errors.
- **FIFO_coverage**: Collects functional coverage using a covergroup for `wr_en`, `rd_en`, and the FIFO control signals.

### Functional Coverage:
Cross-coverage between write enable, read enable, and all control output signals is implemented to ensure that all possible states of the FIFO are exercised during verification.

### Assertions:
Assertions are added to all output flags (except `data_out`) and internal counters to ensure correct behavior. Conditional compilation is used to guard these assertions.

---

## Repository Structure:

```plaintext
FIFO-Verification/
│
├── design/                               # Contains the RTL design files for the FIFO
│   └── FIFO.sv
│
├── verification/                         # Verification-related files
│   ├── FIFO_IF.sv                        # FIFO Interface
│   ├── FIFO_CONFIG.sv                    # Configuration file for verification environment
│   ├── FIFO_TRANSACTION.sv               # Handles transaction details for verification
│   ├── FIFO_SCOREBOARD.sv                # Compares DUT outputs with reference model
│   ├── FIFO_COVERAGE.sv                  # Functional coverage collection
│   ├── FIFO_DRIVER.sv                    # Drives stimulus to the DUT
│   ├── FIFO_MONITOR.sv                   # Monitors and checks the DUT outputs
│   ├── FIFO_AGENT.sv                     # Agent combining driver and monitor
│   ├── FIFO_SEQUENCER.sv                 # Sequencer for controlling stimulus generation
│   ├── FIFO_TEST.sv                      # Test file that runs the verification
│   ├── FIFO_TOP.sv                       # Top-level module for running the simulation
│   └── FIFO_SVA.sv                       # SystemVerilog Assertions for the design
│
└── README.md                             # Project documentation


## Getting Started

### Prerequisites:
- **QuestaSim/Mentor Graphics** for simulation.
- **SystemVerilog** for verification.

### Running the Testbench:
1. Compile the design and testbench files using your simulator.
2. Run the `FIFO_TEST` module to start the simulation.
3. Check the simulation results and coverage report for 100% functional and code coverage.
