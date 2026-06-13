module APB_SLAVE(
  input logic pclk,
  input logic presetn,
  input logic psel,
  input logic penable,
  input logic pwrite,
  output logic wr_en,
  output logic rd_en,
  output logic pready
);
  always @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      wr_en <= 1'b0;
      rd_en <= 1'b0;
    end
    else begin
      wr_en <= (psel & penable & pwrite & ~wr_en);
      rd_en <= (psel & penable & ~pwrite & ~rd_en);
    end
  end

  assign pready = (wr_en || rd_en);
endmodule
