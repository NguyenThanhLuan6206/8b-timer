class rst_cnt extends base_test;
    function new();
        super.new();
    endfunction
    task run_scenario;  
        $display("============================");
        $display("=====Reset Count CHECK======");
        $display("============================");

        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        write(8'h00, 8'h01);
        repeat(125) @(posedge dut_vif.ker_clk); #1;
        dut_vif.presetn <= 1'b0; #20;
        dut_vif.presetn <= 1'b1; #20;
        compare(8'h00, 8'h00);
        compare(8'h01, 8'h00);
        compare(8'h02, 8'h00);
        compare(8'h03, 8'h00);
    endtask
endclass