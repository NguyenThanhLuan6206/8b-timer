module TCR(
  input  logic       pclk,
  input  logic       presetn,
  input  logic       wr_en,
  input  logic [7:0] paddr,
  input  logic [4:0] pwdata40,
  output logic [7:0] tcr,
  output logic       falling_edge,
  output logic       pslverr
);
  logic wr_tcr, wr_tcr_clean;
  logic timer_en_delay;

  logic timer_en, count_down, load;
  logic [1:0] clk_div;

  assign wr_tcr       = (paddr === 8'h00) && wr_en;
  assign pslverr      = wr_tcr && tcr[0] && (pwdata40[4:1] != tcr[4:1]);
  assign wr_tcr_clean = wr_tcr && ~pslverr;

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      timer_en   <= 1'b0;
      count_down <= 1'b0;
      load       <= 1'b0;
      clk_div    <= 2'b00;
    end else if (wr_tcr_clean) begin
      timer_en   <= pwdata40[0];
      count_down <= pwdata40[1];
      load       <= pwdata40[2];
      clk_div    <= pwdata40[4:3];
    end else begin
      timer_en   <= timer_en;
      count_down <= count_down;
      load       <= load;
      clk_div    <= clk_div;
    end
  end

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      timer_en_delay <= 1'b0;
    end
    else begin
      timer_en_delay <= timer_en;
    end
  end

  assign falling_edge = timer_en_delay & ~timer_en;


  assign tcr = {3'b000, clk_div, load, count_down, timer_en};

endmodule
