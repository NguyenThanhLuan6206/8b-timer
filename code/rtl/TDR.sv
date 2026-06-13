module TDR(
  input logic pclk,
  input logic presetn,
  input logic wr_en,
  input logic [7:0] paddr,
  input logic [7:0] pwdata,
  output logic [7:0] tdr
);
  logic wr_tdr;
  assign wr_tdr = wr_en && (paddr == 8'h02);

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn)
      tdr <= 8'h0;
    else if (wr_tdr) 
      tdr <= pwdata;
    else 
      tdr <= tdr;
  end
endmodule
