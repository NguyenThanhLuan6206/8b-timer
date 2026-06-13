module TSR(
  input logic pclk,
  input logic presetn,
  input logic wr_en,
  input logic [7:0] paddr,
  input logic [1:0] pwdata10,
  input logic s_ovf_stretched,
  input logic s_udf_stretched,
  output logic [7:0] tsr
);

  logic wr_tsr, ovf_clr, udf_clr;
  logic overflow, underflow;

  assign wr_tsr  = wr_en && (paddr == 8'h01);
  assign ovf_clr = wr_tsr && pwdata10[0];
  assign udf_clr = wr_tsr && pwdata10[1];

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      overflow  <= 1'b0;
    end
    else if (ovf_clr) begin
      overflow <= 1'b0;
    end
    else if (s_ovf_stretched) begin
      overflow <= 1'b1;
    end
    else begin
      overflow <= overflow;
    end
  end


  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      underflow  <= 1'b0;
    end
    else if (udf_clr) begin
      underflow <= 1'b0;
    end
    else if (s_udf_stretched) begin
      underflow <= 1'b1;
    end
    else begin
      underflow <= underflow;
    end
  end

  assign tsr = {6'b0, underflow, overflow};
endmodule
