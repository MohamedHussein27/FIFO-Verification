package fifo_transaction_pkg;
    import shared_pkg::*;
    class FIFO_transaction;
        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;
        bit clk;
        rand bit [FIFO_WIDTH-1:0] data_in;
        rand bit rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;

        // integers
        int RD_EN_ON_DIST;
        int WR_EN_ON_DIST;

        // constructor for integers
        function new(int RD = 30, int WR = 70);
            RD_EN_ON_DIST = RD;
            WR_EN_ON_DIST = WR;
        endfunction

        // constraints
        constraint reset_con {
            rst_n dist {0:/2, 1:/98};  // reset is asserted less 
        }

        constraint wr_en_con {
            wr_en dist {1:=WR_EN_ON_DIST, 0:=(100 - WR_EN_ON_DIST)}; // wr_en has probability of WR_EN_ON_DIST to happen
        }

        constraint rd_en_con {
            rd_en dist {1:=RD_EN_ON_DIST, 0:=(100 - RD_EN_ON_DIST)}; // rd_en has probability of RD_EN_ON_DIST to happen
        }
    endclass
endpackage 
