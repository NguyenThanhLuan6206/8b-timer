class std_cnt extends base_test;
  
  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    time t1, t2;
    test_count = 4; 
    
    // ========== TEST 1: COUNT UP ==========
    dut_vif.presetn = 0; #1ns;
    dut_vif.presetn = 1; #1ns;
    $display("====TEST 1: standard counting up check====");
    
    write(8'h03, 8'h01); // TIE[0]=1: enable overflow interrupt
    write(8'h00, 8'h01); // TCR: enable counting up (bit[0]=1, bit[1]=0, clk_div=00)
    
    t1 = $time;
    $display("%0t: [std_cnt] TEST1: Started counting UP from t1=%0t", $time, t1);
    
    wait(dut_vif.int_signal == 1);
    t2 = $time;
    $display("%0t: [std_cnt] TEST1: Overflow interrupt asserted at t2=%0t", $time, t2);
    
    if (t2 - t1 >= (256*5 - 20)*1000 && t2 - t1 <= (256*5 + 20)*1000) begin
      $display("%0t: [std_cnt] PASS TEST 1: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
      pass_count = pass_count + 1;
    end else begin
      $display("%0t: [std_cnt] FAIL TEST 1: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (256*5 + 20)*1000, t2-t1);
    end
    
    write(8'h00, 8'h00); // disable counting

    // ========== TEST 2: COUNT DOWN ==========
    dut_vif.presetn = 0; #1ns;
    dut_vif.presetn = 1; #1ns;
    $display("====TEST 2: standard counting down check====");
    
    write(8'h03, 8'h02); // TIE[1]=1: enable underflow interrupt
    write(8'h02, 8'hFF); // TDR: load 0xFF as initial value
    write(8'h00, 8'h04); // TCR: load to 0x00 - set LOAD bit to load TDR into counter
    write(8'h00, 8'h03); // TCR: enable counting down (bit[0]=1, bit[1]=1, clk_div=00)
    
    t1 = $time;
    $display("%0t: [std_cnt] TEST2: Started counting DOWN from 0xFF at t1=%0t", $time, t1);
    
    wait(dut_vif.int_signal == 1);
    t2 = $time;
    $display("%0t: [std_cnt] TEST2: Underflow interrupt asserted at t2=%0t", $time, t2);
    
    if (t2 - t1 >= (256*5 - 20)*1000 && t2 - t1 <= (256*5 + 20)*1000) begin
      $display("%0t: [std_cnt] PASS TEST 2: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
      pass_count = pass_count + 1;
    end else begin
      $display("%0t: [std_cnt] FAIL TEST 2: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (256*5 + 20)*1000, t2-t1);
    end
    
    write(8'h00, 8'h00); // disable counting

    // ========== TEST 3: COUNT UP from 100 (0x64) ==========
    // Sequence: Write 8'd100 to 0x02 && load to 0x00 && write 8'h1 to 0x03 && 8'h01 to 0x00 && store t1 && wait TSR.overflow && store t2
    dut_vif.presetn = 0; #1ns;
    dut_vif.presetn = 1; #1ns;
    $display("====TEST 3: count up from 100 check====");
    
    write(8'h03, 8'h01);      // TIE: write 8'h1 - enable overflow interrupt
    write(8'h02, 8'd100);     // TDR: Write 8'd100 (0x64) to load as initial value
    write(8'h00, 8'h04);      // TCR: load to 0x00 - set LOAD bit to load TDR into counter
    write(8'h00, 8'h01);      // TCR: write 8'h01 - enable counting up
    
    t1 = $time;
    $display("%0t: [std_cnt] TEST3: Started counting UP from 100 at t1=%0t", $time, t1);
    
    wait(dut_vif.int_signal == 1);
    t2 = $time;
    $display("%0t: [std_cnt] TEST3: Overflow interrupt asserted at t2=%0t", $time, t2);
    
    // Expected: 256 - 100 = 156 cycles
    // Time = 156 * 5ns = 780ns + margin (±1% = ±8ns)
    if (t2 - t1 >= (156*5 - 20)*1000 && t2 - t1 <= (156*5 + 20)*1000) begin
      $display("%0t: [std_cnt] PASS TEST 3: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
      pass_count = pass_count + 1;
    end else begin
      $display("%0t: [std_cnt] FAIL TEST 3: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (156*5 + 20)*1000, t2-t1);
    end
    
    write(8'h00, 8'h00); // disable counting

    // ========== TEST 4: COUNT DOWN from 100 (0x64) ==========
    // Sequence: Write 8'd100 to 0x02 && load to 0x00 && write 8'h1 to 0x03 && 8'h01 to 0x00 && store t1 && wait TSR.overflow && store t2
    dut_vif.presetn = 0; #1ns;
    dut_vif.presetn = 1; #1ns;
    $display("====TEST 4: count down from 100 check====");
    
    write(8'h03, 8'h02);      // TIE: write 8'h2 - enable underflow interrupt
    write(8'h02, 8'd100);     // TDR: Write 8'd100 (0x64) to load as initial value
    write(8'h00, 8'h04);      // TCR: load to 0x00 - set LOAD bit to load TDR into counter
    write(8'h00, 8'h03);      // TCR: write 8'h03 - enable counting down
    
    t1 = $time;
    $display("%0t: [std_cnt] TEST4: Started counting DOWN from 100 at t1=%0t", $time, t1);
    
    wait(dut_vif.int_signal == 1);
    t2 = $time;
    $display("%0t: [std_cnt] TEST4: Underflow interrupt asserted at t2=%0t", $time, t2);
    
    // Expected: 100 cycles
    // Time = 100 * 5ns = 500ns + margin (±1% = ±5ns)
    if (t2 - t1 >= (100*5 - 20)*1000 && t2 - t1 <= (100*5 + 20)*1000) begin
      $display("%0t: [std_cnt] PASS TEST 4: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
      pass_count = pass_count + 1;
    end else begin
      $display("%0t: [std_cnt] FAIL TEST 4: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (100*5 + 20)*1000, t2-t1);
    end
    
    write(8'h00, 8'h00); // disable counting
  endtask
endclass