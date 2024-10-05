package fifo_scoreboard_pkg;
    import fifo_transaction_pkg::*;
    import shared_pkg::*;
    class FIFO_scoreboard;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        // internal signals from the FIFO design module
        int count, write_p, read_p ; // count, write pointer, read pointer
        // reference signals
        logic [FIFO_WIDTH-1:0] data_out_ref;
        logic wr_ack_ref, overflow_ref;
        logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

        // queue to verify FIFO functionality
        reg [FIFO_WIDTH-1:0] queue_ref[$];


        // check data function to compare
        function void check_data (FIFO_transaction tr);
            reference_model(tr);
            // compare
            if (tr.data_out !== data_out_ref) begin
                error_count_out++;
                $display("error in data out at %0d", error_count_out);
            end
            else 
                correct_count_out++;
            if (tr.wr_ack !== wr_ack_ref) begin
                error_count_ack++;
                $display("error in ack at %0d", error_count_ack);
            end
            else 
                correct_count_ack++;
            if(tr.overflow !== overflow_ref) begin
                error_count_over++;
                $display("error in overflow at %0d", error_count_over);
            end
            else
                correct_count_over++;
            if(tr.full !== full_ref) begin
                error_count_full++;
                $display("error in full at %0d", error_count_full);
            end
            else
                correct_count_full++;
            if(tr.empty !== empty_ref) begin
                error_count_empty++;
                $display("error in empty at %0d", error_count_empty);
            end
            else
                correct_count_empty++;
            if(tr.almostfull !== almostfull_ref) begin
                error_count_almostfull++;
                $display("error in almostfull at %0d", error_count_almostfull);
            end
            else
                correct_count_almostfull++;
            if(tr.almostempty !== almostempty_ref) begin
                error_count_almostempty++;
                $display("error in almostempty at %0d", error_count_almostempty);
            end
            else
                correct_count_almostfull++;
            if(tr.underflow !== underflow_ref) begin
                error_count_under++;
                $display("error in underflow at %0d", error_count_under);
            end
            else
                correct_count_under++;
        endfunction
        // reference outputs
        function void reference_model (FIFO_transaction tr_ref);
            // assigning reference variables
            if(!tr_ref.rst_n) begin
                full_ref = 0;
                empty_ref = 1;
                queue_ref.delete();
                underflow_ref = 0;
                almostfull_ref = 0;
                almostempty_ref = 0;
                wr_ack_ref = 0;
                overflow_ref = 0;
                count = 0;
                write_p = 0;
                read_p = 0;
            end
            else begin
                // writing
                if (tr_ref.wr_en && count < FIFO_DEPTH) begin
                    queue_ref.push_back(tr_ref.data_in); // filling queue
                    wr_ack_ref = 1;
                end
                else begin
                    wr_ack_ref = 0;
                end

                // reading
                if (tr_ref.rd_en && count != 0) begin
                    data_out_ref = queue_ref.pop_front(); // evacuating queue
                end

                // sequential flags
                if(count == 0 && tr_ref.rd_en) underflow_ref = 1; else underflow_ref = 0;
                if(count == FIFO_DEPTH && tr_ref.wr_en) overflow_ref = 1; else overflow_ref = 0; 
                
                // count combinations
                if (({tr_ref.wr_en, tr_ref.rd_en} == 2'b11) && empty_ref)
                    count = count + 1;
                else if (({tr_ref.wr_en, tr_ref.rd_en} == 2'b11) && full_ref)
                    count = count - 1;
                else if (({tr_ref.wr_en, tr_ref.rd_en} == 2'b10) && !full_ref)
                    count = count + 1;
                else if (({tr_ref.wr_en, tr_ref.rd_en} == 2'b01) && !empty_ref)
                    count = count - 1;
                
                // flags
                if(count == FIFO_DEPTH) full_ref = 1; else full_ref = 0;
                if(count == 0) empty_ref = 1; else empty_ref = 0;      
                if(count == FIFO_DEPTH-1) almostfull_ref = 1; else almostfull_ref = 0;
                if(count == 1) almostempty_ref = 1; else almostempty_ref = 0;
            end
        endfunction
    endclass
endpackage

