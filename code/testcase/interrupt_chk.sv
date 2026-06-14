class interrupt_chk extends base_test;

  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    $display("===========================");
    $display("=====Interrupt CHECK=======");
    $display("===========================");

    test_count = 4;
    $display("====disable interrupt overflow====");
    dut_vif.presetn = 1'b0; #20;
    dut_vif.presetn = 1'b1; #20;
    write(8'h02, 8'hFF);
    write(8'h00, 8'h04);
    write(8'h00, 8'h00);
    write(8'h00, 8'h01);
    @(posedge dut_vif.pclk);
    repeat(3) @(posedge dut_vif.ker_clk); #1;

    write(8'h00, 8'h00);
    if (dut_vif.int_signal == 0) begin
      $display("%0t: [interrupt check] PASS TEST", $time);
      pass_count = pass_count + 1;
    end else 
      $display("%0t: [interrupt check] FAIL TEST", $time);

    $display("====enable interrupt overflow====");
    dut_vif.presetn = 1'b0; #20;
    dut_vif.presetn = 1'b1; #20;
    write(8'h02, 8'hFF);
    write(8'h03, 8'h01);
    write(8'h00, 8'h04);
    write(8'h00, 8'h00);
    write(8'h00, 8'h01);
    @(posedge dut_vif.pclk);
    repeat(3) @(posedge dut_vif.ker_clk); #1;

    write(8'h00, 8'h00);
    if (dut_vif.int_signal == 1) begin
      $display("%0t: [interrupt check] PASS TEST", $time); 
      pass_count = pass_count + 1;
    end else 
      $display("%0t: [interrupt check] FAIL TEST", $time);

    $display("====disable interrupt underflow====");
    dut_vif.presetn = 1'b0; #20;
    dut_vif.presetn = 1'b1; #20;
    write(8'h00, 8'h03);
    @(posedge dut_vif.pclk);
    repeat(3) @(posedge dut_vif.ker_clk); #1;

    write(8'h00, 8'h00);
    if (dut_vif.int_signal == 0) begin
      $display("%0t: [interrupt check] PASS TEST", $time);
      pass_count = pass_count + 1;
    end else 
      $display("%0t: [interrupt check] FAIL TEST", $time);

    $display("====enable interrupt underflow====");
    dut_vif.presetn = 1'b0; #20;
    dut_vif.presetn = 1'b1; #20;
    write(8'h03, 8'h02);
    write(8'h00, 8'h03);
    @(posedge dut_vif.pclk);
    repeat(3) @(posedge dut_vif.ker_clk); #1;

    write(8'h00, 8'h00);
    if (dut_vif.int_signal == 1) begin
      $display("%0t: [interrupt check] PASS TEST", $time);
      pass_count = pass_count + 1;
    end else 
      $display("%0t: [interrupt check] FAIL TEST", $time);
  endtask

endclass
