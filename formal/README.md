# Formal setup notes

`fifo_properties.sv` is an assertion checker. To use it, expose the internal
pointer signals to the checker by binding it to `sync_fifo`, or add checker
ports/instances in a formal-only wrapper. A representative bind (adapt module
paths and parameters to your project) is:

```systemverilog
bind sync_fifo fifo_properties #(
  .DEPTH(DEPTH),
  .COUNT_WIDTH(COUNT_WIDTH),
  .PTR_WIDTH(PTR_WIDTH)
) u_fifo_properties (
  .clk(clk), .rst_n(rst_n),
  .wr_en(wr_en), .rd_en(rd_en),
  .full(full), .empty(empty), .count(count),
  .wr_ptr(wr_ptr), .rd_ptr(rd_ptr)
);
```

Tool-specific project and Tcl commands vary by Synopsys VC Formal version and
site setup. Start from the VC Formal examples installed with your licensed
release, compile `rtl/sync_fifo.sv` and the checker, select the FIFO as the
top, and configure reset/clock handling. Check that assertions are discovered
and that the clean design proves before injecting faults.

Important:
- Do not constrain `wr_en` or `rd_en` so heavily that the bugs become unreachable.
- Keep reset assumptions consistent with the synchronous reset implementation.
- A passing local invariant set does not prove FIFO data ordering. Add a formal
  reference queue/ghost model or complementary simulation scoreboard.
- Save the exact tool version, run command, proof summary, and counterexample.
