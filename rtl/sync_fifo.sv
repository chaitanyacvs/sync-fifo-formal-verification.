module sync_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 16,
    parameter int PTR_WIDTH  = $clog2(DEPTH),
    parameter int COUNT_WIDTH = $clog2(DEPTH + 1)
) (
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic                  wr_en,
    input  logic [DATA_WIDTH-1:0] wr_data,
    input  logic                  rd_en,
    output logic [DATA_WIDTH-1:0] rd_data,
    output logic                  full,
    output logic                  empty,
    output logic [COUNT_WIDTH-1:0] count
);

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    logic [PTR_WIDTH-1:0]  wr_ptr;
    logic [PTR_WIDTH-1:0]  rd_ptr;

    logic do_write;
    logic do_read;

    // This starter implementation assumes DEPTH is a power of two and >= 2.
    initial begin
        if (DEPTH < 2) $error("DEPTH must be >= 2");
        if ((2**PTR_WIDTH) != DEPTH)
            $error("This starter FIFO requires power-of-two DEPTH");
    end

    always_comb begin
        empty = (count == 0);
        full  = (count == DEPTH);
        do_write = wr_en && !full;
        do_read  = rd_en && !empty;
    end

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            wr_ptr  <= '0;
            rd_ptr  <= '0;
            count   <= '0;
            rd_data <= '0;
        end else begin
            if (do_write) begin
                mem[wr_ptr] <= wr_data;
                wr_ptr <= wr_ptr + 1'b1;
            end

            if (do_read) begin
                rd_data <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end

            unique case ({do_write, do_read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end
endmodule
