# Formal Verification Results

## Toolchain
- Yosys 0.70+
- SymbiYosys v0.70
- Z3 4.15.4

## Correct FIFO
- Configuration: `formal/fifo.sby`
- Result: PASS
- Method: k-induction
- Assertions:
  - `count <= DEPTH`
  - `empty == (count == 0)`
  - `full == (count == DEPTH)`

## Injected full-flag bug
- Configuration: `formal/fifo_bug_full.sby`
- Result: FAIL (expected)
- Property violated: `full == (count == DEPTH)`
- Bug: `full` is asserted at `count == DEPTH-1`.
- Counterexample VCD: generated under `formal/fifo_bug_full/engine_0/trace.vcd`

The clean design passes the configured assertions, while the intentionally faulty full-flag variant produces a counterexample.
