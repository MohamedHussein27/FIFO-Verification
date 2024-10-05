interface fifo_if (clk);
    input clk;

    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    
    // signals
    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;

    // dut module 
    modport DUT (
        input clk, data_in, rst_n, wr_en, rd_en,
        output data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );
    // test module
    modport TEST (
        output data_in, rst_n, wr_en, rd_en,
        input clk, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );
    // monitor module
    modport MONITOR (
        input clk, data_in, rst_n, wr_en, rd_en, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow
    );
endinterface