interface dut_if;
    logic        ker_clk;     // APB Clock
    logic        pclk;        // APB Clock
    logic        presetn;     // Active-low reset
    logic [7:0]  paddr;       // APB Address
    logic        psel;        // APB Select
    logic        penable;     // APB Enable
    logic        pwrite;      // APB Write enable
    logic [7:0]  pwdata;      // APB Write data
    logic        pready;      // APB Ready signal
    logic [7:0]  prdata;      // APB Read data
    logic        int_signal;  // Interrupt signal
    logic        pslverr;     // APB Error signal

    initial begin
        ker_clk = 0;
        pclk = 0;
        presetn = 0;
        paddr = 8'h00;
        psel = 0;
        penable = 0;
        pwrite = 0;
        pwdata = 8'h00;
        pready = 0;
        prdata = 8'h00;
        int_signal = 0;
        pslverr = 0;
    end
endinterface
