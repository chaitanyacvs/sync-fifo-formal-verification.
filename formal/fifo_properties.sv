
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

    // 1. Occupancy and status invariants
    ap_count_in_range: assert property (
        disable iff (!rst_n)
        count <= DEPTH
    );

    ap_empty_matches_count: assert property (
        disable iff (!rst_n)
        empty == (count == 0)
    );

    ap_full_matches_count: assert property (
        disable iff (!rst_n)
        full == (count == DEPTH)
    );

    // 2. Pointer bounds
    ap_write_pointer_in_range: assert property (
        disable iff (!rst_n)
        wr_ptr < DEPTH
    );

    ap_read_pointer_in_range: assert property (
        disable iff (!rst_n)
        rd_ptr < DEPTH
    );

    // 3. Occupancy transition.
    // Acceptance uses the pre-edge flags, matching the RTL contract.
    ap_count_increments_on_write_only: assert property (
        disable iff (!rst_n)
        (wr_en && !full && !(rd_en && !empty))
        |=> count == $past(count) + 1'b1
    );

    ap_count_decrements_on_read_only: assert property (
        disable iff (!rst_n)
        (rd_en && !empty && !(wr_en && !full))
        |=> count == $past(count) - 1'b1
    );

    ap_count_stable_when_no_operation: assert property (
        disable iff (!rst_n)
        (!(wr_en && !full) && !(rd_en && !empty))
        |=> count == $past(count)
    );

    ap_count_stable_on_simultaneous_operations: assert property (
        disable iff (!rst_n)
        (wr_en && !full && rd_en && !empty)
        |=> count == $past(count)
    );

endmodule
