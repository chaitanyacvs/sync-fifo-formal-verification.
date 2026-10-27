# Synchronous FIFO — Simulation and Formal Verification

[![Verilog](https://img.shields.io/badge/HDL-SystemVerilog-blue)](https://www.systemverilog.io/)
[![Simulation](https://img.shields.io/badge/Simulation-Icarus%20Verilog-orange)](https://github.com/steveicarus/iverilog)
[![Formal](https://img.shields.io/badge/Formal-Yosys%20%7C%20SymbiYosys-purple)](https://symbiyosys.readthedocs.io/)

A hardware design verification project focused on validating a synchronous First-In, First-Out (FIFO) buffer using SystemVerilog simulation, assertions, and formal verification.

## Overview

A synchronous FIFO stores data temporarily and returns it in the same order in which it was written. Read and write operations are controlled by a common clock, while status signals indicate whether the buffer is full or empty.

This project explores RTL verification through directed simulation and formal property checking. It is designed to detect functional errors in FIFO control logic, pointer updates, occupancy tracking, and read/write behavior.

## Objectives

- Verify correct FIFO write and read operations.
- Check first-in, first-out data ordering.
- Validate full and empty status behavior.
- Exercise simultaneous read and write operations.
- Verify reset behavior and pointer initialization.
- Use assertions and formal properties to describe FIFO requirements.
- Run automated simulation and formal verification flows.
- Preserve logs and verification configuration for reproducibility.

## Design Features

The FIFO implementation and verification environment may include the following features, depending on the actual RTL:

- Synchronous clock and reset.
- Write enable and read enable controls.
- Data input and data output interfaces.
- Read and write pointers.
- Full and empty status flags.
- Occupancy or count tracking.
- Boundary-condition handling.
- Protection against illegal operations.

## Verification Architecture

```text
              SystemVerilog Testbench
                        |
                 Stimulus Generation
                        |
                        v
                  Synchronous FIFO
                        |
             +----------+----------+
             |                     |
         Data Output           Status Flags
             |                     |
             v                     v
        Data Checking       Assertions/Checks
             |                     |
             +----------+----------+
                        |
                        v
                  PASS / FAIL
```

Formal verification complements simulation by checking specified properties under the assumptions and bounds of the configured formal engine.

## Verification Scope

| Test category           | Verification objective                                  |
| ----------------------- | ------------------------------------------------------- |
| Reset                   | Check reset initialization and expected status          |
| Basic write             | Verify data is accepted when writing is permitted       |
| Basic read              | Verify the oldest stored item is returned               |
| FIFO ordering           | Confirm data is read in write order                     |
| Empty condition         | Check behavior when no data is available                |
| Full condition          | Check behavior when storage capacity is reached         |
| Simultaneous operations | Examine concurrent read and write requests              |
| Boundary transitions    | Check empty-to-nonempty and full-to-nonfull transitions |
| Pointer behavior        | Check pointer progression and wraparound                |
| Data integrity          | Detect missing, duplicated, or reordered data           |
| Formal properties       | Check configured safety and control invariants          |

The actual tests covered are determined by the implemented testbench and formal properties.

## Tools and Technologies

| Tool                    | Purpose                               |
| ----------------------- | ------------------------------------- |
| Verilog / SystemVerilog | FIFO RTL, testbench, and properties   |
| Icarus Verilog          | Simulation compilation                |
| VVP                     | Simulation execution                  |
| Yosys                   | RTL processing and formal preparation |
| SymbiYosys (SBY)        | Formal verification orchestration     |
| `yosys-smtbmc`          | SMT-based formal checking             |
| Z3                      | SMT solver                            |
| Bash                    | Verification automation               |
| Git and GitHub          | Version control and project hosting   |

## Repository Structure

```text
sync-fifo-formal-verification/
├── rtl/
│   └── sync_fifo.sv
├── tb/
│   └── tb_sync_fifo.sv
├── formal/
│   ├── fifo_formal.sv
│   ├── fifo_properties.sv
│   └── fifo.sby
├── scripts/
│   └── run_sim.sh
├── results/
│   ├── simulation.log
│   └── formal.log
└── README.md
```

_This is a representative structure. Retain or rename entries to match the files actually present in the repository._

## Getting Started

### Prerequisites

Install Icarus Verilog, Yosys, SymbiYosys, `yosys-smtbmc`, and Z3 as required by the verification scripts.

Verify tool availability:

```bash
iverilog -V
vvp -V
yosys -V
sby --version
z3 --version
```

### Clone the repository

```bash
git clone <YOUR_FIFO_REPOSITORY_URL>
cd sync-fifo-formal-verification
```

Replace the placeholder with the actual GitHub repository URL.

## Running Simulation

If the repository contains `scripts/run_sim.sh`, execute:

```bash
chmod +x scripts/run_sim.sh
./scripts/run_sim.sh
```

Alternatively, compile the actual FIFO RTL and testbench files directly:

```bash
iverilog -g2012 -o fifo_sim \
    <fifo_rtl_files> <fifo_testbench_files>

vvp fifo_sim
```

Replace the placeholders with the actual source paths. Check the output and logs for mismatches, assertion failures, and pass/fail summaries.

## Running Formal Verification

If the repository contains the configuration file `fifo.sby`, run:

```bash
sby -f fifo.sby
```

The formal harness and properties should describe the FIFO's intended behavior, including reset assumptions, legal input conditions, data ordering, pointer constraints, and status consistency.

Review the generated results to determine whether each property passed, failed, or remained unproven. A bounded model-checking result should not be described as an unbounded proof unless the configuration and output establish that result.

## Verification Results

Record the actual results produced by the committed simulation and formal scripts.

Recommended metrics include:

- Number of simulation scenarios executed.
- Number of checks passed and failed.
- FIFO ordering and data-integrity results.
- Full and empty boundary-condition results.
- Assertion and formal-property outcomes.
- Formal proof depth and assumptions.
- Counterexamples and known limitations.

No pass count or formal-proof claim is stated here without the corresponding logs as evidence.

## Common Issues

### Simulation fails to compile

Confirm that all required source files are included and that the selected testbench top module is correct.

### Data ordering mismatch

Inspect the read and write pointers, occupancy tracking, and the expected queue maintained by the testbench.

### Full or empty flag mismatch

Check the FIFO count logic, pointer wraparound, reset behavior, and the defined behavior for simultaneous read/write requests at boundary conditions.

### Formal verification fails

Inspect the counterexample trace, reset assumptions, property definitions, and formal harness. A failure may indicate an RTL bug or a problem in the verification environment.

## Future Improvements

- Add randomized read/write sequences.
- Add parameterized data width and FIFO depth tests.
- Strengthen pointer-wraparound and simultaneous-operation coverage.
- Add assertions for FIFO ordering, occupancy bounds, and status consistency.
- Integrate simulation and formal checks into CI.
- Add mutation or fault-injection tests to evaluate verification effectiveness.
- Document proof assumptions and limitations.

## Conclusion

This project demonstrates a structured approach to synchronous FIFO verification using SystemVerilog simulation and formal methods. It emphasizes data integrity, boundary-condition checking, control-signal correctness, and reproducible verification results.

The final verification status should be based on the actual simulation logs and formal-engine outcomes in the repository.
