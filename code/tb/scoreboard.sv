class scoreboard;
  mailbox #(packet) m2s_mb;
  packet pkt;
  
  `include "coverage.sv"

  function new(mailbox #(packet) m2s_mb);
    this.m2s_mb = m2s_mb;
    APB_GROUP = new();
    apb_trans = new();
  endfunction

  task run();
    $display("%0t: [SCOREBOARD] Start running SCOREBOARD", $time);
    while(1) begin
      m2s_mb.get(pkt);
      //$display("%0t: [SCOREBOARD] Complete get packet from m2s_mb", $time);
      apb_sample_fc(pkt);
    end
  endtask

  function void apb_sample_fc(packet pkt);
    // Copy packet to apb_trans for coverage
    apb_trans.transfer = pkt.transfer;
    apb_trans.addr = pkt.addr;
    apb_trans.data = pkt.data;
    
    // Extract control signals from APB data
    extract_control_signals();
    
    // Sample coverage
    APB_GROUP.sample();
  endfunction


endclass
