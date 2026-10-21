#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mkdir -p "$ROOT/build"
iverilog -g2012 -s fifo_tb \
  -o "$ROOT/build/fifo_tb.vvp" \
  "$ROOT/rtl/sync_fifo.sv" \
  "$ROOT/simulation/fifo_tb.sv"
vvp "$ROOT/build/fifo_tb.vvp"
