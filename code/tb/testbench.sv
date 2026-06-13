`timescale 1ns/1ps

module testbench; 
  import timer_pkg::*;
  import test_pkg::*;
 
  dut_if d_if();

  timer_top u_dut(
    .ker_clk(d_if.ker_clk),       
    .pclk(d_if.pclk),       
    .presetn(d_if.presetn),    
    .psel(d_if.psel),       
    .penable(d_if.penable),    
    .pwrite(d_if.pwrite),     
    .paddr(d_if.paddr),      
    .pwdata(d_if.pwdata),     
    .prdata(d_if.prdata),     
    .pready(d_if.pready),     
    .int_signal(d_if.int_signal),
    .pslverr(d_if.pslverr)
  );

  initial begin
    d_if.presetn = 0;
    #100ns d_if.presetn = 1;
  end

  // 50 MHz
  initial begin
    d_if.pclk = 0;
    forever begin 
      #10ns;
      d_if.pclk = ~d_if.pclk;
    end
  end
 
  // 200 MHz
  initial begin
    d_if.ker_clk = 1;
    forever begin 
      #2.5ns;
      d_if.ker_clk = ~d_if.ker_clk;
    end
  end

  string test;
  base_test base;
  init_chk init_chk_test;
  rw_chk rw_chk_test;
  rst_fly rst_fly_test;
  TSR_clr TSR_clr_test;
  reversed_chk reversed_chk_test;
  interrupt_chk interrupt_chk_test;
  std_cnt std_cnt_test;
  div_cnt div_cnt_test;
  rst_cnt rst_cnt_test;
  ld_cnt ld_cnt_test;
  div_cnt_down div_cnt_down_test;


  initial begin
    wait(d_if.presetn == 1); #1;
    if ($value$plusargs("TESTNAME=%s", test)) begin
      $display("testname provided: %s", test);
      if (test == "init_chk") begin
        init_chk_test = new();
        base = init_chk_test;
      end
      else if (test == "rw_chk") begin
        rw_chk_test = new();
        base = rw_chk_test;
      end
      else if (test == "rst_fly") begin
        rst_fly_test = new();
        base = rst_fly_test;
      end
      else if (test == "TSR_clr") begin
        TSR_clr_test = new();
        base = TSR_clr_test;
      end
      else if (test == "reversed_chk") begin
        reversed_chk_test = new();
        base = reversed_chk_test;
      end
      else if (test == "interrupt_chk") begin
        interrupt_chk_test = new();
        base = interrupt_chk_test;
      end
      else if (test == "std_cnt") begin
        std_cnt_test = new();
        base = std_cnt_test;
      end
      else if (test == "div_cnt") begin
        div_cnt_test = new();
        base = div_cnt_test;
      end
      else if (test == "rst_cnt") begin
        rst_cnt_test = new();
        base = rst_cnt_test;
      end
      else if (test == "ld_cnt") begin
        ld_cnt_test = new();
        base = ld_cnt_test;
      end
      else if (test == "div_cnt_down") begin
        div_cnt_down_test = new();
        base = div_cnt_down_test;
      end
      else begin
        $display("Unknown TESTNAME provided. Run default test");
        init_chk_test = new();
        base = init_chk_test;
      end
    end else begin
      $display("No testname provided. Run default test");
      init_chk_test = new();
      base = init_chk_test;
    end
    base.dut_vif = d_if;
    base.run_test();
    #1ms;
    $display("[testbench] Time out....Seems your tb is hang!");
    $finish;
  end
    
endmodule
