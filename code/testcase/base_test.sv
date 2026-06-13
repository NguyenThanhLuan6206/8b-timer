class base_test;

  environment env;
  virtual dut_if dut_vif;
  int pass_count = 0;
  int test_count = 0;

  function new();
  endfunction

  function void build();
    env = new(dut_vif);
    env.build();
  endfunction

  virtual task run_scenario();
  endtask

  task run_test();
    build();
    fork
      env.run();
      run_scenario();
    join_any
    #1ms;
    
    // Print final test result
    if (pass_count == test_count && test_count > 0) begin
      $display("%0t: [TEST RESULT] TEST PASSED - All %0d tests passed", $time, test_count);
    end else begin
      $display("%0t: [TEST RESULT] TEST FAILED - %0d/%0d tests passed", $time, pass_count, test_count);
    end
    
    $display("%0t: [base_test] End simulation",$time);
    $finish;
  endtask


  task write(bit [7:0] addr, bit [7:0] data);
    packet pkt;
    $display("%0t: [BASE] Start calling write task", $time);
    pkt = new();
    pkt.addr = addr;
    pkt.data = data;
    pkt.transfer = packet::WRITE;

    $display("%0t: [BASE] Start sending packet", $time);
    env.stim.send_pkt(pkt);

    @(env.xfer_done);
    $display("%0t: [BASE] Done write task", $time);
  endtask

  task read(bit [7:0] addr, output bit [7:0] data);
    packet pkt;
    $display("%0t: [BASE] Start calling read task", $time);
    pkt = new();
    pkt.addr = addr;
    pkt.transfer = packet::READ;

    $display("%0t: [BASE] Start sending packet", $time);
    env.stim.send_pkt(pkt);

    @(env.xfer_done);
    data = pkt.prdata;
    $display("%0t: [BASE] Done read task", $time);
  endtask

  task compare(bit[7:0] addr, bit [7:0] exp);
    bit [7:0] prdata;
    read(addr, prdata);
    if (prdata === exp) begin
      pass_count++;
      $display("%0t: [COMPARATOR] PASS at %0h", $time, addr);
    end
    else begin
      $display("%0t: [COMPARATOR] FAIL at %0h, actual: %0h, exp: %0h", $time, addr, prdata, exp);
    end
  endtask
endclass
