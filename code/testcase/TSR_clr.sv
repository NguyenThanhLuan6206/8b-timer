class TSR_clr extends base_test;
  
  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    $display("===========================");
    $display("======TSR_clr CHECK========");
    $display("===========================");
    test_count = 3;

    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;

    write(8'h03, 8'h03);
    write(8'h00, 8'h03);
    @(posedge dut_vif.pclk);
    repeat(2) @(posedge dut_vif.ker_clk);

    write(8'h00, 8'h02);
    write(8'h00, 8'h00);
    write(8'h00, 8'h01);
    @(posedge dut_vif.pclk);
    repeat(20) @(posedge dut_vif.ker_clk);
    write(8'h00, 8'h00);
    write(8'h00, 8'h01);
    repeat(256) @(posedge dut_vif.ker_clk);
    write(8'h00, 8'h00);


    compare(8'h01, 8'h03);
    write(8'h01, 8'h01);
    compare(8'h01, 8'h02);
    write(8'h01, 8'h02);
    compare(8'h01, 8'h00);
  endtask
endclass
