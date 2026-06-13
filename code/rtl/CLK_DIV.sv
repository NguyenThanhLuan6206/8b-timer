module CLK_DIV (
  input logic ker_clk,
  input logic presetn,
  input logic [1:0] clk_div,
  input logic timer_en,
  output logic cnt_en 
);
  logic [2:0] div_val, inter_cnt;
  logic inter_cnt_clr;

  always_comb begin 
    case (clk_div)
      2'b01: div_val = 3'b001;
      2'b10: div_val = 3'b011;
      2'b11: div_val = 3'b111;
      default : div_val = 3'b000;
    endcase
  end

  assign inter_cnt_clr = timer_en && (inter_cnt == div_val);

  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) 
      inter_cnt <= 3'b0;
    else if (inter_cnt_clr)
      inter_cnt <= 3'b0;
    else if (timer_en)
      inter_cnt <= inter_cnt + 1;
    else 
      inter_cnt <= inter_cnt;
  end

  assign cnt_en = timer_en && (inter_cnt == div_val);
endmodule
