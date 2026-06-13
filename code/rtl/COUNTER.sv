module COUNTER (
  input logic ker_clk,
  input logic presetn,
  input logic count_down,
  input logic cnt_en,
  input logic falling_edge,
  input logic load,
  input logic [7:0] tdr,
  output logic [7:0] cnt
);

  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      cnt <= 8'b0;
    end else if (load) begin
      cnt <= tdr;
    end else if (falling_edge) begin
      cnt <= 8'b0;
    end else if (cnt_en) begin
      if (count_down) begin
        cnt <= cnt - 1;
      end else begin
        cnt <= cnt + 1;
      end
    end else begin
      cnt <= cnt;
    end
  end
  
endmodule
