class div_cnt extends base_test;
    function new();
        super.new();
    endfunction

    task run_scenario();
        time t1, t2;     
        test_count = 4;
        $display("==============================");
        $display("==TEST 1: DIVIDED BY 0 CHECK==");
        $display("==============================");

        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;

        write(8'h03, 8'h01); // TIE[0]=1: enable overflow interrupt
        write(8'h00, 8'h01); // TCR: enable counting up with clk_div=00 (divide by 1)

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        if (t2 - t1 >= (256*5 - 20)*1000 && t2 - t1 <= (256*5 + 20)*1000) begin
            $display("%0t: [div_cnt] PASS TEST 1: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
            pass_count = pass_count + 1;
        end else begin
            $display("%0t: [div_cnt] FAIL TEST 1: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (256*5 + 20)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting

        $display("==============================");
        $display("==TEST 2: DIVIDED BY 2 CHECK==");
        $display("==============================");
        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        write(8'h03, 8'h01); // TIE[0]=1: enable overflow interrupt
        write(8'h00, 8'h09); // TCR: enable counting up with clk_div=01 (divide by 2)

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        $display("%0t: [div_cnt] Started counting with divide by 2 at t1=%0t", $time, t1);
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        $display("%0t: [div_cnt] Overflow interrupt detected at t2=%0t", $time, t2);
        if (t2 - t1 >= (256*5*2 - 26)*1000 && t2 - t1 <= (256*5*2 + 26)*1000) begin
            $display("%0t: [div_cnt] PASS TEST 2: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
            pass_count = pass_count + 1;
        end else begin
            $display("%0t: [div_cnt] FAIL TEST 2: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (256*5*2+26)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting

        $display("==============================");
        $display("==TEST 3: DIVIDED BY 4 CHECK==");
        $display("==============================");
        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        write(8'h03, 8'h01); // TIE[0]=1
        write(8'h00, 8'h11); // TCR: enable counting up

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        $display("%0t: [div_cnt] Started counting with divide by 4 at t1=%0t", $time, t1);
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        $display("%0t: [div_cnt] Overflow interrupt detected at t2=%0t", $time, t2);
        if (t2 - t1 >= (256*5*4 - 51)*1000 && t2 - t1 <= (256*5*4 + 51)*1000) begin
            $display("%0t: [div_cnt] PASS TEST 3: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
            pass_count = pass_count + 1;
        end else begin
            $display("%0t: [div_cnt] FAIL TEST 3: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (256*5*4+51)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting

        $display("==============================");
        $display("==TEST 4: DIVIDED BY 8 CHECK==");
        $display("==============================");
        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        write(8'h03, 8'h01); // TIE[0]=1
        write(8'h00, 8'h19); // TCR: enable counting up with clk_div=8

        @(posedge dut_vif.ker_clk);
        t1 = $time;
        $display("%0t: [div_cnt] Started counting with divide by 8 at t1=%0t", $time, t1);
        wait(dut_vif.int_signal == 1);
        t2 = $time;
        $display("%0t: [div_cnt] Overflow interrupt detected at t2=%0t", $time, t2);
        if (t2 - t1 >= (256*5*8 - 102)*1000 && t2 - t1 <= (256*5*8 + 102)*1000) begin
            $display("%0t: [div_cnt] PASS TEST 4: Counter interrupt timing is correct (delta=%0t ns)", $time, t2-t1);
            pass_count = pass_count + 1;
        end else begin
            $display("%0t: [div_cnt] FAIL TEST 4: Timing incorrect. Expected ~%0d ns, got %0t ns", $time, (256*5*8+102)*1000, t2-t1);
        end
        write(8'h00, 8'h00); // disable counting
    endtask
endclass