# Synchronous FIFO Verification Results

## Test Summary

| ID | Test | Result | Exit Code |
|---|---|---|---:|
| T1 | RTL simulation and scoreboard | PASS | 0 |
| T2 | Correct FIFO formal proof, depth 30 | PASS | 0 |
| T3 | Buggy FIFO formal detection, BMC depth 10 | EXPECTED FAIL | 2 |

## RTL Simulation Statistics

| Metric | Count |
|---|---:|
| Accepted writes | 276 |
| Accepted reads | 269 |
| Rejected writes | 1 |
| Rejected reads | 8 |

## Formal Verification Findings

- Correct FIFO: successful proof by k-induction at depth 30.
- Buggy FIFO: assertion failure at step 4.
- Counterexample: `formal/fifo_bug_full/engine_0/trace.vcd`
- Clock warning: undriven-clock warning remains; further review is needed.

## Log Files

- `simulation.log`
- `formal_fifo.log`
- `formal_bug_detection.log`

## Exit Codes

- `simulation.exitcode`
- `formal_fifo.exitcode`
- `formal_bug_detection.exitcode`
