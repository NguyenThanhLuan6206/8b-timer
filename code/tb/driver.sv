class driver;
  mailbox #(packet) s2d_mb;
  virtual dut_if dut_vif;

  event xfer_done;

  function new(virtual dut_if dut_vif, mailbox #(packet) s2d_mb, event xfer_done);
    this.dut_vif = dut_vif;
    this.s2d_mb = s2d_mb;
    this.xfer_done = xfer_done;
  endfunction

  task run();
    packet pkt;
    while(1) begin
      s2d_mb.get(pkt);
      $display("%0t: [DRIVER] Start getting packet from STIMULUS", $time);

      @(posedge dut_vif.pclk);#1;
      dut_vif.paddr   <= pkt.addr;
      dut_vif.pwrite  <= (pkt.transfer == packet::WRITE);
      dut_vif.psel    <= 1'b1;
      if (pkt.transfer == packet::WRITE) dut_vif.pwdata <= pkt.data;

      @(posedge dut_vif.pclk);#1;
      dut_vif.penable <= 1'b1;

      wait(dut_vif.pready == 1'b1); #1;

      if (pkt.transfer == packet::READ) pkt.prdata = dut_vif.prdata;

      @(posedge dut_vif.pclk); #1;

      dut_vif.psel    <= 1'b0;
      dut_vif.penable <= 1'b0;
      dut_vif.pwrite  <= 1'b0;
      dut_vif.paddr   <= 8'h0;
      dut_vif.pwdata  <= 8'h0;

      -> xfer_done;
    end
  endtask
endclass
