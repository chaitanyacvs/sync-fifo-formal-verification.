// BUG-02 example: count increments for every write request, including when full.
// This variant uses the correct full flag but intentionally faulty count logic.
module fifo_bug_count #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH = 16,
    parameter int PTR_WIDTH = $clog2(DEPTH),
    parameter int COUNT_WIDTH = $clog2(DEPTH + 1)
) (
    input logic clk, rst_n, wr_en,
    input logic [DATA_WIDTH-1:0] wr_data,
    input logic rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic full, empty,
    output logic [COUNT_WIDTH-1:0] count
);
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [PTR_WIDTH-1:0] wr_ptr, rd_ptr;
    logic do_write, do_read;

    always_comb begin
        empty = (count == 0);
        full = (count == DEPTH);
        do_write = wr_en && !full;
        do_read = rd_en && !empty;
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr <= '0; rd_ptr <= '0; count <= '0; rd_data <= '0;
        end else begin
            if (do_write) begin mem[wr_ptr] <= wr_data; wr_ptr <= wr_ptr + 1'b1; end
            if (do_read) begin rd_data <= mem[rd_ptr]; rd_ptr <= rd_ptr + 1'b1; end

            // INJECTED BUG: raw wr_en used instead of accepted do_write.
            case ({wr_en, do_read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                2'b11: count <= count;
                default: count <= count;
            endcase
        end
    end
endmodule
