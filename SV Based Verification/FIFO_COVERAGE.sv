package fifo_coverage_pkg;
    import fifo_transaction_pkg::*;
    import shared_pkg::*;
    class FIFO_coverage;
        // fifo_transaction class object
        FIFO_transaction F_cvg_txn = new;


        // cover group
        covergroup FIFO_Cross_Group; // all crosses will be with read enable and write enable and each one of the output signals
            // cover points
            cp_wr_en: coverpoint F_cvg_txn.wr_en;
            cp_rd_en: coverpoint F_cvg_txn.rd_en;
            cp_ack: coverpoint F_cvg_txn.wr_ack;
            cp_overflow: coverpoint F_cvg_txn.overflow;
            cp_full: coverpoint F_cvg_txn.full;
            cp_empty: coverpoint F_cvg_txn.empty;
            cp_almostfull: coverpoint F_cvg_txn.almostfull;
            cp_almostempty: coverpoint F_cvg_txn.almostempty; 
            cp_underflow: coverpoint F_cvg_txn.underflow;
            // cross coverage
            wr_ack_C: cross cp_wr_en, cp_rd_en, cp_ack{
                illegal_bins zero_zero_one = binsof(cp_wr_en) intersect {0} && binsof(cp_ack) intersect {1}; 
            } // cross coverage for wr_ack, note that a wr_ack can't be done if the wr_en is zero so i made this case illegal
            overflow_C: cross cp_wr_en, cp_rd_en, cp_overflow{
                illegal_bins zero_w_one = binsof(cp_wr_en) intersect {0} && binsof(cp_overflow) intersect {1}; 
            } // cross coverage for overflow, note that an overflow can't be done if there is no wr_en, so i made it illegal
            full_C: cross cp_wr_en, cp_rd_en, cp_full{
                illegal_bins one_r_one = binsof(cp_rd_en) intersect {1} && binsof(cp_full) intersect {1}; 
            } // cross coverage for full, note that a full signal can't be riased if there is read process, so i made it illegal
            empty_C: cross cp_wr_en, cp_rd_en, cp_empty; // cross coverage for empty
            almostfull_C: cross cp_wr_en, cp_rd_en, cp_almostfull; // cross coverage for almostfull signal
            almostempty_C: cross cp_wr_en, cp_rd_en, cp_almostempty; // cross coverage for almostempty signal
            underflow_C: cross cp_wr_en, cp_rd_en, cp_underflow{
                illegal_bins zero_r_one = binsof(cp_rd_en) intersect {0} && binsof(cp_underflow) intersect {1};
            } // cross coverage for underflow signal, note that an underflow can't be done if no read operation occurs, so i made it illegal
        endgroup

        // void function
        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            FIFO_Cross_Group.sample();
        endfunction

        function new();
            FIFO_Cross_Group = new();
        endfunction
    endclass
endpackage


