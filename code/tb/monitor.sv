class monitor;
  mailbox #(packet) m2s_mb;
  virtual dut_if dut_vif;

  function new(virtual dut_if dut_vif, mailbox #(packet) m2s_mb);
    this.dut_vif = dut_vif;
    this.m2s_mb = m2s_mb;
  endfunction

  task run();
    packet pkt;
    while(1) begin
      wait(dut_vif.psel == 1'b1 && dut_vif.penable == 1'b1 && dut_vif.pready == 1'b1); #1;

      //$display("%0t: [MONITOR] Capture data from the pins", $time);
      pkt = new();
      pkt.addr = dut_vif.paddr;
      pkt.transfer = (dut_vif.pwrite == 1'b1) ? packet::WRITE : packet::READ;

      if (dut_vif.pwrite == 1'b1) pkt.data = dut_vif.pwdata;
      else pkt.prdata = dut_vif.prdata;

      pkt.int_signal = dut_vif.int_signal;

      m2s_mb.put(pkt);
    end
  endtask
endclass
