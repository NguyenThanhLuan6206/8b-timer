class ld_cnt extends base_test;
    function new();
        super.new();
    endfunction

    virtual task run_scenario();
        time t1, t2, delta;
        test_count = 1;
        $display("============================");
        $display("=====Load Count CHECK======");
        $display("============================");

        dut_vif.presetn = 1'b0; #10;
        dut_vif.presetn = 1'b1; #10;
        
        // Sequence from spec:
        // 1. Enable overflow interrupt
        // 2. Load 0xF0 (240) to counter using TDR and LOAD bit
        // 3. Start counting and wait for interrupt (overflow at 255→0)
        // 4. Counter 240→255 = 15 cycles × 5ns + error = [75 - 20 ; 75 + 20] ns
        
        write(8'h03, 8'h01);     
        
        write(8'h02, 8'hF0);      // Write TDR: load value = 0xF0 (240)
        write(8'h00, 8'h04);      // Write TCR: set LOAD bit (TCR[2]=1, keep enable)
        #100;                   // Wait for load to propagate
        write(8'h00, 8'h01);      // Write TCR: start counting
        
        @(posedge dut_vif.ker_clk);
        t1 = $time;              // Capture t1: start timing after LOAD is cleared
        $display("%0t: [ld_cnt] Counter loaded with 0xF0(240), timing started at t1=%0t", $time, t1);
        
        wait(dut_vif.int_signal == 1'b1);  // Wait for overflow interrupt
        t2 = $time;              // Capture t2: overflow detected
        delta = t2 - t1;
        $display("%0t: [ld_cnt] Overflow interrupt detected at t2=%0t, delta=%0t ps", $time, t2, delta);
        
        if (delta >= (15*5 - 20)*1000 && delta <= (15*5 + 20)*1000) begin
            $display("%0t: [ld_cnt] PASS TEST: Load count overflow timing is correct (delta=%0t ps = %0.1f ns)", $time, delta, delta/1000.0);
            pass_count = pass_count + 1;
        end else begin
            $display("%0t: [ld_cnt] FAIL TEST: Timing outside window. Expected [79200, 80800]ps, got %0t ps", $time, delta);
        end
        
        write(8'h00, 8'h00);      // Disable counting

    endtask
endclass