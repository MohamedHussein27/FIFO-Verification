import fifo_transaction_pkg::*;
import shared_pkg::*;
module fifo_tb (fifo_if.TEST fifoif);
    parameter FIFO_WIDTH = 16;
    parameter FIFO_DEPTH = 8;
    logic clk;
    logic [FIFO_WIDTH-1:0] data_in;
    logic rst_n, wr_en, rd_en;
    logic [FIFO_WIDTH-1:0] data_out;
    logic wr_ack, overflow;
    logic full, empty, almostfull, almostempty, underflow;
    // assigning signals to be interfaced
    // inputs
    assign clk = fifoif.clk;
    assign data_out = fifoif.data_out;
    assign wr_ack = fifoif.wr_ack;
    assign overflow = fifoif.overflow;
    assign full = fifoif.full;
    assign empty = fifoif.empty;
    assign almostfull = fifoif.almostfull;
    assign almostempty = fifoif.almostempty;
    assign underflow = fifoif.underflow;
    // outputs
    assign fifoif.data_in = data_in;
    assign fifoif.rst_n = rst_n;
    assign fifoif.wr_en = wr_en;
    assign fifoif.rd_en = rd_en;

    // class object
    FIFO_transaction tr_tb = new;
    
    // stimulus
    initial begin
        // reset label 
        rst_n = 0;
        #20;
        rst_n = 1;
        repeat(1000) begin
            assert(tr_tb.randomize());
            //getting randomized variables
            data_in = tr_tb.data_in;
            rst_n = tr_tb.rst_n;
            wr_en = tr_tb.wr_en;
            rd_en = tr_tb.rd_en;
            #20;
        end
        test_finished = 1;
    end
endmodule
