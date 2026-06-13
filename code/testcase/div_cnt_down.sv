class div_cnt_down extends base_test;
    function new();
        super.new();
    endfunction

    virtual task run_scenario();
        time t1, t2;     
        $display("================================");
        $display("==TEST 1: COUNTDOWN - NO DIV ===");
        $display("================================");

        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;

        write(8'h02, 8'hFF);      // write to TDR: load value 0xFF (255)
        write(8'h00, 8'h04);      // write to TCR: set LOAD bit
        write(8'h03, 8'h02);      // write to TIE: enable underflow interrupt (TIE[1]=1)
        #100;
        write(8'h00, 8'h03);      // write to TCR: enable counting down, clk_div=00 (no divide)

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        $display("%0t: [div_cnt_down] TEST1: Started counting DOWN from 0xFF with no divide at t1=%0t", $time, t1);
        
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        $display("%0t: [div_cnt_down] TEST1: Underflow interrupt detected at t2=%0t", $time, t2);
        
        if (t2 - t1 >= (256*5 - 20)*1000 && t2 - t1 <= (256*5 + 20)*1000) begin
            $display("%0t: [div_cnt_down] TEST PASSED 1: Counter interrupt timing is correct (delta=%0t ps)", $time, t2-t1);
        end else begin
            $display("%0t: [div_cnt_down] TEST FAILED 1: Timing incorrect. Expected [%0d, %0d]ps, got %0t ps", $time, (256*5-20)*1000, (256*5+20)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting

        $display("================================");
        $display("==TEST 2: COUNTDOWN - DIV BY 2 =");
        $display("================================");
        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        
        write(8'h02, 8'hFF);      // write to TDR: load value 0xFF
        write(8'h00, 8'h04);      // write to TCR: set LOAD bit
        write(8'h03, 8'h02);      // write to TIE: enable underflow interrupt
        #100;
        write(8'h00, 8'h0B);      // write to TCR: enable counting down with clk_div=01 (divide by 2)

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        $display("%0t: [div_cnt_down] TEST2: Started counting DOWN from 0xFF with divide by 2 at t1=%0t", $time, t1);
        
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        $display("%0t: [div_cnt_down] TEST2: Underflow interrupt detected at t2=%0t", $time, t2);
        
        if (t2 - t1 >= (256*5*2 - 26)*1000 && t2 - t1 <= (256*5*2 + 26)*1000) begin
            $display("%0t: [div_cnt_down] TEST PASSED 2: Counter interrupt timing is correct (delta=%0t ps)", $time, t2-t1);
        end else begin
            $display("%0t: [div_cnt_down] TEST FAILED 2: Timing incorrect. Expected [%0d, %0d]ps, got %0t ps", $time, (256*5*2-26)*1000, (256*5*2+26)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting

        $display("================================");
        $display("==TEST 3: COUNTDOWN - DIV BY 4 =");
        $display("================================");
        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        
        write(8'h02, 8'hFF);      // write to TDR: load value 0xFF
        write(8'h00, 8'h04);      // write to TCR: set LOAD bit
        write(8'h03, 8'h02);      // write to TIE: enable underflow interrupt
        #100;
        write(8'h00, 8'h13);      // write to TCR: enable counting down with clk_div=10 (divide by 4)

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        $display("%0t: [div_cnt_down] TEST3: Started counting DOWN from 0xFF with divide by 4 at t1=%0t", $time, t1);
        
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        $display("%0t: [div_cnt_down] TEST3: Underflow interrupt detected at t2=%0t", $time, t2);
        
        if (t2 - t1 >= (256*5*4 - 51)*1000 && t2 - t1 <= (256*5*4 + 51)*1000) begin
            $display("%0t: [div_cnt_down] TEST PASSED 3: Counter interrupt timing is correct (delta=%0t ps)", $time, t2-t1);
        end else begin
            $display("%0t: [div_cnt_down] TEST FAILED 3: Timing incorrect. Expected [%0d, %0d]ps, got %0t ps", $time, (256*5*4-51)*1000, (256*5*4+51)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting

        $display("================================");
        $display("==TEST 4: COUNTDOWN - DIV BY 8 =");
        $display("================================");
        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        
        write(8'h02, 8'hFF);      // write to TDR: load value 0xFF
        write(8'h00, 8'h04);      // write to TCR: set LOAD bit
        write(8'h03, 8'h02);      // write to TIE: enable underflow interrupt
        #100;
        write(8'h00, 8'h1B);      // write to TCR: enable counting down with clk_div=11 (divide by 8)

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        $display("%0t: [div_cnt_down] TEST4: Started counting DOWN from 0xFF with divide by 8 at t1=%0t", $time, t1);
        
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        $display("%0t: [div_cnt_down] TEST4: Underflow interrupt detected at t2=%0t", $time, t2);
        
        if (t2 - t1 >= (256*5*8 - 102)*1000 && t2 - t1 <= (256*5*8 + 102)*1000) begin
            $display("%0t: [div_cnt_down] TEST PASSED 4: Counter interrupt timing is correct (delta=%0t ps)", $time, t2-t1);
        end else begin
            $display("%0t: [div_cnt_down] TEST FAILED 4: Timing incorrect. Expected [%0d, %0d]ps, got %0t ps", $time, (256*5*8-102)*1000, (256*5*8+102)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting

    endtask

endclass
