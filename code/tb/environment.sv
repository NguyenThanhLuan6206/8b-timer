class environment;
  mailbox #(packet) s2d_mb;
  mailbox #(packet) m2s_mb;
  virtual dut_if dut_vif;

  stimulus stim;
  driver drv;
  monitor mnt;
  scoreboard scrb;

  event xfer_done;

  function new(virtual dut_if dut_vif);
    this.dut_vif = dut_vif;
  endfunction

  function void build();
    $display("%0t: [ENV] Build environment", $time);
    s2d_mb = new();
    m2s_mb = new();

    stim = new(s2d_mb, xfer_done);
    drv = new(dut_vif, s2d_mb, xfer_done);
    mnt = new(dut_vif, m2s_mb);
    scrb = new(m2s_mb);
  endfunction

  task run();
    $display("%0t: [ENV] Start running environment", $time);
    fork
      stim.run();
      drv.run();
      mnt.run();
      scrb.run();
    join_none
  endtask
endclass
