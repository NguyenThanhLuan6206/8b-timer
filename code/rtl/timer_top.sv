module timer_top(
    input  logic        ker_clk,
    input  logic        pclk,
    input  logic        presetn,
    input  logic [7:0]  paddr,
    input  logic        psel,
    input  logic        penable,
    input  logic        pwrite,
    input  logic [7:0]  pwdata,
    output logic        pready,
    output logic [7:0]  prdata,
    output logic        int_signal,
    output logic        pslverr
);
  logic wr_en, rd_en;
  logic s_ovf_stretched, s_udf_stretched;
  logic cnt_en;

  logic [7:0] tcr, tsr, tdr, tie;

  logic falling_edge;

  logic [7:0] cnt;

  APB_SLAVE apb_slave(
    .pclk(pclk),
    .presetn(presetn),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .pready(pready)
  );

  TCR my_TCR(
    .pclk(pclk),
    .presetn(presetn),
    .wr_en(wr_en),
    .paddr(paddr),
    .pwdata40(pwdata[4:0]),
    .tcr(tcr),
    .falling_edge(falling_edge),
    .pslverr(pslverr)
  );

  TSR my_TSR(
    .pclk(pclk),
    .presetn(presetn),
    .wr_en(wr_en),
    .paddr(paddr),
    .pwdata10(pwdata[1:0]),
    .s_ovf_stretched(s_ovf_stretched),
    .s_udf_stretched(s_udf_stretched),
    .tsr(tsr)
  );

  TDR my_TDR(
    .pclk(pclk),
    .presetn(presetn),
    .wr_en(wr_en),
    .paddr(paddr),
    .pwdata(pwdata),
    .tdr(tdr)
  );

  TIE my_TIE(
    .pclk(pclk),
    .presetn(presetn),
    .wr_en(wr_en),
    .paddr(paddr),
    .pwdata10(pwdata[1:0]),
    .tie(tie)
  );

  always_comb begin
    if (rd_en) begin
      case (paddr)
        8'h00: prdata = tcr;
        8'h01: prdata = tsr;
        8'h02: prdata = tdr;
        8'h03: prdata = tie;
        default : prdata = 8'h0;
      endcase
    end
    else begin
      prdata = 8'h0;
    end
  end

  CLK_DIV my_CLK_DIV(
    .ker_clk(ker_clk),
    .presetn(presetn),
    .clk_div(tcr[4:3]),
    .timer_en(tcr[0]),
    .cnt_en(cnt_en)
  );

  COUNTER my_COUNTER(
    .ker_clk(ker_clk),
    .presetn(presetn),
    .count_down(tcr[1]),
    .cnt_en(cnt_en),
    .falling_edge(falling_edge),
    .load(tcr[2]),
    .tdr(tdr),
    .cnt(cnt)
  );

  INTERRUPT my_INTERRUPT(
    .ker_clk(ker_clk),
    .presetn(presetn),
    .cnt_en(cnt_en),
    .count_down(tcr[1]),
    .load(tcr[2]),
    .cnt(cnt),
    .tsr01(tsr[1:0]),
    .tie01(tie[1:0]),
    .s_ovf_stretched(s_ovf_stretched),
    .s_udf_stretched(s_udf_stretched),
    .int_signal(int_signal)
  );

endmodule
