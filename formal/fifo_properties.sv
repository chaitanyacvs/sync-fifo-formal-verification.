// Bind/instantiate this checker against sync_fifo.
// The checker verifies local invariants. Data ordering needs a scoreboard
// or a stronger ghost-state/reference-model property set.
module fifo_properties #(
    parameter int DEPTH = 16,
    parameter int COUNT_WIDTH = $clog2(DEPTH + 1),
    parameter int PTR_WIDTH = $clog2(DEPTH)
) (
    input logic clk,
    input logic rst_n,
    input logic wr_en,
    input logic rd_en,
    input logic full,
    input logic empty,
    input logic [COUNT_WIDTH-1:0] count,
    input logic [PTR_WIDTH-1:0] wr_ptr,
    input logic [PTR_WIDTH-1:0] rd_ptr
);
    default clocking cb @(posedge clk); endclocking

    // Reset is synchronous: assertions are disabled while reset is active.
    ap_count_in_range: assert property (disable iff (!rst_n)
        count <= DEPTH
    );

    ap_empty_matches_count: assert property (disable iff (!rst_n)
        empty == (count == 0)
    );

    ap_full_matches_count: assert property (disable iff (!rst_n)
        full == (count == DEPTH)
    );

    ap_write_pointer_in_range: assert property (disable iff (!rst_n)
        wr_ptr < DEPTH
    );

    ap_read_pointer_in_range: assert property (disable iff (!rst_n)
        rd_ptr < DEPTH
    );

    // If full, a write request must not increase occupancy unless a read
    // was also accepted. This checks the documented pre-edge acceptance rule.
    ap_rejected_write_no_count_increase: assert property (
        disable iff (!rst_n)
        (full && wr_en && !(rd_en && !empty))
        |=> count == $past(count)
    );

    // If empty, a read request is rejected unless a write is independently
    // accepted; under this contract the read remains rejected on that edge.
    ap_rejected_read_no_count_decrease: assert property (
        disable iff (!rst_n)
        (empty && rd_en)
        |=> count == $past(count) + (($past(wr_en) && !$past(full)) ? 1 : 0)
    );

endmodule
