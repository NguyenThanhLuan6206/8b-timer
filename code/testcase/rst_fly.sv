class rst_fly extends base_test;
  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    $display("===========================");
    $display("==RESET ON THE FLY CHECK===");
    $display("===========================");


    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;

    $display("=TCR RST ON THE FLY CHECK==");
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;

    write(8'h00, 8'hFF);
    compare(8'h00, 8'h1F);
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;
    compare(8'h00, 8'h00);

    $display("=TSR RST ON THE FLY CHECK==");
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;

    write(8'h03, 8'h03);
    write(8'h00, 8'h03);
    @(posedge dut_vif.pclk);
    repeat(2) @(posedge dut_vif.ker_clk);
    compare(8'h01, 8'h02);
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;
    compare(8'h01, 8'h00);


    $display("=TDR RST ON THE FLY CHECK==");
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;

    write(8'h02, 8'hFF);
    compare(8'h02, 8'hFF);
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;
    compare(8'h02, 8'h00);   

    $display("=TIE RST ON THE FLY CHECK==");
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;

    write(8'h03, 8'hFF);
    compare(8'h03, 8'h03);
    dut_vif.presetn <= 1'b0; #5;
    dut_vif.presetn <= 1'b1; #5;
    compare(8'h03, 8'h00);

    test_count = 8;
  endtask

endclass
