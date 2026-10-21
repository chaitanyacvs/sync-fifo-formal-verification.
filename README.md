# Synchronous FIFO Formal Verification with RTL Bug Injection

A portfolio project exploring a parameterized synchronous FIFO, assertion-based verification, and deliberate RTL defect injection.

## Project goals
- Implement a synthesizable synchronous FIFO in SystemVerilog.
- Specify reset, occupancy, full/empty, and pointer invariants.
- Inject representative RTL bugs and document which properties detect them.
- Keep portable simulation checks separate from Synopsys VC Formal setup.
- Save proof logs and counterexamples as reproducible evidence.

## Design contract
- Single clock; active-low synchronous reset (`rst_n` is sampled on `posedge clk`).
- `DEPTH` must be at least 2 and is expected to be a power of two in this starter version.
- A write is accepted when `wr_en && !full`.
- A read is accepted when `rd_en && !empty`.
- A simultaneous read and write are independently accepted according to the pre-edge `full` and `empty` flags.
- Reads while empty and writes while full are ignored.
- `rd_data` is registered and updates only on an accepted read.
- Reset clears pointers, count, flags through the count-derived status, and output data.

## Repository layout
```text
rtl/
  sync_fifo.sv
  bug_variants/
    fifo_bug_full.sv
    fifo_bug_count.sv
formal/
  fifo_properties.sv
  README.md
simulation/
  fifo_tb.sv
scripts/
  run_sim.sh
reports/
  .gitkeep
```

## Quick start
Install Icarus Verilog (`iverilog` and `vvp`) and run:
```bash
./scripts/run_sim.sh
```
The portable testbench is a directed smoke test, not a substitute for formal proof.

## Formal tool flow
The SVA file is a property module intended to be bound or instantiated with the FIFO. The exact VC Formal project setup and Tcl commands depend on the installed Synopsys release and site configuration. See `formal/README.md`; do not claim a formal pass until the properties have actually been run in the target tool.

## Bug-injection workflow
1. Prove or simulate the clean design first.
2. Select one bug variant at a time.
3. Run the same property set and record pass/fail.
4. Save a counterexample for every detected bug.
5. Fix the RTL and rerun regression.

## Evidence to add before publishing
- Tool/version and exact command lines used.
- Clean design proof summary.
- Bug-detection matrix with each bug, failed property, and root cause.
- Counterexample traces/screenshots (without proprietary or confidential data).
- Limitations and assumptions.

## Status
Starter repository. Simulation and property files should be validated with your installed tool versions before treating results as sign-off evidence.
