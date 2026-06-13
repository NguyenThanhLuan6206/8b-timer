module TIE (
  input logic pclk,
  input logic presetn,
  input logic wr_en,
  input logic [7:0] paddr,
  input logic [1:0] pwdata10,
  output logic [7:0] tie
);
  
  logic overflow_en, underflow_en, wr_tie;

  assign wr_tie = wr_en && (paddr == 8'h03);

  always_ff @(posedge pclk or negedge presetn) begin
    if (!presetn) begin
      overflow_en  <= 1'b0;
      underflow_en <= 1'b0;
    end else if (wr_tie) begin
      overflow_en  <= pwdata10[0];
      underflow_en <= pwdata10[1];
    end else begin
      overflow_en  <= overflow_en;
      underflow_en <= underflow_en;
    end
  end

  assign tie = {6'b0, underflow_en, overflow_en};
endmodule
