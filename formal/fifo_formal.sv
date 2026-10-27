module fifo_formal;

    localparam DATA_WIDTH = 8;
    localparam DEPTH = 4;
    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam COUNT_WIDTH = $clog2(DEPTH + 1);

    (* gclk *) reg clk;
    (* anyseq *) reg rst_n;
    (* anyseq *) reg wr_en;
    (* anyseq *) reg rd_en;
    (* anyseq *) reg [DATA_WIDTH-1:0] wr_data;

    wire [DATA_WIDTH-1:0] rd_data;
    wire full;
    wire empty;
    wire [COUNT_WIDTH-1:0] count;

    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .PTR_WIDTH(PTR_WIDTH),
        .COUNT_WIDTH(COUNT_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .wr_data(wr_data),
        .rd_en(rd_en),
        .rd_data(rd_data),
        .full(full),
        .empty(empty),
        .count(count)
    );

    reg past_valid = 1'b0;

    always @(posedge clk) begin
        past_valid <= 1'b1;

        // Begin in reset, then release it nondeterministically.
        if (!past_valid)
            assume (!rst_n);

        if (past_valid && rst_n) begin
            assert (count <= DEPTH);
            assert (empty == (count == 0));
            assert (full == (count == DEPTH));
        end
    end

endmodule
