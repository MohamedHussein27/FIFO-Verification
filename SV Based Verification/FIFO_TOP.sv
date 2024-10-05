module fifo_top();
    bit clk;

    // clock generation
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // interface
    fifo_if fifoif (clk);
    // dut
    FIFO dut (fifoif);
    // test
    fifo_tb tb (fifoif);
    // monitor
    fifo_monitor MONITOR (fifoif);
endmodule