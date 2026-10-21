`timescale 1ns/1ps
module fifo_tb;
    localparam int DATA_WIDTH = 8;
    localparam int DEPTH = 16;
    localparam int COUNT_WIDTH = $clog2(DEPTH + 1);

    logic clk = 0;
    logic rst_n = 0;
    logic wr_en = 0, rd_en = 0;
    logic [DATA_WIDTH-1:0] wr_data = 0;
    logic [DATA_WIDTH-1:0] rd_data;
    logic full, empty;
    logic [COUNT_WIDTH-1:0] count;

    always #5 clk = ~clk;

    sync_fifo #(.DATA_WIDTH(DATA_WIDTH), .DEPTH(DEPTH)) dut (.*);

    task automatic tick;
        @(posedge clk);
        #1;
    endtask

    initial begin
        repeat (2) tick();
        rst_n = 1;
        tick();
        if (!empty || full || count != 0) $fatal(1, "Reset/empty check failed");

        // Fill to capacity.
        for (int i = 0; i < DEPTH; i++) begin
            @(negedge clk);
            wr_en = 1; rd_en = 0; wr_data = i;
            tick();
        end
        @(negedge clk); wr_en = 0;
        if (!full || count != DEPTH) $fatal(1, "Full check failed");

        // A write while full must be rejected.
        @(negedge clk); wr_en = 1; wr_data = 8'hEE;
        tick();
        @(negedge clk); wr_en = 0;
        if (!full || count != DEPTH) $fatal(1, "Full-write rejection failed");

        // Read all items in FIFO order.
        for (int i = 0; i < DEPTH; i++) begin
            @(negedge clk); rd_en = 1;
            tick();
            if (rd_data !== i[DATA_WIDTH-1:0])
                $fatal(1, "Data mismatch at item %0d: got %0h", i, rd_data);
        end
        @(negedge clk); rd_en = 0;
        if (!empty || count != 0) $fatal(1, "Empty check failed");

        $display("PASS: directed FIFO smoke test");
        $finish;
    end
endmodule
