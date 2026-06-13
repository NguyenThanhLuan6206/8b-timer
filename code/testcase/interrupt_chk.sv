class interrupt_chk extends base_test;

  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    $display("===========================");
    $display("=====Interrupt CHECK=======");
    $display("===========================");

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
    if (dut_vif.int_signal == 0) 
      $display("%0t: [interrupt check] TEST PASSED", $time);
    else 
      $display("%0t: [interrupt check] TEST FAILED", $time);

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
    if (dut_vif.int_signal == 1) 
      $display("%0t: [interrupt check] TEST PASSED", $time);
    else 
      $display("%0t: [interrupt check] TEST FAILED", $time);

    $display("====disable interrupt underflow====");
    dut_vif.presetn = 1'b0; #20;
    dut_vif.presetn = 1'b1; #20;
    write(8'h00, 8'h03);
    @(posedge dut_vif.pclk);
    repeat(3) @(posedge dut_vif.ker_clk); #1;

    write(8'h00, 8'h00);
    if (dut_vif.int_signal == 0) 
      $display("%0t: [interrupt check] TEST PASSED", $time);
    else 
      $display("%0t: [interrupt check] TEST FAILED", $time);

    $display("====enable interrupt underflow====");
    dut_vif.presetn = 1'b0; #20;
    dut_vif.presetn = 1'b1; #20;
    write(8'h03, 8'h02);
    write(8'h00, 8'h03);
    @(posedge dut_vif.pclk);
    repeat(3) @(posedge dut_vif.ker_clk); #1;

    write(8'h00, 8'h00);
    if (dut_vif.int_signal == 1) 
      $display("%0t: [interrupt check] TEST PASSED", $time);
    else 
      $display("%0t: [interrupt check] TEST FAILED", $time);
  endtask

endclass
