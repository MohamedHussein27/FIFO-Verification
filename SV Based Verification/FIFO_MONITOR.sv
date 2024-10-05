import fifo_transaction_pkg::*;
import fifo_coverage_pkg::*;
import fifo_scoreboard_pkg::*;
import shared_pkg::*;
module fifo_monitor (fifo_if.MONITOR fifoif);
    FIFO_transaction tr_mon = new; // transaction object
    FIFO_coverage cov_mon = new; // coverage object
    FIFO_scoreboard scb_mon = new; // scoreboard object

    initial begin
        forever begin
            #20; // negedge
            // assigning interface data to class transaction object
            tr_mon.data_in = fifoif.data_in;
            tr_mon.rst_n = fifoif.rst_n;
            tr_mon.wr_en = fifoif.wr_en;
            tr_mon.rd_en = fifoif.rd_en;
            tr_mon.data_out = fifoif.data_out;
            tr_mon.wr_ack = fifoif.wr_ack;
            tr_mon.overflow = fifoif.overflow;
            tr_mon.full = fifoif.full;
            tr_mon.empty = fifoif.empty;
            tr_mon.almostfull = fifoif.almostfull;
            tr_mon.almostempty = fifoif.almostempty;
            tr_mon.underflow = fifoif.underflow;
            // two parallel processes
            fork
                // process 1
                cov_mon.sample_data(tr_mon);
                // process 2
                scb_mon.check_data(tr_mon); 
            join
            if (test_finished) begin
                $display("error count = %0d, correct count = %0d", error_count_out, correct_count_out);
                $stop;
            end
        end
    end
endmodule
        