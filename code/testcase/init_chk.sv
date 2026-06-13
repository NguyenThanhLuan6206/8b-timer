class init_chk extends base_test;

  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    $display("===========================");
    $display("=======INITIAL CHECK=======");
    $display("===========================");


    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;

    compare(8'h00, 8'h00);
    compare(8'h01, 8'h00);
    compare(8'h02, 8'h00);
    compare(8'h03, 8'h00);

    test_count = 4;
  endtask
endclass
