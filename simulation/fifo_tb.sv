
`timescale 1ns/1ps

module fifo_tb;

    localparam DATA_WIDTH = 8;
    localparam DEPTH = 16;
    localparam COUNT_WIDTH = $clog2(DEPTH + 1);

    logic clk = 0;
    logic rst_n = 0;
    logic wr_en = 0, rd_en = 0;
    logic [DATA_WIDTH-1:0] wr_data = 0;
    logic [DATA_WIDTH-1:0] rd_data;
    logic full, empty;
    logic [COUNT_WIDTH-1:0] count;

    byte unsigned expected_queue[$];

    int accepted_writes = 0;
    int accepted_reads = 0;
    int rejected_writes = 0;
    int rejected_reads = 0;

    always #5 clk = ~clk;

    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .wr_en(wr_en), .wr_data(wr_data),
        .rd_en(rd_en), .rd_data(rd_data),
        .full(full), .empty(empty), .count(count)
    );

    task automatic step;
        bit do_wr, do_rd;
        logic [DATA_WIDTH-1:0] expected_data;


        // Acceptance is determined from the pre-edge FIFO status.
        do_wr = wr_en && !full;
        do_rd = rd_en && !empty;

        if (do_rd)
            expected_data = expected_queue.pop_front();

        @(posedge clk);
        #1;

        if (do_rd) begin
            if (rd_data !== expected_data)
                $fatal(1, "DATA ERROR: expected=%0h actual=%0h",
                       expected_data, rd_data);
            accepted_reads++;
        end else if (rd_en && empty) begin
            rejected_reads++;
        end

        if (do_wr) begin
            expected_queue.push_back(wr_data);
            accepted_writes++;
        end else if (wr_en && full) begin
            rejected_writes++;
        end

        if (count !== expected_queue.size())
            $fatal(1, "COUNT ERROR: DUT=%0d expected=%0d",
                   count, expected_queue.size());

        if (empty !== (expected_queue.size() == 0))
            $fatal(1, "EMPTY FLAG ERROR");

        if (full !== (expected_queue.size() == DEPTH))
            $fatal(1, "FULL FLAG ERROR");
    endtask

    initial begin
        // Reset
        repeat (2) @(posedge clk);
        @(negedge clk);
        rst_n = 1;

        // Fill the FIFO.
        for (int i = 0; i < DEPTH; i++) begin
            wr_en = 1;
            rd_en = 0;
            wr_data = i;
            step();
        end

        // Try writing when full.
        wr_en = 1;
        rd_en = 0;
        wr_data = 8'hEE;
        step();

        // Drain and check ordering.
        wr_en = 0;
        rd_en = 1;
        repeat (DEPTH) step();

        // Try reading when empty.
        wr_en = 0;
        rd_en = 1;
        step();

        // Randomized mixed traffic.
        for (int i = 0; i < 500; i++) begin
            wr_en = $urandom_range(0, 1);
            rd_en = $urandom_range(0, 1);
            wr_data = $urandom_range(0, 255);
            step();
        end

        $display("PASS: FIFO scoreboard test");
        $display("Accepted writes: %0d", accepted_writes);
        $display("Accepted reads: %0d", accepted_reads);
        $display("Rejected writes: %0d", rejected_writes);
        $display("Rejected reads: %0d", rejected_reads);
        $finish;
    end

endmodule
