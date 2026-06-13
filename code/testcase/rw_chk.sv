class rw_chk extends base_test;

  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    $display("===========================");
    $display("=========RW CHECK==========");
    $display("===========================");


    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;

    $display("=======TCR RW CHECK=======");
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h00, 8'h55);
    compare(8'h00, 8'h15);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h00, 8'hAA);
    compare(8'h00, 8'h0A);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h00, 8'hFF);
    compare(8'h00, 8'h1F);

    $display("=======TSR RW CHECK=======");
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h01, 8'h55);
    compare(8'h01, 8'h00);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h01, 8'hAA);
    compare(8'h01, 8'h00);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h01, 8'hFF);
    compare(8'h01, 8'h00);

    $display("=======TDR RW CHECK=======");
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h02, 8'h55);
    compare(8'h02, 8'h55);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h02, 8'hAA);
    compare(8'h02, 8'hAA);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h02, 8'hFF);
    compare(8'h02, 8'hFF);

    $display("=======TIE RW CHECK=======");
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h03, 8'h33);
    compare(8'h03, 8'h03);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h03, 8'hAA);
    compare(8'h03, 8'h02);
    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;
    write(8'h03, 8'h55);
    compare(8'h03, 8'h01);

    test_count = 12;
  endtask
endclass
