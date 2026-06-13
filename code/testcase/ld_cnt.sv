class ld_cnt extends base_test;
    function new();
        super.new();
    endfunction

    virtual task run_scenario();
        time t1, t2, delta;
        $display("============================");
        $display("=====Load Count CHECK======");
        $display("============================");

        dut_vif.presetn = 1'b0; #10;
        dut_vif.presetn = 1'b1; #10;
        
        // Sequence from spec:
        // 1. Enable overflow interrupt and start counting up
        // 2. Wait 5 ker_clk cycles
        // 3. Load 0xF0 (240) to TDR and set LOAD bit
        // 4. Clear LOAD bit and capture time t1
        // 5. Wait for interrupt (overflow at 255→0)
        // 6. Counter 240→255 = 15 cycles × 5ns = 75ns
        
        write(8'h03, 8'h01);      // Write TIE: enable overflow interrupt (TIE[0]=1)
        write(8'h00, 8'h01);      // Write TCR: enable count up (TCR[0]=1, no direction)
        
        repeat(5) @(posedge dut_vif.ker_clk); #1;  // Wait 5 cycles for counter to start
        
        write(8'h02, 8'hF0);      // Write TDR: load value = 0xF0 (240)
        write(8'h00, 8'h05);      // Write TCR: set LOAD bit (TCR[2]=1, keep enable)
        #100;                     // Wait for load to propagate
        write(8'h00, 8'h01);      // Write TCR: clear LOAD bit (TCR[2]=0, keep counting)
        
        @(posedge dut_vif.ker_clk);
        t1 = $time;              // Capture t1: start timing after LOAD is cleared
        $display("%0t: [ld_cnt] Counter loaded with 0xF0(240), timing started at t1=%0t", $time, t1);
        
        wait(dut_vif.int_signal == 1'b1);  // Wait for overflow interrupt
        t2 = $time;              // Capture t2: overflow detected
        delta = t2 - t1;
        $display("%0t: [ld_cnt] Overflow interrupt detected at t2=%0t, delta=%0t ps", $time, t2, delta);
        
        // After loading 0xF0 (240), counter counts up from 240 to 255
        // Counter increments: 240→241→...→255 (16 increments = 15 clock cycles)
        // At 5ns per cycle: 16 * 5ns = 80ns expected
        // Timing window: 80ns ± 1% = [79.2ns, 80.8ns] = [79200ps, 80800ps]
        if (delta >= (16*5 - 20)*1000 && delta <= (16*5 + 20)*1000) begin
            $display("%0t: [ld_cnt] TEST PASSED: Load count overflow timing is correct (delta=%0t ps = %0.1f ns)", $time, delta, delta/1000.0);
        end else begin
            $display("%0t: [ld_cnt] TEST FAILED: Timing outside window. Expected [79200, 80800]ps, got %0t ps", $time, delta);
        end
        
        write(8'h00, 8'h00);      // Disable counting

    endtask
endclass