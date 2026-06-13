class stimulus;
  mailbox #(packet) s2d_mb;
  event xfer_done;
  packet pkt_q[$];

  function new(mailbox #(packet) s2d_mb, event xfer_done);
    this.s2d_mb = s2d_mb;
    this.xfer_done = xfer_done;
  endfunction

  task send_pkt(packet pkt);
    pkt_q.push_back(pkt);
  endtask

  task run();
    packet pkt;
    $display("%0t: [STIMULUS] Start running STIMULUS", $time);
    while(1) begin
      wait(pkt_q.size() > 0);
      pkt = pkt_q.pop_front();

      $display("%0t: [STIMULUS] Sent packet to driver", $time);
      s2d_mb.put(pkt);

      @(xfer_done); #1;
    end
  endtask
endclass
