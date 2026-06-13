module INTERRUPT (
  input logic ker_clk,
  input logic presetn,
  input logic cnt_en,
  input logic count_down,
  input logic load,
  input logic [7:0] cnt,
  input logic [1:0] tsr01,
  input logic [1:0] tie01,
  output logic s_ovf_stretched,
  output logic s_udf_stretched,
  output logic int_signal
);
  logic s_ovf, s_udf;
  logic ovf_1_delay, ovf_2_delay, ovf_3_delay, ovf_4_delay;
  logic udf_1_delay, udf_2_delay, udf_3_delay, udf_4_delay;

  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      s_ovf <= 1'b0;
    end else if (~load & cnt_en) begin
      if (~count_down && (cnt[7:0] == 8'hFF)) begin
        s_ovf <= 1'b1;
      end
      else begin
        s_ovf <= 1'b0;
      end
    end else begin
      s_ovf <= 1'b0;
    end
  end


  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      s_udf <= 1'b0;
    end else if (~load & cnt_en) begin
      if (count_down && (cnt[7:0] == 8'h00)) begin
        s_udf <= 1'b1;
      end
      else begin
        s_udf <= 1'b0;
      end
    end else begin
      s_udf <= 1'b0;
    end
  end

  assign int_signal = (tsr01[0] && tie01[0]) || (tsr01[1] && tie01[1]);

  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      ovf_1_delay <= 1'b0;
      ovf_2_delay <= 1'b0;
      ovf_3_delay <= 1'b0;
      ovf_4_delay <= 1'b0;
    end else if (s_ovf) begin
      ovf_1_delay <= 1'b1;
      ovf_2_delay <= 1'b1;
      ovf_3_delay <= 1'b1;
      ovf_4_delay <= 1'b1;
    end else begin
      ovf_1_delay <= 1'b0;
      ovf_2_delay <= ovf_1_delay;
      ovf_3_delay <= ovf_2_delay;
      ovf_4_delay <= ovf_3_delay;
    end
  end

  assign s_ovf_stretched = ovf_1_delay | ovf_2_delay | ovf_3_delay | ovf_4_delay;


  always_ff @(posedge ker_clk or negedge presetn) begin
    if (!presetn) begin
      udf_1_delay <= 1'b0;
      udf_2_delay <= 1'b0;
      udf_3_delay <= 1'b0;
      udf_4_delay <= 1'b0;
    end else if (s_udf) begin
      udf_1_delay <= 1'b1;
      udf_2_delay <= 1'b1;
      udf_3_delay <= 1'b1;
      udf_4_delay <= 1'b1;
    end else begin
      udf_1_delay <= 1'b0;
      udf_2_delay <= udf_1_delay;
      udf_3_delay <= udf_2_delay;
      udf_4_delay <= udf_3_delay;
    end
  end

  assign s_udf_stretched = udf_1_delay | udf_2_delay | udf_3_delay | udf_4_delay;

endmodule
