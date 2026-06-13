class reversed_chk extends base_test;
  
  function new();
    super.new();
  endfunction

  virtual task run_scenario();
    $display("===========================");
    $display("=====Reversed CHECK========");
    $display("===========================");

    dut_vif.presetn <= 1'b0; #20;
    dut_vif.presetn <= 1'b1; #20;

    $display("=======TCR Revered CHECK=======");
    write(8'h00, 8'hE0);
    compare(8'h00, 8'h00);

    $display("=======TIE Revered CHECK=======");
    write(8'h00, 8'hE0);
    write(8'h03, 8'hFC);
    compare(8'h03, 8'h00);

    $display("=======Addr Reversed CHECK=======");
    for (int i = 0; i < 256; i++) begin
      if (i == 8'h00 || i == 8'h01 || i == 8'h02 || i == 8'h03) 
        continue;

      compare(i, 8'h00);
    end

    test_count = 254;
  endtask
endclass
